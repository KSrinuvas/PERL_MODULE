#!/usr/bin/perl
use strict;
use warnings;
use lib '/home/srm/aa/PROJECT/EXCEL/ref';
use EXconv; 
use Getopt::Long;
use Data::Dumper;



my ($csv_file,$excel_file,$json_file,$dbi,$xml_file,$help);


GetOptions ('Read_EXCEL=s' => \$excel_file,
           'Write_DBI=s' => \$dbi,
           'Write_JSON=s' => \$json_file,
           'Write_CSV=s' => \$csv_file,
           'Write_XML=s' =>  \$xml_file,
           'help|h' => \$help) or die ("Error in command line arguments");


if (not $excel_file)  {
    &help();
}


sub help {
    print "$0 is the file name\n";
    my $file = "$0 -Read_EXCEL emp.xlsx";
    print "To Read the excel file data to any other format\n";
    print "
    Read_EXCEL <Enter excel file><mandatory>
    Ex : $file
    Write_EXCEL <Enter the dbi table><mandatory>
    Ex : $file -Write_DBI exmp
    Write_JSON <Enter the json file><mandatory>
    Ex : $file -Write_JSON exmp.json
    Write_CSV <Enter the csv file><mandatory>
    Ex : $file -Write_CSV exmp.csv
    Write_XML <Enter the xml file><mandatory>
    Ex : $file -Write_XML exmp.xml\n";
    exit;
}







##--------------------------------------------##
## 						Read excel file                 ##
##--------------------------------------------##
my $ref;
if (defined $excel_file) {
		$ref = &Read_EXCEL($excel_file);
		print Dumper($ref);
}

#print Dumper($ref);

##---------------- END database --------------##




##--------------------------------------------##
##        Write csv file                      ##
##--------------------------------------------##

if (defined $csv_file) {
		&Write_CSV($csv_file,$ref);
}

##============ END csv file ==================##




=c

##--------------------------------------------##
## 							Write Dbi                     ##
##--------------------------------------------##

if (defined $dbi) {
		&Write_DBI("$dbi",$ref);
}

##=============	End dbi ================##

=cut


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

