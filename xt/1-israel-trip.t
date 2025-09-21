use Test;

use PDF::Combiner;
use PDF::Combiner::Classes;
use PDF::Combiner::Subs;

my $debug = 0;

my $e1= "example-projects/israel-trip/our-israel-trip.txt";
my $e2= "example-projects/israel-trip/our-israel-trip-empty-title.txt";
my $e3= "example-projects/israel-trip/our-israel-trip-no-title.txt";
my $e4= "example-projects/israel-trip/our-israel-trip-no-two-sided.txt";

my $e5= "example-projects/SPOL/spol.txt";

lives-ok {
    my @args = "config=$e1".words;
    run-cli @args;
}, "pdf 1";

my $n = 2;
for ($e2, $e3, $e4, $e5) -> $e {
    lives-ok {
        my @args = "config=$e".words;
        run-cli @args;
    }, "pdf $n";
    ++$n;
}

done-testing;
