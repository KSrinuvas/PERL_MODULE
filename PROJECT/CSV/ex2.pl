#!/usr/bin/perl 
use strict;
use warnings;
use Text::CSV qw( csv );
use Excel::Writer::XLSX;
use JSON;
use DBI;
use Data::Dumper;



###-----------------------------------------###
###             Read csv file               ###
###-----------------------------------------###

# Functional interface

 
# Read whole file in memory
my $aoa = csv (in => "/home/srm/aa/CSV/Emp.csv");    # as array of array
my $aoh = csv (in => "/home/srm/aa/CSV/Emp.csv",
               headers => "auto");   # as array of hash
 
#print Dumper($aoh);
Write_Json($aoa);
#print Dumper($aoa);







###-----------------------------------------###
## 				Write excel file                  ###
###-----------------------------------------###






Write_Excel($aoa);

sub Write_Excel {
		my $aa = shift;
		my $head = shift(@{$aa});
		my $workbook = Excel::Writer::XLSX->new('Emp1.xlsx');
		my $worksheet = $workbook->add_worksheet('EMP_DATA');
		$worksheet->set_column(0,6,20);
		my $format = $workbook->add_format( color => 'red',size => 16, align => 'center');
		$format->set_bold();
		my $format1 = $workbook->add_format( color => 'blue',size => 14);
		my $row = 0;
		foreach my $data (@{$aa}) {
				#print "@{$data}\n";
				if (@{$data} == @{$head})	{
						print "@{$data}\n";
						my $col = 0;
						for(my $i = 0; $i < @{$head};$i++)	{
         				 if ($row == 0)  {
               			 $worksheet->write($row,$col,$$head[$i],$format);
               			 $worksheet->write(1,$col,$$data[$i],$format1);
               			 $col++;
               		   next;
                 } 
           		 		$worksheet->write($row+1,$col,$$data[$i],$format1);
									$col++;
					  }			
						$row++;
				}
		}
		$workbook->close();
}




##------------------------------------------##
##           Write JSON file 
##------------------------------------------##






## write json format 

sub Write_Json {
			my $arr_ref = shift;
			print Dumper($arr_ref);
			my $json = JSON->new();
			my $js_f = $json->encode($arr_ref);
			open(my $fh,">Emp.json") || die "NOt able to write file $!";
			foreach my $aa (@{$arr_ref}) {
					my $js_f = $json->encode($aa);
					print $fh "$js_f\n";
			}
			close($fh);
}
			
				






##--------------------------------------------##
##           Write dbi format                 ##
##--------------------------------------------##

=c


sub Write_Data {
		my $data = shift;
		
		## database configuration
		my $dsn = "DBI:mysql:FTOS";
		my $username = 	"root";
		my $password = "srm";
		my %attr = (PrinError => 0,
								RiseError => 1
								);
		
		## conncet database 
		my $dbh = DBI->connect($dsn,$username,$password,\%attr);

		## create table 
		
		my @ddl = ("CREATE TABEL DD4 (
		
}	

=cut






##---------------------------------------------------##
##            Write a XML format                     ##
##---------------------------------------------------##








