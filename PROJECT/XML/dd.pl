#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper;
my $file = $ARGV[0];
open(IN,"$file") || die "NOt able to open '$file' $!";

while (my $line = <IN>)	{
		my $oo = decode_json($line);
		print Dumper($oo);
}
close(IN);





