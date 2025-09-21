use Test;

use PDF::Combiner;
use PDF::Combiner::Classes;
use PDF::Combiner::Subs;

my $debug = 0;

my $egcA1= "example-projects/israel-trip/our-israel-trip.txt";
my $egcA2= "example-projects/israel-trip/our-israel-trip-empty-title.txt";
my $egcA3= "example-projects/israel-trip/our-israel-trip-no-title.txt";
my $egcA4= "example-projects/israel-trip/our-israel-trip-no-two-sided.txt";

my $egcB1= "example-projects/example-projects/SPOL/spol.txt";

lives-ok {
    my @args = "config=$egcA1".words;
    run-cli @args;
}

done-testing;
