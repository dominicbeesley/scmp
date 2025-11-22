#!/usr/bin/env perl

use List::Util qw(uniq);

my $fn_in = shift or die "No input file";

open(my $fh_in, "<:raw:", $fn_in) or die "Cannot open $fn_in : $!";

use constant M_RST => 0x40;
use constant M_SI  => 0x20;
use constant M_SB  => 0x10;
use constant M_SA  => 0x08;
use constant M_ADS => 0x02;

use constant SKIP_INSTR => 5;

use constant STATE_RES  => 0;
use constant STATE_NOP  => 1;
use constant STATE_INS  => 2;
use constant STATE_DONE => 3;

use constant D_M_R => 0x10;
use constant D_M_I => 0x20;
use constant D_M_D => 0x40;
use constant D_M_H => 0x80;

my @opcodes = (
    {   match=> 0b11000100, mask => 0b11111111, mne => "LDI"  }, 
    {   match=> 0b11010100, mask => 0b11111111, mne => "ANI"  }, 
    {   match=> 0b11011100, mask => 0b11111111, mne => "ORI"  }, 
    {   match=> 0b11100100, mask => 0b11111111, mne => "XRI"  }, 
    {   match=> 0b11101100, mask => 0b11111111, mne => "DAI"  }, 
    {   match=> 0b11110100, mask => 0b11111111, mne => "ADI"  }, 
    {   match=> 0b11111100, mask => 0b11111111, mne => "CAI"  }, 
    {   match=> 0b11000000, mask => 0b11111000, mne => "LD"  }, 
    {   match=> 0b11001000, mask => 0b11111000, mne => "ST"  }, 
    {   match=> 0b11010000, mask => 0b11111000, mne => "AND"  }, 
    {   match=> 0b11011000, mask => 0b11111000, mne => "OR"  }, 
    {   match=> 0b11100000, mask => 0b11111000, mne => "XOR"  }, 
    {   match=> 0b11101000, mask => 0b11111000, mne => "DAD"  }, 
    {   match=> 0b11110000, mask => 0b11111000, mne => "ADD"  }, 
    {   match=> 0b11111000, mask => 0b11111000, mne => "CAD"  }, 
    {   match=> 0b10101000, mask => 0b11111100, mne => "ILD"  }, 
    {   match=> 0b10111000, mask => 0b11111100, mne => "DLD"  }, 
    {   match=> 0b10010000, mask => 0b11111100, mne => "JMP"  }, 
    {   match=> 0b10010100, mask => 0b11111100, mne => "JP"  }, 
    {   match=> 0b10011000, mask => 0b11111100, mne => "JZ"  }, 
    {   match=> 0b10011100, mask => 0b11111100, mne => "JNZ"  }, 
    {   match=> 0b01000000, mask => 0b11111111, mne => "LDE"  }, 
    {   match=> 0b01001000, mask => 0b11111111, mne => "_"  }, 
    {   match=> 0b01010000, mask => 0b11111111, mne => "ANE"  }, 
    {   match=> 0b01011000, mask => 0b11111111, mne => "ORE"  }, 
    {   match=> 0b01100000, mask => 0b11111111, mne => "XRE"  }, 
    {   match=> 0b01101000, mask => 0b11111111, mne => "DAE"  }, 
    {   match=> 0b01110000, mask => 0b11111111, mne => "ADE"  }, 
    {   match=> 0b01111000, mask => 0b11111111, mne => "CAE"  }, 
    {   match=> 0b00110000, mask => 0b11111100, mne => "XPAL"  }, 
    {   match=> 0b00110100, mask => 0b11111100, mne => "XPAH"  }, 
    {   match=> 0b00111100, mask => 0b11111100, mne => "XPPC"  }, 
    {   match=> 0b00011001, mask => 0b11111111, mne => "SIO"  }, 
    {   match=> 0b00011100, mask => 0b11111111, mne => "SR"  }, 
    {   match=> 0b00011101, mask => 0b11111111, mne => "SRL"  }, 
    {   match=> 0b00011110, mask => 0b11111111, mne => "RR"  }, 
    {   match=> 0b00011111, mask => 0b11111111, mne => "RRL"  }, 
    {   match=> 0b00000000, mask => 0b11111111, mne => "HALT"  }, 
    {   match=> 0b00000001, mask => 0b11111111, mne => "XAE"  }, 
    {   match=> 0b00000010, mask => 0b11111111, mne => "CCL"  }, 
    {   match=> 0b00000011, mask => 0b11111111, mne => "SCL"  }, 
    {   match=> 0b00000100, mask => 0b11111111, mne => "DINT"  }, 
    {   match=> 0b00000101, mask => 0b11111111, mne => "IEN"  }, 
    {   match=> 0b00000110, mask => 0b11111111, mne => "CSA"  }, 
    {   match=> 0b00000111, mask => 0b11111111, mne => "CAS"  }, 
    {   match=> 0b00001000, mask => 0b11111111, mne => "NOP"  }, 
);

