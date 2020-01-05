#!/usr/bin/perl
use lib "/home/srm/aa/PROJECT/XML/new/GG";
use XMLconv;
use strict; 
use warnings;
use Data::Dumper;



use Getopt::Long;

my ($csv_file,$excel_file,$json_file,$dbi_table,$xml_file,$help);
GetOptions ('Read_XML=s' => \$xml_file,
           'Write_EXCEL=s' => \$excel_file,
           'Write_JSON=s' => \$json_file,
           'Write_DBI=s' => \$dbi_table,
           'Write_CSV=s' =>  \$csv_file,
           'help|h' => \$help) or die ("Error in command line arguments");


if (not $xml_file)  {
    &help();
}

sub help {
    print "$0 is the file name\n";
    my $file = "$0 -Read_XML exmp.xml";
    print "To Read the xml file and write any other formats in below\n";
    print "
    Read_XML <Enter the xml file><mandatory>
    Ex : $file
    Write_EXCEL <Enter the excel file><mandatory>
    Ex : $file -Write_EXCEL exmp.xlsx
    Write_JSON <Enter the json file><mandatory>
    Ex : $file -Write_JSON exmp.json
    Write_DBI <Enter the dbi table><mandatory>
    Ex : $file -Write_DBI exmp
    Write_CSV <Enter the csv file><mandatory>
    Ex : $file -Write_CSV exmp.csv\n";
    exit;
}




##-------------------------------------------##
##          Read xml file                    ##
##-------------------------------------------##


my $ref = Read_XML("$xml_file");

print Dumper($ref);


##--------------------------------------------##
##              Write Excel file              ##
##--------------------------------------------##

if (defined $excel_file) {
    &Write_EXCEL("$excel_file",$ref);
    print "Write_excel file successfully\n";
}

##============= End Excel file================##



##--------------------------------------------##
##            Write JSON file                 ##
##--------------------------------------------##

if (defined $json_file) {
    &Write_JSON("$json_file",$ref);
    print "Write_json file successfully\n";
}

##============= End JSON file ================##



##--------------------------------------------##
##            Write mysql dbi table           ##
##--------------------------------------------##

if (defined $dbi_table) {
    &Write_DBI("$dbi_table",$ref);
    print "Insert the table values successfully\n";
}

##============ END dbi table ================##



##--------------------------------------------##
##            Write csv file                  ##
##--------------------------------------------##

if (defined $csv_file) {
    &Write_CSV("$csv_file",$ref);
    print "Write_csv file successfully\n";
}

##============== END csv file ================##





































=c

my $file  = $ARGV[0]; 


my $hh = Read_XML($file);

#print Dumper($hh);



Write_JSON('SS.json',$hh);


Write_DBI('XML_CON',$hh);

Write_CSV('SS.csv',$hh);

Write_EXCEL('SS.xlsx',$hh);

=cut

