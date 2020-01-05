#!/usr/bin/perl
use strict;
use warnings;
use XMLconv;
use Data::Dumper;

my $file  = $ARGV[0]; 


my $hh = Read_XML($file);

#print Dumper($hh);



Write_JSON('SS.json',$hh);


Write_DBI('XML_CON',$hh);

Write_CSV('SS.csv',$hh);

Write_EXCEL('SS.xlsx',$hh);

