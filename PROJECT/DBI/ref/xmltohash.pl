#!/usr/bin/perl
use strict;
use warnings;



use XML::Simple;


open(my $fh,'/home/srm/aa/XML/playlist.xml');

my $ref = XMLin($fh);

#print $ref->{server1}{servername}, "\n";
#print $ref->{server2}{servername}, "\n";


use Data::Dumper;

print Dumper($ref);




close($fh);

