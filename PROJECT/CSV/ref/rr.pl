use strict;
use warnings;



sub write_csv {

  my ($array_ref, $fh) = @_;

  for my $row (@$array_ref) {
    print $fh join(',', map { $_, $row->{$_} } sort keys %$row), "\n";
  }
}

my $test = [
  {a => 1, ab => 2, type => '234k', count => '123'}, 
  {a => 3, ab => 2, type => 'some_type', count => 34},
];

open my $fh, '>', 'test.csv' or die $!;

write_csv($test, $fh);
