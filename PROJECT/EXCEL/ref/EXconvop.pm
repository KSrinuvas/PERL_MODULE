#!/usr/bin/perl

# package name EXconv
package EXconvop; 

sub new {
		my $class = shift;
		my $self = {};
		bless ($self,$class);
		return $self;
}

use strict;
use warnings;
use Spreadsheet::XLSX;
use JSON;
use Text::CSV qw( csv ) ;
use XML::Writer;
use DBI;
use Data::Dumper;

 
##--------------------------------------------------------------------------##
##                Read Excel file build the referance                       ##
##--------------------------------------------------------------------------##

#my $excel = Spreadsheet::XLSX -> new ('/home/srm/Downloads/aa.xlsx');
#my $excel = Spreadsheet::XLSX -> new ('/home/srm/Music/aa/PROJECT/CSV/Emp1.xlsx');

sub Read_EXCEL {
	 my $self = shift;
	 my $file = shift;
	 my $excel = Spreadsheet::XLSX -> new ("$file");
   my @data = ();
   foreach my $sheet (@{$excel -> {Worksheet}}) {
   				next if ($sheet->{Name} ne 'EMP_DATA');
         	printf("Sheet: %s\n", $sheet->{Name});
          foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
   							 my @datarow = ();
                 foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
                          my $cell = $sheet -> get_cell($row,$col);
   											 if (defined $cell) {
                         	     my $dd = $cell-> {Val};
                             	 if ($dd ne '') {
                                   $datarow[$col] = $dd;
                            	  }
                      	 	 } else {
                       	     next;
                        	 }
   							}
   						#	print "@datarow\n";
   							push(@data,\@datarow);
   				}
    }
		return \@data;
}


#------------------------------------------------------------------#
##                End of the excel file                           ##
#------------------------------------------------------------------#




#------------------------------------------------------------------#
##                Write a json format                             ##
#------------------------------------------------------------------#



sub Write_JSON {
		my $self = shift;
		my $file = shift;
		my $aoa = shift;
		open(my $fh,">$file") || die "Not able to write 'data.json' $!";
		foreach my $aa (@{$aoa}) {
					my $json = encode_json($aa);
					print $fh "$json\n";
		}
		close($fh);
}
		

#------------------------------------------------------------------#
##                 END of json format                             ##
#------------------------------------------------------------------#





=c


#------------------------------------------------------------------#
##                Write mysql Database format                     ##
#------------------------------------------------------------------#


Write_Dbi($hash);

sub Write_Dbi {
		my $self = shift;
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




=cut
				 


# #------------------------------------------------------------------# #
# |                      Write CSV format                            | #
# #------------------------------------------------------------------# #



sub Write_CSV {
		my $self = shift;
		my $file = shift;
		my $aoa = shift;
		# Write array of arrays as csv file
		csv (in => $aoa, out => "$file", sep_char=> ",");
					
}
		






############################################################################
#   #------------------------------------------------------------------#   #
#   |                      Write XML format                            |   #
#   #------------------------------------------------------------------#   #
############################################################################

sub Write_XML {
			my $self = shift;
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


	
############################################################################
#                          END XML FILE                                    #
############################################################################

1;
