#!/usr/bin/perl
use strict;
use warnings;
use Spreadsheet::XLSX;
use JSON;
use Text::CSV;
use DBI;
my (@header,@datarow);
my $kk; 
my $hash;

 
my $excel = Spreadsheet::XLSX -> new ('/home/srm/Downloads/aa.xlsx');
#my $excel = Spreadsheet::XLSX -> new ('/home/srm/Music/aa/PROJECT/CSV/Emp1.xlsx');
 
foreach my $sheet (@{$excel -> {Worksheet}}) {
			
        #printf("Sheet: %s\n", $sheet->{Name});
				next if ($sheet->{Name} ne 'INSTALLED');
      	#printf("Sheet: %s\n", $sheet->{Name});
        foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
       				 my $this_set;
							 my $pri_key; 
             #  foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
                foreach my $col (1 ..  $sheet -> {MaxCol}) {
                
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
														$kk = $datarow[4];
                      } else {
                            if ($col == 4) {
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

#print Dumper($hash);





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
						#	print "$json\n";	
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
		my %attr = (RiseError => 0,
								PrintError => 1);
#		my @ddl = (CREATE TABLE HAA "(Sno int(20) NOT NULL AUTO_INCREMENT PRIMARY KEY)");							 
}							








				 
####################################################################
#------------------------------------------------------------------#
##                Write Xml format                                ##
#------------------------------------------------------------------#
####################################################################





Write_XML($hash);



sub Write_XML {
		my $rr = shift;
		#print Dumper($ref);
		abc($rr);
		sub abc {
				my $ref = shift;
				while (my ($k,$v) = each (%{$ref}) ) {
					#	print "$k => $v\n";
						if (ref($v) eq 'HASH') {
								while (my ($k1,$v1) = each (%{$v})) {
										print "$k1 => $v1\n";
										abc($v1);
								}
								print"\n\n";
						}
				}
		}
}

		



