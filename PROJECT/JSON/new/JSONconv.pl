#!/usr/bin/perl
use strict;
use warnings;

use JSONconv;

my $ref = Read_JSON("/home/srm/aa/nn/XML_TEST/SS.json");

Write_CSV('SD.csv',$ref);

Write_XML('SD.xml',$ref);

Write_EXCEL('SD.xlsx',$ref);

Write_DBI('XML_CON',$ref);




