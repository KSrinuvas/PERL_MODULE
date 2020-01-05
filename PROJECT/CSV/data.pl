#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use Data::Dumper;

my $aoh = [
          {
            'Exp' => '2Years',
            'Qualification' => 'B.tech',
            'Name' => 'SUNIL',
            'Empid' => 'SRM01',
            'Salary' => '25K',
            'Age' => '20'
          },
          {
            'Salary' => '50k',
            'Age' => '22',
            'Exp' => '4Years',
            'Qualification' => 'M.tech',
            'Name' => 'CHANDU',
            'Empid' => 'SRM02'
          },
          {
            'Qualification' => 'M.sc',
            'Empid' => 'SRM03',
            'Name' => 'RAM',
            'Exp' => '3Years',
            'Age' => '24',
            'Salary' => '40K'
          },
          {
            'Empid' => 'SRM04',
            'Qualification' => 'M.ca',
            'Name' => 'RAVI',
            'Exp' => '2Years',
            'Age' => '22',
            'Salary' => '35k'
          }
        ];




#print "Enter the data base table name to write : "; 
#my $table = <STDIN>;
#chomp($table);




Write_Database($aoh);


sub Write_Database {
   my $aoh = shift;
   ## data base configuration

   my $dsn = "DBI:mysql:vlsi15";
   my $username = "root";
   my $password = "srm";
   my %attr = (PrintError => 1,
               RaiseError => 0);


   ## conncet database vlsi15
   my $dbh = DBI->connect($dsn,$username,$password,\%attr);

# Empid,Name,Age,Salary,Qualification,Exp
	my @fields = qw(Empid Name Age Salary Qualification Exp);
	my @values = qw(Empid Name Age Salary Qualification Exp);




 my @ddl = (
             "CREATE TABLE AB1 (Sno int(44) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                            Empid VARCHAR(255) NOT NULL,
                            Name VARCHAR(250) NOT NULL,
                            Age int(10) NOT NULL,
                            Salary int(20) NOT NULL,
                            Qualification varchar(20) NOT NULL,
                            Exp varchar(20) NOT NULL
                         )" );



          my $sth = $dbh->prepare("INSERT INTO AB1
                       (@fields)
                        VALUES
                       (@values)");
          $sth->execute();

}
















=c
   foreach my $rr (@{$aoh}) {
      #print "$rr\n";
      if (ref($rr) eq 'HASH') {
          my @keys = keys %{$rr};
          #my @values = values %{$rr};
          my @values;
          foreach (@fields) {
              push(@values,$$rr{$_});
          }
          print "@fields\n";
          my $sth = $dbh->prepare("INSERT INTO EMP_DATA1
                       (@fields)
                        VALUES
                       (@values)");
          $sth->execute(@values)
                 or die $DBI::errstr;
          $sth->finish();
      }

    $dbh->disconnect();
   }
}


=cut
