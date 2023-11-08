use Test;
use PDF::Combiner;
use PDF::Combiner::Subs;

my $c = Config.new;
isa-ok $c, Config;

my $ifil = "./example-project/our-israel-trip.txt";

lives-ok {
    $c = read-config-file $ifil;
}, "test Config class and the config reading";

done-testing;
