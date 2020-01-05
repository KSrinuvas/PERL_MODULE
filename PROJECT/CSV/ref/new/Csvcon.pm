#!/usr/bin/perl
## package name Csvto
package Csv;

use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(Read_CSV Write_EXCEL Write_JSON Write_DBI Write_XML);


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

sub Read_CSV {
		my $file = shift;
		#my $aoa = csv (in => "/home/srm/aa/CSV/Emp.csv");    # as array of array
		# Read whole file in memory
		my $aoh = csv (in => "$file",
    	           headers => "auto");   # as array of hash
		my $aoa = csv (in => "$file");    # as array of array
	#	print Dumper($aoh);
		return $aoh;

}

##--------------------------------------------------------##
## 									End csv file                         ##
##--------------------------------------------------------##



##--------------------------------------------------------##
## 									Write a Excel file                    ##
##--------------------------------------------------------##
sub Write_EXCEL {
		my $file = shift;
		my $aoh = shift;
		my $workbook = Excel::Writer::XLSX->new("$file");
		my $worksheet = $workbook->add_worksheet('EMP_DATA');
		$worksheet->set_column(0,6,14);
		my $format = $workbook->add_format( color => 'red',size => 12, align => 'center');
		$format->set_bold();
		my $format1 = $workbook->add_format( color => 'blue',size => 12);
		my $row = 0;
		foreach my $v (@{$aoh}) {
				#print "$_\n";
         my $col = 0;
       	 foreach my $k1 (sort(keys %{$v})) {
#        		   print "$$v{$k1}\n";
         			 if ($row == 0)  {
            				 $worksheet->write($row,$col,$k1,$format);
             				 $worksheet->write(1,$col,$$v{$k1},$format1);
             				# $worksheet->write(1,0,$k);
             				 $col++;
                		 next;
          		 }
           		 $worksheet->write($row+1,$col,$$v{$k1},$format1);
          #		 $worksheet->write($row+1,0,$k);
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
###                 Write JSON format                     ##
##--------------------------------------------------------##

sub Write_JSON {
			my $file  = shift;
      my $arr_hash = shift;
      my $json = JSON->new();
      open(my $fh,"> $file") || die "NOt able to write file $!";
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

sub Write_DBI {
	my $table_name = shift;
	my $ref =  shift;
  my @links = @{$ref};
  # MySQL database configurations
  my $dsn = "DBI:mysql:FTOS";
  my $username = "root";
  my $password = 'srm';
  
  # connect to MySQL database
  my %attr = (PrintError=>0,RaiseError=>1 );
  my $dbh = DBI->connect($dsn,$username,$password,\%attr);
  
	my $stmt = $dbh->prepare( 
               "CREATE TABLE $table_name (Sno int(44) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                              Empid VARCHAR(255) NOT NULL,
                              Name VARCHAR(250) NOT NULL,
                              Age int(10) NOT NULL,
                              Salary VARCHAR(20) NOT NULL,
                              Qualification VARCHAR(20) NOT NULL,
                              Exp VARCHAR(20) NOT NULL
                           )" );
	
	## execute the query
  # now, the table is created
  $stmt->execute();
 	# insert data into the links table
  $stmt = $dbh->prepare("INSERT INTO $table_name (Empid,Name,Age,Salary,Qualification,Exp)
         VALUES(?,?,?,?,?,?)");
  
  # execute the query
  foreach my $link(@links){
    if($stmt->execute($link->{Empid}, $link->{Name}, $link->{Age}, $link->{Salary}, $link->{Qualification}, $link->{Exp} )){
 #    print "link $link->{Name} inserted successfully\n";
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

sub Write_XML {
		my $file = shift;
		my $ref = shift;
	#	print Dumper($ref);
	
	#my $output = new IO::File(">output1.xml"); 
	 my $output = new IO::File(">$file"); 
	
		my $writer = new XML::Writer( OUTPUT => $output,DATA_MODE => 'true', DATA_INDENT => 2 ); 
		$writer->startTag( 'opt' ); 
	  foreach my $rr (@{$ref}) {
				$writer->startTag( 'Emp' ); 
			#	print "$rr\n";
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

1;
