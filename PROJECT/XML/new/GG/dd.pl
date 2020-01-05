#!/usr/bin/perl
use strict;
use warnings;

use JSON;
use Data::Dumper;
my $file = $ARGV[0];
open(IN,"$file") || die "Not able to open '$file' $!";

my $hash = decode_json(<IN>);

print Dumper($hash);



