#!/usr/bin/perl

use strict;
use POSIX;
use Data::Dumper qw(Dumper);

my $TABWIDTH=8;

sub usage($) {
	my ($msg) = @_;

	if ($msg) {
		print STDERR "$msg\n";
	}

	die "microcode.pl <input.txt> <output folder>\n";


}

sub header($) {
	my ($fh) = @_;

	print $fh "// This file was generated with microcode.pl - DO NOT EDIT\n";
	print $fh "\n";
}

# output enough tabs and spaces to pad a string of length $l to $w, $TABWIDTH defines tab size
# NOTE: $w2 will be rounded up to next TAB stop
sub pad($$) {	
	my ($l, $w) = @_;
	my $w2 = $TABWIDTH * ceil($w/$TABWIDTH);

	$w2 -= $l;

	return "\t" x ceil($w2/$TABWIDTH);
}

sub bounds_check($$$) {
	my ($val, $cur_section, $curs) = @_;

	if ($curs->{type} eq "INDEX") {
		$val < 2**$curs->{size} || die sprintf "Value (%d) too large for INDEX size %s:%d", $val, $cur_section, $curs->{size};
	} elsif ($curs->{type} eq "BITMAP" || $curs->{type} eq "ONEHOT") {
		$val < 2**$curs->{size} || die sprintf "Value (%d) too large for BITMAP/ONEHOT size %s:%d", $val, $cur_section, $curs->{size};		
		$curs->{type} eq "ONEHOT" && countbits($val) > 1 && die sprintf "More than one bit (%b) set in ONEHOT %s", $val, $cur_section;
	} elsif ($curs->{type} eq "SIGNED") {
		(
			$val >= -(2**($curs->{size}-1))
		&&	$val < (2**($curs->{size}-1))
		)	|| die sprintf "Value (%d) too large for SIGNED size %s:%d", $val, $cur_section, $curs->{size};
	} else {
		die "Unknown type ($curs->{type}) in bounds_check $cur_section";
	}
}

sub parseval($$$) {
	my ($vs,$cur_section,$curs) = @_;

	if ($vs =~ /^([^\|]+)\|(.*)$/) {
		return parseval($1,$cur_section,$curs) | parseval($2,$cur_section,$curs);
	} else {
		if ($vs =~ /^[a-zA-Z]/) {
			my ($vv) = grep { $vs eq $_->{name} } @{$curs->{values}};
			if (!$vv) {
				($vv) = grep { $vs eq $_->{name} } @{$curs->{named_values}};
			}
			if (!$vv) {
				($vv) = grep { $vs eq $_->{name} } @{$curs->{indices}};
				if ($vv) {
					return $vv;
				}
			}
			$vv || die "Cannot find value $vs in section $cur_section in parseval";
			return parseval($vv->{value}, $cur_section, $curs);
		} else {
			$vs =~ /^\d*\'([dbx])(.*?)\s*$/ || die "Expecting numeric literal got \"$vs\" in parseval";
			my ($base, $v) = ($1, $2);
			if ($base eq "b") {
				return oct("0b" . $v);
			} elsif ($base eq "d") {
				return $v;
			} elsif ($base eq "h") {
				return hex($v);
			} else {
				die "Unexpected base ($base) in parseval";
			}
		} 
	}
}

sub countbits($) {
	my ($v) = @_;
	my $count = 0;
	while ($v) {
		if ($v & 0x1) {
			$count++;
		}

		$v >>= 1;
	}
	return $count;
}

# find nearest label before the index, return label, offset
sub find_label_before($$) {
	my ($lab_hash, $ix) = @_;
	my $offs = $ix;
	my $ret = "";
	for my $k (keys(%$lab_hash)) {
		my $kix = $lab_hash->{$k};
		if ($kix <= $ix && $ix - $kix < $offs)
		{
			$offs = $ix - $kix;
			$ret = $k
		}
	}
	return ($ret, $offs);
}

my $fn_in = shift || usage "No input file";
my $dir_out = shift || usage "No output directory";
-d $dir_out || usage "$dir_out is not a directory";

