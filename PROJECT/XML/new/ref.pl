#!/usr/bin/perl
use strict;
use warnings;
use Excel::Writer::XLSX;


my $wb = Excel::Writer::XLSX->new('AA.xlsx');

my $ws = $wb->add_worksheet('DATA');








$ws->add_table(
    'B3:G8',
    {
        total_row => 1,
        columns   => [
            { header => 'Product',   total_string   => 'Totals' },
            { header => 'Quarter 1', total_function => 'sum' },
            { header => 'Quarter 2', total_function => 'sum' },
            { header => 'Quarter 3', total_function => 'sum' },
            { header => 'Quarter 4', total_function => 'sum' },
            {
                header         => 'Year',
                formula        => '=SUM(Table10[@[Quarter 1]:[Quarter 4]])',
                total_function => 'sum'
            },
        ]
    }
);
