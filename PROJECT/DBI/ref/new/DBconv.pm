#!/usr/bin/perl
###########################################################################################################
###-----------------------------------------------------------------------------------------------------###
###          Description : Read the dbi format and build the referance                                  ###
###												 to parse referance to the input, write another formats                       ### 
###												 like CSV,JSON,EXCEL,XML                                                      ###
###-----------------------------------------------------------------------------------------------------###
###########################################################################################################

## package name 
package DBconv;
use strict;
use warnings;
use DBI;
use Text::CSV qw(csv);
use JSON;
use Excel::Writer::XLSX;
use XML::Writer;
use IO::File;
use Data::Dumper;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(Read_DBI Write_CSV Write_JSON Write_EXCEL Write_XML);

###################################################################
##---------------------------------------------------------------##
##      		          Read database                              ## 
##---------------------------------------------------------------##
###################################################################

sub Read_DBI {
	 my $table = shift;
   my $dbh = DBI->connect(          
       "dbi:mysql:dbname=FTOS", 
       "root",                          
       "srm",                          
       { RaiseError => 1 },         
   ) or die $DBI::errstr;
   my $sth = $dbh->prepare( "SELECT * FROM $table");  
   $sth->execute();
	 my $ab;
   my @fields = @{$sth->{NAME} };

   shift(@fields);       ############# to remove the S.no Col 
   my $size = @fields;
   my $row;
   while($row = $sth->fetchrow_hashref()) {
			my @data = ();
   	#	print "$$row{$fields[0]} $$row{$fields[1]} $$row{$fields[2]} $$row{$fields[3]}\n";	
   		for (my $i = 0; $i < $size; $i++)	{
   				#print "$$row{$fields[$i]}\n";	
   		#		print "$row->{$fields[$i]}\n";	
   				push(@data,$row->{$fields[$i]});
   		}
   		push(@{$ab},\@data);
   }
   unshift(@{$ab},\@fields);
	 $sth->finish();
   $dbh->disconnect();
	 #print Dumper($ab);
		return $ab;
}


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
			$worksheet->set_column( 'A:Z', 10 );

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
			my $output = IO::File->new(">$file");
			my $wr = new XML::Writer(OUTPUT => $output, DATA_MODE => 'true', DATA_INDENT => 2 );
			$wr->startTag('opt');
			foreach my $rr (@{$ref}) {
						if (@{$f1} == @{$rr}) {
								$wr->startTag('data');
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


##--------------------------------------------------------------##
##                     END XML FILE                             ## 
##--------------------------------------------------------------##

1;



