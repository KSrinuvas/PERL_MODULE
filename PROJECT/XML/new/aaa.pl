#!/usr/bin/perl
use Getopt::Long;

my %opt;
my $in  = \*ARGV;
GetOptions('i', \%opt);

if (defined($opt{i})) {
    open $in, '<', $opt{i}
      or die "Can't open file `$opt{i}' for reading: $!";
}
