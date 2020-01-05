#!/usr/bin/perl
use strict;
use warnings;
use lib '/home/srm/aa/PROJECT/DBI/ref/new';
use DBconv;
use Getopt::Long;
use Data::Dumper;

my ($csv_file,$excel_file,$json_file,$dbi,$xml_file,$help);
GetOptions ('Read_DBI=s' => \$dbi,
           'Write_EXCEL=s' => \$excel_file,
           'Write_JSON=s' => \$json_file,
           'Write_CSV=s' => \$csv_file,
           'Write_XML=s' =>  \$xml_file,
           'help|h' => \$help) or die ("Error in command line arguments");


if (not $dbi)  {
    &help();
}


sub help {
    print "$0 is the file name\n";
    my $file = "$0 -Read_DBI DATA";
    print "To Read the mysql dbi data to any other format\n";
    print "
    Read_DBI <Enter Database name><mandatory> Read_DBI >Enter table name>
    Ex : $file
    Write_EXCEL <Enter the excel file><mandatory>
    Ex : $file -Write_EXCEL exmp.xlsx
    Write_JSON <Enter the json file><mandatory>
    Ex : $file -Write_JSON exmp.json
    Write_CSV <Enter the csv file><mandatory>
    Ex : $file -Write_CSV exmp.csv
    Write_XML <Enter the xml file><mandatory>
    Ex : $file -Write_XML exmp.xml\n";
    exit;
}






##--------------------------------------------##
## 						Read mysql dbi table            ##
##--------------------------------------------##
my $ref;
if (defined $dbi) {
		$ref = &Read_DBI($dbi);
	#	print Dumper($ref);
}

print Dumper($ref);

##---------------- END database --------------##




##--------------------------------------------##
##        Write csv file                      ##
##--------------------------------------------##

if (defined $csv_file) {
		&Write_CSV($csv_file,$ref);
}

##============ END csv file ==================##



##--------------------------------------------##
## 							Write Excel file              ##
##--------------------------------------------##

if (defined $excel_file) {
		&Write_EXCEL("$excel_file",$ref);
}

##=============	End Excel file================##



##--------------------------------------------##
##            Write JSON file                 ##
##--------------------------------------------##

if (defined $json_file) {
		&Write_JSON("$json_file",$ref);
}

##============= End JSON file ================##



##--------------------------------------------##
## 						Write xml file                  ##
##--------------------------------------------##

if (defined $xml_file) {
		&Write_XML("$xml_file",$ref);
}

##============== END xml file ================##

