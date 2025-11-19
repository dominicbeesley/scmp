#!/usr/bin/env perl

use strict;

while (<>) {

	my $l = $_;
	$l =~ s/[\r\n]//;

	if ($l =~ /(.*?)(-?)([0-9A-F]+)(\(P0\)\s+)(.*PC=([0-9A-F]+).*)/) {
		my ($minus, $pc, $offs) = ($2, hex($6), int($3));
		if ($minus) {
			printf "%s%04xr    %s\n", $1, $pc - $offs, $5;
		} else {
			printf "%s%04xr    %s\n", $1, $pc + $offs, $5;
		}
	} else {
		print "$l\n";
	}
}