#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Text::CSV qw(csv);
use JSON;
use Excel::Writer::XLSX;
use DBI;
use XML::Writer;
use IO::File;

###################################################################
##---------------------------------------------------------------##
##      		          Read database                              ## 
##---------------------------------------------------------------##
###################################################################



print "Enter the Database name : ";
my $data = <STDIN>;
chomp($data);
print "Enter the Database Table name : ";
my $table = <STDIN>;
chomp($table);


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
#		print "\n";
}



use Data::Dumper;


my @abc;
sub sb {
	  my @aa =	@_;
#		print "@aa\n";
		push(@abc,\@aa);
#		print "@abc\n";
}

#print "@abc\n";
unshift(@abc,\@fields);
#print Dumper(\@abc);




$sth->finish();
$dbh->disconnect();


##---------------------------------------------------------------##
##                       END DATA BASE                           ##
##---------------------------------------------------------------##

	
Write_csv(\@abc);

####################################################################
##----------------------------------------------------------------##
##    	             WRITE A CSV FILE                             ##
##----------------------------------------------------------------##
####################################################################





sub Write_csv {
		my $aoa = shift;
		csv (in => $aoa, out => "file1.csv", sep_char=> ",");
}



##--------------------------------------------------------------##
##                     END CSV FILE                             ##
##--------------------------------------------------------------##








##################################################################
##--------------------------------------------------------------##
##                    WRITE JSON FILE                           ##
##--------------------------------------------------------------##
##################################################################




Write_json(\@abc);

sub Write_json {
		my $ref = shift;
		open(my $fh,">exp.json") || die "NOt able to write a file $!";
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


Write_Excel(\@abc);





sub Write_Excel {
			my $ref = shift;
			my $row1 = 0;
			my $workbook  = Excel::Writer::XLSX->new( 'example.xlsx' );
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



Write_Xml(\@abc);

sub Write_Xml {
			my $ref = shift;
			print Dumper($ref);
			my $f1 = shift(@{$ref});
			shift(@{$f1});    ## to remove so.no
			my $output = IO::File->new(">output.xml");
			my $wr = new XML::Writer(OUTPUT => $output, DATA_MODE => 'true', DATA_INDENT => 2 );
			$wr->startTag('opt');
			foreach my $rr (@{$ref}) {
						shift(@{$rr});
						if (@{$f1} == @{$rr}) {
								$wr->startTag('Emp');
								for (my $i = 0; $i < @{$f1}; $i++)	{
										print "$$f1[$i] => $$rr[$i]\n";
										$wr->emptyTag('Details' , "$$f1[$i]" => "$$rr[$i]");
								}
								$wr->endTag();
								print "\n";
						}
			 					
			}
			$wr->endTag();

	
		#	$wr->end();
		#	$output->close();
}










