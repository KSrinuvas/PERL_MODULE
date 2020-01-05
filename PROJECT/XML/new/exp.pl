#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use Data::Dumper;

##--------------------------------------------##
##          Read XML format                   ##
##--------------------------------------------##

my $file = $ARGV[0];


Read_XML($file);
sub Read_XML {
		# load
		open my $fh, '<', 'file.xml';
		print Dumper($doc);
		close($fh);
}
