#!/usr/bin/perl
use strict;
use warnings;

#Example #1:

#This is a simple implementation which uses defaults

use XML::Excel; 

my $file = $ARGV[0];

my $excel_obj = XML::Excel->new(); 

$excel_obj->parse_doc("$file", {headings => 1});

$excel_obj->print_xml("out.xml");
