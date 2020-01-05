use XML::Smart;

## Create a null XML object:
my $XML = XML::Smart->new() ;

## Add a server to the list:
$XML->{server} = {
    os => 'Linux' ,
    type => 'mandrake' ,
    version => 8.9 ,
    address => [ '192.168.3.201', '192.168.3.202' ] ,
} ;

$XML->save('newfile.xml') ;
