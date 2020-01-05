#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;


my (%defines,$libfiles);
GetOptions ("define=s" => \%defines,
							"library=s@" => \$libfiles);

use Data::Dumper;

print Dumper(\%defines);

print Dumper($libfiles);

