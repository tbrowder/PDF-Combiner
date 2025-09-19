use Test;

my @modules = <
    PDF::Combiner
    PDF::Combiner::Subs
    PDF::Combiner::Classes
>;

plan @modules.elems;

for @modules {
    use-ok $_, say "Module '$_' is used okay";
}
