use Test;

use PDF::Combiner;
use PDF::Combiner::Subs;

my $c = Config.new;
isa-ok $c, Config;

my $ifil = "t/data/config.txt";

lives-ok {
    $c = read-config-file $ifil;
}, "test Config class and the config reading";

is $c.paper, "Letter";
is $c.margins, 72;
is $c.simple, True;
is $c.zip, 150;

like $c.outfile, /'simple.pdf'/;


done-testing;