sub op($) {
    my ($i) = @_;

    my $ret = sprintf("%02X", $i);

    foreach my $od (@opcodes) {
        if (!(($i & $od->{mask}) ^ $od->{match})) {
            $ret = $od->{mne};
        }
    }

    return $ret;
}

sub wrap($$$) {
    my ($s, $l, $indent) = @_;
    my @words = split(/ /, $s);

    my $ret = "";
    my $ll = 0;
    foreach my $w (@words) {
        if ($ll + length($w) + ($ll?1:0) < $l) {
            if ($ll) {
                $ret .= " ";
                $ll ++;
            }
            $ret .= $w;
            $ll += length($w);
        } else {
            $ret .= "\n" . (" " x $indent) . $w;
            $ll = length($w);
        }
    }

    return $ret;
}

sub range(@) {
    my @org = @_;
    my $prev = -1;
    my $first = -1;
    my @ret = ();

    for (my $i = 0; $i <= $#org; $i++) {

        my $l = @org[$i];
        my $v = -1;
        if ((length($l) == 2) && ($l =~ /^[0-9a-f]+$/i)) {
            $v = hex($l);
        }

        if ($first > 0 && ($v < 0 || $v != $prev + 1)) {
            push @ret, sprintf("%02X-%02X", $first, $prev);

            if ($v >= 0) {
                $first =$v;
                $prev = $v;
            } else {
                push @ret, $l;
                $first = -1;
                $prev = -1;
            }
        } elsif ($v >= 0) {
            if ($first >= 0) {
                $prev = $v
            } else {
                $first = $v;
                $prev = $v;
            }
        } else {
            push @ret, $l;
            $first = $prev = -1;
        }
    }

    if ($first >=0)
    {
        push @ret, sprintf("%02X-%02X", $first, $prev);        
    }

    return @ret;
}

my $l = 1;
my $buf;
my $state = STATE_RES;
my $ctr   = 0;
my $pre_ads = 0;

my $cyc_r = 0;
my $cyc_i = 0;
my $cyc_d = 0;
my $cyc_h = 0;

my $i_cycles = ();

my %map = ();

my $I;



while (read($fh_in, $buf, 2) == 2) {    
    my ($D, $C) = unpack("CC", $buf);

    my $ads = !($C & M_ADS);
    #printf "%s %s %s", $pre_ads?"PAD":"   ", $ads?"ADS":"   ", $ads && ($D & D_M_I)?"INS":"   ";
    if ($ads) {
        $cyc_r = $D & D_M_R;
        $cyc_i = $D & D_M_I;
        $cyc_d = $D & D_M_D;
        $cyc_h = $D & D_M_H;
    }
    
    #printf("%d : %d : %02x %02x\n", $state, $l, $D, $C);

    if (!($C & M_RST)) {
        $state = STATE_RES;
    } elsif ($state == STATE_RES) {
        if ($C & M_RST) {
            $state = STATE_NOP;
            $ctr = 0;
        }
    } elsif ($state == STATE_NOP) {
        if ($ads && ($D & D_M_I)) {
            $ctr++;
            if ($ctr >= SKIP_INSTR) {
                $state = STATE_INS;
                @i_cycles = ("A");
            }
        }
    } elsif ($state == STATE_INS) {

        if ($pre_ads && $cyc_i) {
            $I = $D;
        }

        if ($ads && $cyc_i) {
            $state = STATE_DONE;
            my $seq = join("|", @i_cycles);            
            if (exists $map{$seq}) {
                push @{$map{$seq}}, $I;
            } else {
                $map{$seq} = [$I];
            }
        } elsif ($ads) {
            push @i_cycles, "A";
        } elsif ($pre_ads) {
            push @i_cycles, $cyc_h?"H":$cyc_i?"I":$cyc_r?"R":"W";        
        } else {
            push @i_cycles, " ";
        }
    }

    $pre_ads = $ads;
    $l++;
}

foreach my $k (sort({ length($a) - length($b) } keys(%map))) {
    printf "%-50s : [%2d] : %s\n", 
        "|" . $k . "|", 
        (length($k) + 1) / 2, 
        wrap(join(", ", range(sort(uniq(map { op($_) } @{$map{$k}})))), 40, 60);
}