my $fn_out_v = "$dir_out/scmp_microcode_pla.gen.sv";
my $fn_out_pak = "$dir_out/scmp_microcode_pla.gen.pak.sv";
my $fn_out_oppc = "$dir_out/scmp_microcode_oppc.gen.sv";

open(my $fh_in, "<", $fn_in) || die "Cannot open \"$fn_in\" for input";


######################################################################
#  __        __   __   ___            __       ___					 #
# |__)  /\  |__) /__` |__     | |\ | |__) |  |  |					 #
# |    /~~\ |  \ .__/ |___    | | \| |    \__/  |					 #
#																	 #
######################################################################

my $state = 0; #state machine for reading input 0 = defs, 1 = code
my $cur_section;
my %sections = ();
my @secorder = ();
my $code_ix = 0;
my %code_labels = ();
my $tot_size = 0;

my $sz_pc;

my @microcode=();
my @branches=();
my @decoder=();
my @menmonics=();

PARSE_M_LOOP:while (<$fh_in>) {
	my $l = $_;
	$l =~ s/[\s|\r]+$//;
	$l =~ s/\s*#.*//;

	if ($l =~ /^\s*#/ || $l =~ /^\s*$/) {
		#ignore it's a comment or blank
	} elsif ($state == 0) {
		# definitions
		if ($l =~ /^SECTION:([A-Za-z]\w*),(BITMAP|ONEHOT|INDEX|SIGNED),(\d+)/) {
			$cur_section = $1;
			my $cur_sec_type = $2;
			my $cur_sec_size = $3;
			my $cur_sec_ix = 0;

			if (exists $sections{$cur_section}) {
				die "repeated section $cur_section";
			}

			$sections{$cur_section} = {
				type => $cur_sec_type,
				size => $cur_sec_size,
				maxix => $cur_sec_ix,
				indices => [],
				values => [],
				named_values => []
			};
			push @secorder, $cur_section;
			$tot_size += $cur_sec_size;

		} elsif ($l =~ /^\s+([A-Za-z]\w*)\s*=\s*NUL\s*(\*)?\s*$/) {
			#special case NUL
			my $name = $1;
			my $def = $2;
			my $curs = $sections{$cur_section};

			$curs || die "Values before section";

			if ($def) {
				$curs->{def} = $name;
			}
			push @{$curs->{named_values}}, {
				name => $name,
				value => $curs->{size} . '\'d0'
			};
		} elsif ($l =~ /^\s+([A-Za-z]\w*)\s*=\s*([^*]+)(\*)?\s*$/i) {
			#named value
			my $name = $1;
			my $val = $2;
			my $def = $3;
			my $curs = $sections{$cur_section};

			$curs || die "Values before section";

			if ($def) {
				$curs->{def} = $name;
			}

			if ($val =~ /^\'/)
			{
				$val = $curs->{size} . $val;				
			}

			bounds_check(parseval($val,$cur_section,$curs),$cur_section,$curs);

			push @{$curs->{named_values}}, {
				name => $name,
				value => $val
			};
		} elsif ($l =~ /\s+([A-Za-z]\w*)(\*?)\s*$/) {
			my $name = $1;
			my $def = $2;
			my $curs = $sections{$cur_section};
			my $type = $curs->{type};
			my $size = $curs->{size};

			$curs || die "Values before section";

			my $ix = $curs->{maxix};

			if ($def) {
				$curs->{def} = $name;
			}

			if ($type eq "INDEX") {
				bounds_check($ix, $cur_section, $curs);
				push @{$curs->{indices}}, {
					name => $name,
					value => $ix
				};
			} elsif ($type eq "ONEHOT" || $type eq "BITMAP" ) {
				bounds_check(2**$ix, $cur_section, $curs);
				push @{$curs->{indices}}, {
					name => $name,
					value => "'d" . $ix
				};
				push @{$curs->{values}}, {
					name => $name,
					value => $size . "'b" . "0" x ($size - $ix - 1) . "1" . "0" x $ix
				};
			} else {
				die "Attempt add bare value when TYPE != INDEX, ONEHOT or BITMAP";
			}

			$curs->{maxix} = $ix + 1;


		} elsif ($l =~ /^\s*CODESTART=(\d+)\s*$/) {
			$state = 1;	

			$sz_pc = $1;
		
		} else {
			die "unrecognized line in definitions section : $l";
		}
	} elsif ($state == 1) {
		# microcode

		if ($l =~ /^\s*DECODER=.*$/) {
			$state = 2;	
			next PARSE_M_LOOP;
		}

		if ($l =~ /^(\w+):(\s*)(.*?)$/) {
			$l = " " . $3;
			$code_labels{$1} = $code_ix;
			push @microcode, {type=>"COMMENT", comment=>"$1 = $code_ix"};
		}

		if ($l =~ /^\s*(\s*\w+\s*=\s*@?\w+)(\s*,\s*(\s*\w+=\s*@?\w+))*\s*$/) {
			my @parms2 = split(/\s*,\s*/, $l);

			my %params = ();
			foreach my $p (@parms2) {
				my @pp = split(/\s*=\s*/, $p);
				scalar @pp == 2 || die "Bad code parameter $p";
				my ($sec, $lbl) = @pp;

				$sec =~ s/\s+//;
				$lbl =~ s/\s+//;


				$params{$sec} = $lbl;				
			}

			my @mc_vals = ();
			foreach my $sec (@secorder) {
				my $curs = $sections{$sec};				

				$curs || die "missing section $sec";

				my $ps = $params{$sec};
				if ($ps && $ps =~ /^@(\w+)$/) {
					push @mc_vals, "UCLBL_$1-$curs->{size}'d$code_ix";
					push @branches, {from=>$code_ix, to=>$1};
				} else {
					my $v;
					if (!$ps || !($ps =~ /^UCLBL_/))
					{
						$v = "${sec}_";
					} 

					if ($ps) {
						parseval($ps, $sec, $curs); #check it exists						
						$v .= $ps;
					} elsif (exists $curs->{def}) {
						$v .= $curs->{def};
					} else {
						die "No default value for $sec and none supplied in this line";
					}	
					push @mc_vals, $v;	
				}	
			}
			push @microcode, {type=>"MICROCODE", code_ix=>$code_ix, vals=>\@mc_vals};	
			$code_ix++;

			foreach my $pk (keys %params) {
				if (!exists $sections{$pk}) {
					die "unknown parameter \"$pk\"";
				}
			}

		} else {

			$l =~ /^\s*$/ ||
				die "unrecognized line in code section : $l";
			
		}

	} elsif ($state == 2) {
		# decode array

		if ($l =~ /^\s*MNEMONICS=.*$/) {
			$state = 3;	
			next PARSE_M_LOOP;
		}


		if ($l =~ /([01-]{8})\s+(\w+)/) {
			my ($pat, $lab) = ($1, $2);	
			my $mas = $pat =~ tr/01-/110/r;	
			my $xor = $pat =~ tr/01-/010/r;	

			push @decoder, {
				lab => $lab,
				mask => oct ("0b$mas"),
				xor => oct ("0b$xor")
			};
		}

	} elsif ($state == 3) {
		# opcode array

		if ($l =~ /([01-]{8})\s+(\w+)/) {
			my ($pat, $lab) = ($1, $2);	
			my $mas = $pat =~ tr/01-/110/r;	
			my $xor = $pat =~ tr/01-/010/r;	

			push @menmonics, {
				lab => $lab,
				mask => oct ("0b$mas"),
				xor => oct ("0b$xor")
			};
		} else {
			die "bad opocode line : $l";
		}

	} else {
		die "unimplemented state=$state";
	}
}

my $code_bits = 0; 
while ($code_ix > (1<<$code_bits)) {
	$code_bits++;
}

###############################################################################
#                         __   ___     __   __             __        ___  __
# /\  |\ |  /\  |    \ / /__` |__     |__) |__)  /\  |\ | /  ` |__| |__  /__`
#/~~\ | \| /~~\ |___  |  .__/ |___    |__) |  \ /~~\ | \| \__, |  | |___ .__/
#
###############################################################################
# analyse branch distances to ascertain number of bit required

printf "microcode length %d (max=0x%02x), bits=%d\n", $code_ix, $code_ix-1, $code_bits;

my $min_bra=0; 		# smallest (poss. negative)
my $max_bra=0; 		# larges positive
my $bra_bits = 0;	# number of bits needed
my $big_bra=0;		# largest magnitude
my $big_bra_desc="";# labels from->to
for my $b (@branches) {
	my ($from, $to_label) = ($b->{from}, $b->{to});
	my $to = %code_labels{$to_label};
	my ($from_label, $from_label_offs) = find_label_before(\%code_labels, $from);

	defined($to) || die "No label $to_label"; 

	my $disp = $to-$from;
	if ($disp < $min_bra) {
		$min_bra = $disp;

		my $i = 0; 
		while ($min_bra < -(1<<$i)) {
			$i++;
		}
		if ($i > $bra_bits) {
			$bra_bits = $i;
		}
	}
	if ($disp > $max_bra) {
		$max_bra = $disp;

		my $i = 0; 
		while ($max_bra > ((1<<$i)-1)) {
			$i++;
		}
		if ($i > $bra_bits) {
			$bra_bits = $i;
		}

	}
	if (abs($disp) > $big_bra) {
		$big_bra = abs($disp);
		$big_bra_desc = "${from_label}+${from_label_offs}->${to_label}";
	} elsif (abs($disp) == $big_bra) {
		$big_bra_desc = $big_bra_desc . "; ${from_label}+${from_label_offs}->${to_label}";
	}
}

printf "branch range %d<x<%d (0x%02x<x<0x%02x), bits=%d\n", $min_bra, $max_bra, $min_bra & 0xfff, $max_bra, $bra_bits+1;
printf "largest branch : %d : %s\n", $big_bra, $big_bra_desc;


# report the decoder array as a table of microop labels

print "menmonics to micrcode lables table\n";
print "m\\l|";
foreach my $c (0..15) {
	printf "   %1x |", $c;
}
print "\n";

foreach my $r (0..15) {
	printf "   |-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|\n";
	printf "%1x  |", $r;
	foreach my $c (0..15) {
		my $opc = ($r << 4) + $c;

		my $fnd;
		# find in decoder table
		DD:foreach my $d (@decoder) {
			if ((($opc ^ $d->{xor}) & $d->{mask}) == 0) {
				$fnd = $d->{lab};
				last DD; 
			}
		}
		
		$fnd =~ s/FETCH/-/;

		printf "%5s|", $fnd;

	}
	print "\n   |";

	foreach my $c (0..15) {
		my $opc = ($r << 4) + $c;

		my $fndop;
		# find in menmonics table
		DD2:foreach my $d (@menmonics) {
			if ((($opc ^ $d->{xor}) & $d->{mask}) == 0) {
				$fndop = $d->{lab};
				last DD2; 
			}
		}

		printf "%5s|", $fndop;

	}
	print "\n";
}

##############################################################################
#  __       ___  __       ___     __   ___  __   __   __   ___  __
# /  \ |  |  |  |__) |  |  |     |  \ |__  /  ` /  \ |  \ |__  |__)
# \__/ \__/  |  |    \__/  |     |__/ |___ \__, \__/ |__/ |___ |  \
# 
##############################################################################
#TODO: move delay bodge to microcode as an extra flag
open(my $fh_out_oppc, ">", $fn_out_oppc) || die "Cannot open \"$fn_out_oppc\" for output";

print $fh_out_oppc "import scmp_microcode_pak::*;

module scmp_microcode_oppc (
input\tlogic\t[7:0]\top,
output\tNEXTPC_t\t\top_pc,
output\tlogic\t\t\top_dly
);

\talways_comb begin
\t\top_dly <= 1'b0;
";
	my $df = 1;
	foreach my $d (@decoder) {

		print $fh_out_oppc "\t\t";
		if ($df) {
			$df = 0;
		} else {
			print $fh_out_oppc "else ";		
		}
		printf $fh_out_oppc "if (((op ^ 8'b%08b) & 8'b%08b) == 8'b00000000)\n", $d->{xor}, $d->{mask};
        if ($d->{lab} eq "DLY") {
            printf $fh_out_oppc "\t\tbegin\n";
        }
        printf $fh_out_oppc "\t\t\top_pc <= UCLBL_%s;\n", $d->{lab};
        if ($d->{lab} eq "DLY") {
            printf $fh_out_oppc "\t\t\top_dly <= 1'b1;\n";
        }
        if ($d->{lab} eq "DLY") {
            printf $fh_out_oppc "\t\tend\n";
        }
	}

print $fh_out_oppc "\t\telse
\t\t\top_pc <= UCLBL_ILLEGAL;
\tend
endmodule";

close($fh_out_oppc);


##############################################################################
#  __       ___  __       ___     __
# /  \ |  |  |  |__) |  |  |     |__) |     /\
# \__/ \__/  |  |    \__/  |     |    |___ /~~\
# 
##############################################################################

open(my $fh_out_v, ">", $fn_out_v) || die "Cannot open \"$fn_out_v\" for output";

print $fh_out_v "import scmp_microcode_pak::*;\n";

header $fh_out_v;

print $fh_out_v "module scmp_microcode_pla(\n";
print $fh_out_v "\tinput\tMCODE_PC_t\tpc,\n";
print $fh_out_v "\toutput\tMCODE_t\tmcode\n";
print $fh_out_v ");\n\n";

print $fh_out_v "always_comb begin\n";
print $fh_out_v "\tcase(pc)\n";

print $fh_out_v "\t//\t\t\t\t";

#calculate the maximum length of each section's values/name
for my $i (0 .. $#secorder) {
	my $sec = @secorder[$i];
	my $curs = $sections{$sec};
	my $maxl = length($sec);
	foreach my $m (@microcode) {
		my $ll = length(@{$m->{vals}}[$i]);
		if ($ll > $maxl) {
			$maxl = $ll;
		}
	}

	# add one for space between labels
	$maxl++; 

	$curs->{textw} = $maxl+1;

	print $fh_out_v $sec;
	print $fh_out_v pad(length($sec), $maxl);
}

foreach my $m (@microcode) {
	if ($m->{type} eq "COMMENT") {
		print $fh_out_v "\t// $m->{comment}\n";
	} elsif ($m->{type} eq "MICROCODE") {
		print $fh_out_v "\t\t${sz_pc}'d$m->{code_ix}:\tmcode =\t{\t";
		
		my $ls = $#{$m->{vals}};
		for my $i (0 .. $ls) {
			my $sec = @secorder[$i];
			my $curs = $sections{$sec};
			my $mcv = @{$m->{vals}}[$i];

			print $fh_out_v $mcv;
			if ($i == $ls) {
				print $fh_out_v pad(length($mcv), $curs->{textw});
			} else {
				print $fh_out_v "," . pad(length($mcv)+1, $curs->{textw});
			}
		}

		print $fh_out_v "};\n";

	} else {
		die "Unexpected type";
	}
}

print $fh_out_v "\t\tdefault:mcode = {\t";
my $ls = $#secorder;
for my $i ( 0 .. $ls ) {
	my $sec = @secorder[$i];
	my $curs = $sections{$sec};

	my $def = $curs->{def};
	if (!$def) {
		$def = @{$curs->{values}}[0]->{name};
	}

	$def = "${sec}_${def}";

	print $fh_out_v $def;
	if ($i == $ls) {
		print $fh_out_v pad(length($def), $curs->{textw});
	} else {
		print $fh_out_v "," . pad(length($def)+1, $curs->{textw});
	}

}
print $fh_out_v "};\n";

#print $fh_out_v "\t\tdefault: mcode = 0;\n";
print $fh_out_v "\tendcase\n";
print $fh_out_v "end\n";
print $fh_out_v "endmodule\n";


open(my $fh_out_pak, ">", $fn_out_pak) || die "Cannot open \"$fn_out_pak\" for output";
print $fh_out_pak "package scmp_microcode_pak;\n";
header $fh_out_pak;

my $first;
foreach my $sec (@secorder) {

	my $curs = $sections{$sec};
	$curs || die "Values before section";
	my $type = $curs->{type};
	my $indices = $curs->{indices};
	my $values = $curs->{values};
	my $named_values = $curs->{named_values};

	print $fh_out_pak "// $sec\n";

	#print $fh_out_pak "`define\tSZ_$sec\t$curs->{size}\n";
	my $szm1 = $curs->{size} - 1;

	if ($type eq "ONEHOT" || $type eq "BITMAP") {
		if (scalar @$indices)	{
			print $fh_out_pak "typedef enum {\n"
		}
		$first = 1;
		for my $nv (@$indices) {
			if ($first) {
				$first = 0;
			} else {
				print $fh_out_pak ",\n";
			}	
			print $fh_out_pak "\t${sec}_IX_$nv->{name}\t= $nv->{value}";
		}
		if (scalar @$indices)	{
			print $fh_out_pak "\n} ${sec}_ix_t;\n"
		}

		if ($type eq "ONEHOT") {
			if (scalar @$values)	{
				print $fh_out_pak "typedef enum logic [$szm1:0] {\n";
			} else {
				print $fh_out_pak "typedef logic [$szm1:0] ${sec}_t;\n";
			}
			$first = 1;
			for my $nv (@$values) {
				if ($first) {
					$first = 0;
				} else {
					print $fh_out_pak ",\n";
				}	
				print $fh_out_pak "\t${sec}_$nv->{name}\t= $nv->{value}";
			}
			if (scalar @$values)	{
				print $fh_out_pak "\n} ${sec}_t;\n"
			}
		} else {
			print $fh_out_pak "typedef logic [$szm1:0] ${sec}_t;\n";
			for my $nv (@$values) {
				print $fh_out_pak "const\t${sec}_t\t${sec}_$nv->{name}\t= $nv->{value};\n";
			}			
		}

		if (scalar @$named_values) {
			print $fh_out_pak "\n";	
		}
		for my $nv (@$named_values) {			
			my $val2 = $nv->{value};
			$val2 =~ s/(?<!')\b([a-z]\w*)\b/${sec}_$1/gi;
			print $fh_out_pak "const\t${sec}_t\t${sec}_$nv->{name}\t= $val2;\n";
		}
	} elsif ($type eq "SIGNED" || $type eq "INDEX") {
		my $szm1 = $curs->{size} - 1;
		print $fh_out_pak "typedef logic " . (($type eq "SIGNED")?"signed":"") . "[$szm1:0] ${sec}_t;\n";
		for my $nv (@$values) {			
			print $fh_out_pak "const\t${sec}_t\t${sec}_$nv->{name}\t= $nv->{value};\n";
		}
		for my $nv (@$named_values) {			
			my $val2 = $nv->{value};
			$val2 =~ s/(?<!')\b([a-z]\w+)\b/${sec}_$1/gi;
			print $fh_out_pak "const\t${sec}_t\t${sec}_$nv->{name}\t= $val2;\n";
		}		
	}	
}

print $fh_out_pak "\n";

print $fh_out_pak "typedef struct packed {\n";
foreach my $sec (@secorder) {
	printf $fh_out_pak "\t${sec}_t\t" . lc(${sec}) . ";\n";
}
print $fh_out_pak "} MCODE_t;\n";


print $fh_out_pak "\n";
print $fh_out_pak "typedef logic [7:0] MCODE_IX_t;\n";
foreach my $lbl (sort keys %code_labels) {
	print $fh_out_pak "const MCODE_IX_t UCLBL_$lbl = ${sz_pc}'d$code_labels{$lbl};\n";
}

printf $fh_out_pak "typedef logic [%d:0] MCODE_PC_t;\n", $sz_pc-1;

print $fh_out_pak "endpackage";

