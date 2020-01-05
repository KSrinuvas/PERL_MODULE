#!/usr/bin/perl
use strict;
use warnings;

use JSconv;
use Data::Dumper;

my $file = $ARGV[0];

my $ref = Read_JSON($file);

print Dumper($ref);

