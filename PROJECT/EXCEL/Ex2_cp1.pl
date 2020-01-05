#!/usr/bin/perl
use strict;
use warnings;
use Spreadsheet::XLSX;
use JSON;
use Text::CSV;
use XML::Writer;
use DBI;
my (@header,@datarow);
my $kk; 
my $hash;

 
##############################################################################
##--------------------------------------------------------------------------##
##                Read Excel file build the referance                       ##
##--------------------------------------------------------------------------##
##############################################################################




#my $excel = Spreadsheet::XLSX -> new ('/home/srm/Downloads/aa.xlsx');
my $excel = Spreadsheet::XLSX -> new ('/home/srm/Music/aa/PROJECT/CSV/Emp1.xlsx');
 
foreach my $sheet (@{$excel -> {Worksheet}}) {
			
        #printf("Sheet: %s\n", $sheet->{Name});
			#	next if ($sheet->{Name} ne 'EMP_DATA');
    #  	printf("Sheet: %s\n", $sheet->{Name});
        foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
       				 my $this_set;
							 my $pri_key; 
               foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
             #  foreach my $col (0 .. $sheet -> {MaxCol}) {
                
                     # my $cell = $sheet -> {Cells} [$row] [$col];
                       my $cell = $sheet -> get_cell($row,$col);

											 if (defined $cell) {
                      	   # my $dd = $cell->value();
                      	     my $dd = $cell-> {Val};
                        	  #$datarow[$col] = $dd unless ($dd eq '');
                          	 if ($dd ne '') {
                                $datarow[$col] = $dd;
                         	  }
                   	 	 } else {
                    	     next;
                     	 }
                      ## header
                      if ($row == 0) {
                            $header[$col] = $datarow[$col];
														$kk = $datarow[0];
                      } else {
                            if ($col == 0) {
                                  $pri_key = $datarow[$col];
															  	#	print "$pri_key\n";
                            } else {
                                  my $key = $header[$col];
                                  my $val = $datarow[$col];
                                  $this_set->{$key} = $val;
                            }
                      }
                }
                if ($row > 0) {
                     # push @{$hash->{$pri_key}},$this_set;
											 $$hash{$kk}{$pri_key} = $this_set;
                }				
       }
 
}

use Data::Dumper;

print Dumper($hash);





####################################################################
#------------------------------------------------------------------#
##                Write a json format                             ##
#------------------------------------------------------------------#
####################################################################


Write_Json($hash);

sub Write_Json {
		my $ha = shift;
		open(my $fh,">data.json") || die "Not able to write 'data.json' $!";
		while (my ($k,$v) = each (%{$ha})) {
				#	my $json = encode_json({$k => $v});
					while (my ($k1,$v1) = each (%{$v})) {
							my $json = encode_json({$k => {$k1 => $v1}});
				#			print "$json\n";	
							print $fh "$json\n";
					}
		}
		close($fh);
}
		

####################################################################
#------------------------------------------------------------------#
##                 END of json format                             ##
#------------------------------------------------------------------#
####################################################################





=c


####################################################################
#------------------------------------------------------------------#
##                Write mysql Database format                     ##
#------------------------------------------------------------------#
####################################################################


Write_Dbi($hash);

sub Write_Dbi {
		my $aa = shift;
		## database configuration
		my $dsn = "DBI:mysql:FTOS";
		my $username = "root";
		my $password = "srm";
		my %attr = (
								PrintError => 0,
								RaiseError => 1);
		my $dbh = DBI->connect($dsn,$username,$password,\%attr);
		my @ddl = ("CREATE TABLE HAA (Sno int(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
							 Empid VARCHAR(20) NOT NULL,
							 Name VARCHAR(20) NOT NULL,
							 Age INT(10) NOT NULL,
							 Salary VARCHAR(20) NOT NULL,           
						   Qualification VARCHAR(20) NOT NULL,
							 Exp VARCHAR(20) NOT NULL)");					
		foreach (@ddl) {
					$dbh->do($_);
		}
		print "successfully\n";
	#	$dbh->disconect();
}





				 


############################################################################
#   #------------------------------------------------------------------#   #
#   |                Write CSV format                                  |   #
#   #------------------------------------------------------------------#   #
############################################################################


Write_CSV($hash);

sub Write_CSV {
		my $ref = shift;
		our $count = 0;
		my $aoa = [];
		my (@head,@value,%seen);
		while (my ($k,$v) = each (%{$ref}) ) {
			#	print "$k = > $v\n";
				
				while (my ($k1,$v1) = each (%{$v}) ) {
					#	print "$k1\n";
						foreach my $kk (sort (keys %{$v1})) {
						#			print "$k1 => $kk => $v1->{$kk}\n";
									push(@head,$kk);
									push(@value,$k1,$v1->{$kk});
						}
						@value = grep { !$seen{$_}++ } @value;
						print "@value\n";
					#	push(@{$aoa},\@value);
						@value = ();
						$count++;
				}
				unshift(@head,$k);
				@head = grep { !$seen{$_}++ } @head;
		}
		print "@head\n";
}
		



=cut




############################################################################
#   #------------------------------------------------------------------#   #
#   |                      Write XML format                            |   #
#   #------------------------------------------------------------------#   #
############################################################################


Write_XML('aa.xml',$hash);

sub Write_XML {
		my $file = shift;
		my $ref = shift;
		open(my $fh,">$file") || die "Not able to write '$file' $!"; 
		my $writer = XML::Writer->new( OUTPUT => $fh, DATA_MODE => "true", DATA_INDENT => 2);
		while (my ($k,$v) = each (%{$ref})) {
				print "$k => \n";
				$writer->startTag( 'opt' );
				while (my ($k1,$v1) = each (%{$v}) ) {
						print "     $k1\n";
						$writer->startTag("$k");
						foreach my $kk (sort (keys %{$v1})) {
									print "       $kk => $v1->{$kk}\n";
									$writer->emptyTag("$k1","$kk" => "$v1->{$kk}");
						}
						$writer->endTag();
				}
				$writer->endTag();
				$writer->end();
		}
		close($fh); ## close filehndler
}

	




