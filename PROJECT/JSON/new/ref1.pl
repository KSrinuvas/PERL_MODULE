#!/usr/bin/perl
use strict;
use warnings;

use JSON;
use XML::Writer;
use IO::File;
use Data::Dumper;
my $file = "/home/srm/aa/nn/XML_TEST/SS.json";



use XML::Simple;

open(my $fh,"$file") || die "Not able to open '$file' $!";
my $ref = decode_json(<$fh>);
print Dumper($ref);





 
my $fh1 = IO::File->new(">output.xml");

XMLout($ref, OutputFile => $fh1);



