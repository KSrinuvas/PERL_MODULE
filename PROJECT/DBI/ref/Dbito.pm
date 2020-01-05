#!/usr/bin/perl

## package name 
package Dbito;

###########################################################################################################
###-----------------------------------------------------------------------------------------------------###
###          Description : Read the dbi format and build the referance                                  ###
###												 to parse referance to the input, write another formats                       ### 
###												 like CSV,JSON,EXCEL,XML                                                      ###
###-----------------------------------------------------------------------------------------------------###
###########################################################################################################

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use Text::CSV qw(csv);
use JSON;
use Excel::Writer::XLSX;
use DBI;
use XML::Writer;
use IO::File;

my ($csv_file,$excel_file,$json_file,$dbi,$xml_file,$help);
GetOptions ('Read_DBI=s@' => \$dbi,
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
		my $file = "$0 --Read_DBI FTOS --Read_DBI DATA";
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


#print Dumper($dbi);


###################################################################
##---------------------------------------------------------------##
##      		          Read database                              ## 
##---------------------------------------------------------------##
###################################################################

if (defined $dbi) {
		Read_DBI(@{$dbi});
} 



sub Read_DBI {
	 my $data = shift;
	 my $table = shift;
   my $dbh = DBI->connect(          
       "dbi:mysql:dbname=$data", 
       "root",                          
       "srm",                          
       { RaiseError => 1 },         
   ) or die $DBI::errstr;
   
   my $sth = $dbh->prepare( "SELECT * FROM $table");  
   $sth->execute();
   
   my @aoa;
   my @fields = @{$sth->{NAME} };
   #print "@fields\n";
   
   shift(@fields);       ############# to remove the numbers 
   my $size = @fields;
   
   use Data::Dumper;
         
   my $row;
   my @data;
   my $aref = \@fields;
   while($row = $sth->fetchrow_hashref()) {
   	#	print "$$row{$fields[0]} $$row{$fields[1]} $$row{$fields[2]} $$row{$fields[3]}\n";	
   		for (my $i = 0; $i < $size; $i++)	{
   				#print "$$row{$fields[$i]}\n";	
   		#		print "$row->{$fields[$i]}\n";	
   				push(@data,$row->{$fields[$i]});
   		}
   		sb(@data);
   		@data = ();
   }

   our $ab;
   sub sb {
   	  my @aa =	@_;
   		push(@{$ab},\@aa);
   }
#	 print Dumper($ab);
   unshift(@{$ab},\@fields);
	 $sth->finish();
   $dbh->disconnect();
	 if (defined $csv_file) {
				Write_CSV($csv_file,$ab);
	 }
	 if (defined $json_file) {
		   Write_JSON($json_file,$ab);
	 }
	 if (defined $excel_file) {
			 Write_EXCEL($excel_file,$ab);
   }
	 if (defined $xml_file) {
			 Write_XML($xml_file,$ab);
   }
		
			
}


##Perl: “Variable will not stay shared”
##---------------------------------------------------------------##
##                       END DATA BASE                           ##
##---------------------------------------------------------------##



####################################################################
##----------------------------------------------------------------##
##    	             WRITE A CSV FILE                             ##
##----------------------------------------------------------------##
####################################################################


sub Write_CSV {
		my $file = shift;
		my $aoa = shift;
		csv (in => $aoa, out => "$file", sep_char=> ",");
}


##--------------------------------------------------------------##
##                     END CSV FILE                             ##
##--------------------------------------------------------------##



##################################################################
##--------------------------------------------------------------##
##                    WRITE JSON FILE                           ##
##--------------------------------------------------------------##
##################################################################


sub Write_JSON {
		my $file = shift;
		my $ref = shift;
		open(my $fh,">$file") || die "NOt able to write a file $!";
		foreach my $aa (@{$ref}) {
				my $json = encode_json($aa);
				#print "$json\n";
				print $fh "$json\n";
		}
		close($fh);
}


##--------------------------------------------------------------##
##                     END JSON FILE                            ##
##--------------------------------------------------------------##






##################################################################
##--------------------------------------------------------------##
##                    WRITE EXCEL FILE                          ## 
##--------------------------------------------------------------##
##################################################################



sub Write_EXCEL {
			my $file = shift;
			my $ref = shift;
			my $row1 = 0;
			my $workbook  = Excel::Writer::XLSX->new( "$file" );
			my $worksheet = $workbook->add_worksheet();

			# Increase column width to improve visibility of data.
			$worksheet->set_column( 'A:Z', 20 );

			my $format = $workbook->add_format();
			$format->set_color('red');
			my $format1 = $workbook->add_format(color => 'blue');
			foreach (@{$ref}) {
					my $col1 = 0;
					my @data = @{$_};
    			for my $item ( @data ) {
							if ($row1 == 0) {
       				   # Just plain data
          				$worksheet->write($row1, $col1, $item,$format);
									#print "$item\n";
									$col1++;
									next;
							} 
          		$worksheet->write($row1, $col1, $item,$format1);
							$col1++;
    			}
					$row1++;
			}	
			$workbook->close();
}


   

##--------------------------------------------------------------##
##                     END EXCEL FILE                           ##
##--------------------------------------------------------------##
 





##################################################################
##--------------------------------------------------------------##
##                    WRITE XML FILE                            ## 
##--------------------------------------------------------------##
##################################################################




sub Write_XML {
			my $file = shift;
			my $ref = shift;
			#print Dumper($ref);
			my $f1 = shift(@{$ref});
			shift(@{$f1});    ## to remove so.no
			my $output = IO::File->new(">$file");
			my $wr = new XML::Writer(OUTPUT => $output, DATA_MODE => 'true', DATA_INDENT => 2 );
			$wr->startTag('opt');
			foreach my $rr (@{$ref}) {
						shift(@{$rr});
						if (@{$f1} == @{$rr}) {
								$wr->startTag('Emp');
								for (my $i = 0; $i < @{$f1}; $i++)	{
										#print "$$f1[$i] => $$rr[$i]\n";
										$wr->emptyTag('Details' , "$$f1[$i]" => "$$rr[$i]");
								}
								$wr->endTag();
								#print "\n";
						}
			 					
			}
			$wr->endTag();
			$wr->end();
			$output->close();
}




##################################################################
##--------------------------------------------------------------##
##                     END XML FILE                             ## 
##--------------------------------------------------------------##
##################################################################




1;

