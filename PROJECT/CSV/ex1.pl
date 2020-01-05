#!/usr/bin/perl 
use strict;
use warnings;
use Text::CSV qw( csv );
use JSON;
use DBI;
use Excel::Writer::XLSX;
use XML::Writer; 
use IO::File; 
use Data::Dumper;


##--------------------------------------------------------##
## 									read csv file                         ##
##--------------------------------------------------------##

# Functional interface

 
# Read whole file in memory
my $aoa = csv (in => "/home/srm/aa/CSV/Emp.csv");    # as array of array
my $aoh = csv (in => "/home/srm/aa/CSV/Emp.csv",
               headers => "auto");   # as array of hash
 
print Dumper($aoh);

#print Dumper($aoa);



## write excel file 





Write_Excel($aoh);

sub Write_Excel {
		my $aoh = shift;
		my $workbook = Excel::Writer::XLSX->new('Emp.xlsx');
		my $worksheet = $workbook->add_worksheet('EMP_DATA');
		sub ADD {
				my $ll	= shift;
				my $pp = $ll * 5;
				print"$ll\n";
				$worksheet->set_column(0,6,$pp);
				#$worksheet->set_column(0,6,20);
		}
    autofit_columns($worksheet);
		my $format = $workbook->add_format( color => 'red',size => 16, align => 'center');
		$format->set_bold();
		my $format1 = $workbook->add_format( color => 'blue',size => 14);
		my $row = 0;
		foreach my $v (@{$aoh}) {
				#print "$_\n";
   			 if (ref($v) eq 'HASH') {
      			my $col = 0;
       			foreach my $k1 (sort(keys %{$v})) {
#        				   print "$$v{$k1}\n";
									 ADD(length($k1));
									 ADD(length($$v{$k1}));
         					 if ($row == 0)  {
               				 $worksheet->write($row,$col,$k1,$format);
               				 $worksheet->write(1,$col,$$v{$k1},$format1);
               				# $worksheet->write(1,0,$k);
               				 $col++;
               		 next;
           				 }
           		 $worksheet->write($row+1,$col,$$v{$k1},$format1);
          # 		 $worksheet->write($row+1,0,$k);
           		 $col++;
						}
        }
        $row++;
    }
		sub autofit_columns {
 
		    my $worksheet = shift;
   			my $col       = 0;
 
   		 for my $width (@{$worksheet->{__col_widths}}) {
 
        $worksheet->set_column($col, $col, $width) if $width;
        $col++;
   			}
		}
		$workbook->close();
}



##--------------------------------------------------------##
##						End of the excel Write Data                 ##
##--------------------------------------------------------##




=c

##--------------------------------------------------------##
###                 Write JSON format                     ##
##--------------------------------------------------------##



Write_Json($aoh);

## write json format  

sub Write_Json {
      my $arr_hash = shift;
      my $json = JSON->new();
      open(my $fh,">Emp_hash.json") || die "NOt able to write file $!";
      foreach my $aa (@{$arr_hash}) {
          my $js_f = $json->encode($aa);
          print $fh "$js_f\n";
      }
      close($fh);
}




##--------------------------------------------------------##
##							End of the JSON Write Data               ##
##--------------------------------------------------------##







##---------------------------------------------------------##
### 						Write mysql database                       ##
##---------------------------------------------------------##



Write_DBI($aoh);

sub Write_DBI {
  # MySQL database configurations
  my $dsn = "DBI:mysql:FTOS";
  my $username = "root";
  my $password = 'srm';
  
  #say "Perl MySQL INSERT Demo";
  
  # get user's input links
	my $ref =  shift;
  my @links = @{$ref};
  
  # connect to MySQL database
  my %attr = (PrintError=>0,RaiseError=>1 );
  my $dbh = DBI->connect($dsn,$username,$password,\%attr);
  
  
  my @ddl = (
               "CREATE TABLE EMP_DATA22 (Sno int(44) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                              Empid VARCHAR(255) NOT NULL,
                              Name VARCHAR(250) NOT NULL,
                              Age int(10) NOT NULL,
                              Salary VARCHAR(20) NOT NULL,
                              Qualification VARCHAR(20) NOT NULL,
                              Exp VARCHAR(20) NOT NULL
                           )" );
  
  
  foreach my $aa (@ddl) {
         $dbh->do($aa);
  }
  
  
 	# insert data into the links table
 	my $sql = "INSERT INTO EMP_DATA22 (Empid,Name,Age,Salary,Qualification,Exp)
         VALUES(?,?,?,?,?,?)";
 
	my $stmt = $dbh->prepare($sql); 
  # execute the query
  foreach my $link(@links){
    if($stmt->execute($link->{Empid}, $link->{Name}, $link->{Age}, $link->{Salary}, $link->{Qualification}, $link->{Exp} )){
      print "link $link->{Name} inserted successfully\n";
    }
  
  }
  $stmt->finish();
  
  # disconnect from the MySQL database
  $dbh->disconnect();
}


##--------------------------------------------------------##
##							End of the mysql Database Write           ##
##--------------------------------------------------------##




##--------------------------------------------------------##
##							Write XML file                            ##
##--------------------------------------------------------##

Write_XML($aoh);


sub Write_XML {
		my $ref = shift;
	#	print Dumper($ref);
	
		my $output = new IO::File(">output.xml"); 
	
		my $writer = new XML::Writer( OUTPUT => $output,DATA_MODE => 'true', DATA_INDENT => 2 ); 
		$writer->startTag( 'opt' ); 
	  foreach my $rr (@{$ref}) {
				$writer->startTag( 'Emp' ); 
				print "$rr\n";
				foreach my $kk (sort (keys %{$rr})) {	
							$writer->emptyTag('Details' ,"$kk" => "$rr->{$kk}");
		  	} 
				$writer->endTag( ); 
		}
		$writer->endTag( ); 
		$output->close();
}






##--------------------------------------------------------##
##			  				END XML file                            ##
##--------------------------------------------------------##





=cut

