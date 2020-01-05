#!/usr/bin/perl
use Csv;
use Getopt::Long;
use Data::Dumper;

#my $ref = Csv::Read_CSV("/home/srm/aa/CSV/Emp.csv");
my $ref = Read_CSV("/home/srm/aa/CSV/Emp.csv");

print Dumper($ref);



## write Execl file 

&Write_EXCEL('aa.xlsx',$ref);


## write JSON file 

&Write_JSON('aa.json',$ref);


## write_DBI table

&Write_DBI('NEW_TABLE',$ref);



## Write_XML file 

&Write_XML('aa.xml',$ref);



 
