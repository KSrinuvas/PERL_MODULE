#!/usr/bin/perl
## package name JSconv  
package JSconv;

use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(Read_JSON Write_EXCEL Write_CSV Write_DBI Write_XML);


use strict;
use warnings;
use Text::CSV qw( csv );
use JSON;
use DBI;
use Excel::Writer::XLSX;
use XML::Writer; 
use IO::File; 
use Data::Dumper;


##-------------------------------------------------------##
##                 Read JSON file                        ##
##-------------------------------------------------------##
	
sub Read_JSON {
				my $file = shift;
				my @arr;
				open(IN,"$file") || die "NOt able to open '$file' $!";
				while (my $line = <IN>)	{
							chomp($line);
							my $ref = decode_json($line);
							push(@arr,$ref);
				}
				return \@arr;				
}
			


##-------------------------------------------------------##
##               End JSON file                           ##
##-------------------------------------------------------##


##--------------------------------------------------------##
## 									Write a Excel file                    ##
##--------------------------------------------------------##
sub Write_EXCEL {
		my $file = shift;
		my $aoa = shift;
		my $workbook = Excel::Writer::XLSX->new("$file");
		my $worksheet = $workbook->add_worksheet('DATA');
		$worksheet->set_column(0,6,14);
		my $format = $workbook->add_format( color => 'red',size => 12, align => 'center');
		$format->set_bold();
		my $format1 = $workbook->add_format( color => 'blue',size => 12);
		my $row = 0;
		my $head = shift(@{$aoa});
		foreach my $data (@{$aoa}) {
				  my $col = 0;
					for (my $i = 0; $i < @{$data}; $i++) {
								if ($row == 0) {
            				 $worksheet->write($row,$col,$head->[$i],$format);
										 $col++;
										 next;
								}
           		  $worksheet->write($row+1,$col,$data->[$i],$format1);
								$col++;
					}
					$row++;
		}
		$workbook->close();
}


##--------------------------------------------------------##
##						End of the excel Write Data                 ##
##--------------------------------------------------------##




##--------------------------------------------------------##
###                 Write CSV format                      ##
##--------------------------------------------------------##

sub Write_CSV {
			my $file  = shift;
      my $arr_arr = shift;
			csv (in => $arr_arr, out => "file.csv", sep_char=> ";");
}

##--------------------------------------------------------##
##							End of the CSV Write Data                 ##
##--------------------------------------------------------##


##---------------------------------------------------------##
### 						Write mysql database                       ##
##---------------------------------------------------------##

sub Write_DBI {
  	my $table_name = shift;
  	my $ref =  shift;
		my $head = shift(@{$ref});
		my @aa = @{$ref};
    my $user = "root"; 
    my $password = "srm";  
    # connect to MySQL database 
    my $dbh = DBI->connect ("DBI:mysql:FTOS", 
                            $user,
                            $password)  
                            or die "Can't connect to database: $DBI::errstr\n"; 
    #print "connected to the database\n"; 
    my $size = 0;
		$size = @{$head};
   # print "$size\n";
    
    my $str1 = "?," x $size;
    chop($str1);
    
    # prepare the query
    my $sth = $dbh->prepare("INSERT INTO `$table_name`  
                              VALUES($str1)"); 
    foreach (@aa) { 
        $sth->execute(@{$_}); 
    }
    
    $sth->finish();
    #print "Successfully inserted values into the table\n"; 
    #print "\tQuery results:\n================================================\n"; 
 		# disconnect from the MySQL database
 	  $dbh->disconnect();
}

##--------------------------------------------------------##
##							End of the mysql Database Write           ##
##--------------------------------------------------------##


##--------------------------------------------------------##
##							Write XML file                            ##
##--------------------------------------------------------##


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
                for (my $i = 0; $i < @{$f1}; $i++)  {
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



##--------------------------------------------------------##
##			  				END XML file                            ##
##--------------------------------------------------------##

1;

