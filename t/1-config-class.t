use Test;
use PDF::Combiner;
use PDF::Combiner::Subs;

my $c = Config.new;
isa-ok $c, Config;

my $ifil = "./example-project/our-israel-trip.txt";

lives-ok {
    $c = read-config-file $ifil;
}, "test Config class and the config reading";


my $t0 = "Our Trip to the Holy Land";
my $t1 = "";
my $t2 = "January 1980";

is $c.title.head, $t0, "title first line";
is $c.title[1], $t1, "title second line";
is $c.title.tail, $t2, "title last line";
is $c.paper, "Letter";
is $c.margins, 72;
like $c.outfile, /'trip-to-israel.pdf'/;
is $c.numbers, True;

done-testing;
