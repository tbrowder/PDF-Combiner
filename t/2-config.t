use Test;

use PDF::Combiner;
use PDF::Combiner::Subs;
use PDF::Combiner::Classes;

my $c = Config.new;
isa-ok $c, Config, "creating Config object okay";

my $ifil = "t/data/config.txt";

lives-ok {
    $c = read-config-file $ifil;
}, "test Config class and the config reading";

is $c.paper, "Letter", "letter paper";
is $c.margins, 72, "72 PS margins";
is $c.zip, 150, "zip to 150 DPI";

say "\$c.ofile: '{$c.ofile}'";
like $c.ofile, /'config-default.pdf'/;


done-testing;
