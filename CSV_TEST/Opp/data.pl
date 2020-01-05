#!/usr/bin/perl

use lib "/home/srm/aa/PROJECT/CSV/ref/new";
use CSVconvop;
use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

my ($csv_file,$excel_file,$json_file,$dbi_table,$xml_file,$help);
GetOptions ('Read_CSV=s' => \$csv_file,
           'Write_EXCEL=s' => \$excel_file,
           'Write_JSON=s' => \$json_file,
           'Write_DBI=s' => \$dbi_table,
           'Write_XML=s' =>  \$xml_file,
           'help|h' => \$help) or die ("Error in command line arguments");


if (not $csv_file)  {
    &help();
}

sub help {
    print "$0 is the file name\n";
    my $file = "$0 -Read_CSV exmp.csv";
    print "To Read the csv file and write any other formats in below\n";
    print " 
    Read_CSV <Enter the csv file><mandatory>
    Ex : $file
    Write_EXCEL <Enter the excel file><mandatory>
    Ex : $file -Write_EXCEL exmp.xlsx
    Write_JSON <Enter the json file><mandatory>
    Ex : $file -Write_JSON exmp.json
    Write_DBI <Enter the dbi file><mandatory>
    Ex : $file -Write_DBI exmp
    Write_XML <Enter the xml file><mandatory>
    Ex : $file -Write_XML exmp.xml\n";
    exit;
}


my $obj = CSVconvop->new();
my $ref = $obj->Read_CSV("$csv_file");

print Dumper($ref);


##--------------------------------------------##
## 							Write Excel file              ##
##--------------------------------------------##

if (defined $excel_file) {
		$obj->Write_EXCEL("$excel_file",$ref);
}

##=============	End Excel file================##



##--------------------------------------------##
##            Write JSON file                 ##
##--------------------------------------------##

if (defined $json_file) {
		$obj->Write_JSON("$json_file",$ref);
}

##============= End JSON file ================##



##--------------------------------------------##
## 						Write mysql dbi table           ##
##--------------------------------------------##

if (defined $dbi_table) {
		$obj->Write_DBI("$dbi_table",$ref);
}

##============ END dbi table ================##



##--------------------------------------------##
## 						Write xml file                  ##
##--------------------------------------------##

if (defined $xml_file) {
		$obj->Write_XML("$xml_file",$ref);
}

##============== END xml file ================##

