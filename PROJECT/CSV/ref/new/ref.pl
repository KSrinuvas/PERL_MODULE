#!/usr/bin/perl
## package name Csvto



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
		#my $file = shift;
		my $aoa = csv (in => "/home/srm/aa/CSV/Emp.csv");    # as array of array
		# Read whole file in memory
		#my $aoh = csv (in => "$file",
    #	           headers => "auto");   # as array of hash
		#my $aoa = csv (in => "$file");    # as array of array
		#print Dumper($aoa);
		Write_DBI($aoa);
	#	return $aoa;

}

Read_CSV();
##--------------------------------------------------------##
## 									End csv file                         ##
##--------------------------------------------------------##




##---------------------------------------------------------##
### 						Write mysql database                       ##
##---------------------------------------------------------##

sub Write_DBI {
#	my $table_name = shift;
	my $ref =  shift;
	my $head = shift(@{$ref});
  # MySQL database configurations
  my $dsn = "DBI:mysql:FTOS";
  my $username = "root";
  my $password = 'srm';
  
  # connect to MySQL database
  my %attr = (PrintError=>0,RaiseError=>1 );
  my $dbh = DBI->connect($dsn,$username,$password,\%attr);
 	#print Dumper($head);
	#print Dumper($ref);	
	 my $size = 0;
	 $size  = @{$head};
	 print "$size\n";
   my $str = "?," x $size;
	 chop($str);
	 print "$str\n";
	 my $sth = $dbh->prepare("INSERT INTO ABCD 
                        VALUES($str)");

	 foreach (@{$ref}) {
				print "@{$_}\n";
				$sth->execute(@{$_});
		}
		$sth->finish();
		$dbh->disconnect();
}



=c 
	my $stmt = $dbh->prepare( 
               "CREATE TABLE ABCD (Sno int(44) NOT NULL AUTO_INCREMENT PRIMARY KEY,
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
=cut
	






=c
		my $size = 0;
		foreach (@aa) {
    		$size = @{$_};
		}
		print "$size\n";

		my $str1 = "?," x $size;
		chop($str1);

		# prepare the query
		my $sth = $dbh->prepare("INSERT INTO emp
                          VALUES($str1)");


		foreach (@aa) {
    		$sth->execute(@{$_});
		}

=cut






















##--------------------------------------------------------##
##							End of the mysql Database Write           ##
##--------------------------------------------------------##


