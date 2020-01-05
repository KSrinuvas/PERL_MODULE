#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;


#my $aa = {'a' => [10,20,30],'b' => {'cc' => 'ff','hh' => [100,200,300],'zz' => [2,5,6,{'ax' => {'bbb' => 240, 'oo' => [40,50,90,[22,33,44,{'aaa' => [2,4,8,6] } ] ] } } ] } };

my $abc;
#print Dumper($aa);

my $aa = $ARGV[0];

#my $aa = {'a' => 10, 'b' => [1,2,3,4], 'd' => [20,30,40]};


#my $aa = [1,2,{'sa' => 20} ];
#print Dumper($aa);


Recu($aa);

sub Recu {
		my $ref = shift; 
		
		if (ref($ref) eq 'ARRAY') {
					foreach my $kk (@{$ref}) {
								if (ref($kk) eq 'ARRAY') {
											Recu($kk);
								} elsif (ref($kk) eq 'HASH') {
											Recu($kk);
								} else {
											print "$kk\n";
								}
					}
					print "\n";
		} elsif (ref($ref) eq 'HASH') {
					while (my ($k,$v) = each(%{$ref})) {
								if (ref($v) eq 'HASH') {
										print "$k => \n";
										Recu($v);
								} elsif (ref($v) eq 'ARRAY') {
										print "$k => \n";
										Recu($v);
								} else {
										print "$k => $v\n";
								}
					}
					print "\n";
		}
}


							











BEGIN {
		$abc = [
          {
            'Empid' => 'SRM01',
            'Salary' => '25K',
            'Qualification' => 'B.tech',
            'Exp' => '2Years',
            'Age' => '20',
            'Name' => 'SUNIL'
          },
          {
            'Age' => '22',
            'Name' => 'CHANDU',
            'Empid' => 'SRM02',
            'Exp' => '4Years',
            'Qualification' => 'M.tech',
            'Salary' => '50k'
          },
          {
            'Name' => 'RAM',
            'Age' => '24',
            'Salary' => '40K',
            'Qualification' => 'M.sc',
            'Exp' => '3Years',
            'Empid' => 'SRM03'
          },
          {
            'Name' => 'RAVI',
            'Age' => '22',
            'Qualification' => 'M.ca',
            'Exp' => '2Years',
            'Salary' => '35k',
            'Empid' => 'SRM04'
          }
        ];

}
		
















	
