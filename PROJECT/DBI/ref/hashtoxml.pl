#!/usr/bin/perl
use strict;
use warnings;







use XML::Hash::XS qw();


my %hash = (name => 'ss',age=> 20,salary=>15);


 
my $conv   = XML::Hash::XS->new(utf8 => 0, encoding => 'utf-8')
my $xmlstr = $conv->hash2xml(\%hash, utf8 => 1);
my $hash   = $conv->xml2hash($xmlstr, encoding => 'cp1251'); #my $hash = xml2hash *STDIN;

print "$hash\n";
