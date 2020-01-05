    #!/usr/bin/perl
            use warnings;
        use strict;
        use XML::XPath;

        #Name of the CSV File
        my $filename = "parse.csv";
				my $file = $ARGV[0];
        #Create the file.
        open(INPUT,">$filename") or die "Cannot create file";
				open(IN,$file);
        #Collect the XML and set nodes
        my($xp) = XML::XPath->new( join('', <IN>) );
        #my(@records) = $xp->findnodes( '/CATALOG/CD' );
				#my(@records) = $xp->findnodes( '/FOOD/ITEM' );
				my(@records) = $xp->findnodes('//[@Details]' );
					
        my($firstTime) = 0;

        #Loop through each record
        foreach my $record ( @records ) {
            my(@fields) = $xp->find( './child::*', $record )->get_nodelist();
            unless ( $firstTime++ ) {
            #Print Headers
                print( join( ',', map { $_->getName() } @fields ), "\n");
            }
            #Print Content
                print( join( ',', map { $_->string_value() } @fields ), "\n");
        }
        #Close the file.
        close(INPUT);

=c
__DATA__
        <FOOD>
            <ITEM id='1'>
                <Color>Brown</Color>
                <Name>Steak</Name>
            </ITEM>
            <ITEM id='2'>
                <Color>Blue</Color>
                <Name>Blueberries</Name>
            </ITEM>
            <ITEM id='3'>
                <Color>Red</Color>
                <Name>Apple</Name>
            </ITEM>
        </FOOD>
=cut

__DATA__
<opt>
  <Emp>
    <Details Age="20" />
    <Details Empid="SRM01" />
    <Details Exp="2Years" />
    <Details Name="SUNIL" />
    <Details Qualification="B.tech" />
    <Details Salary="25K" />
  </Emp>
  <Emp>
    <Details Age="22" />
    <Details Empid="SRM02" />
    <Details Exp="4Years" />
    <Details Name="CHANDU" />
    <Details Qualification="M.tech" />
    <Details Salary="50k" />
  </Emp>
  <Emp>
    <Details Age="24" />
    <Details Empid="SRM03" />
    <Details Exp="3Years" />
    <Details Name="RAM" />
    <Details Qualification="M.sc" />
    <Details Salary="40K" />
  </Emp>
  <Emp>
    <Details Age="22" />
    <Details Empid="SRM04" />
    <Details Exp="2Years" />
    <Details Name="RAVI" />
    <Details Qualification="M.ca" />
    <Details Salary="35k" />
  </Emp>
</opt>


