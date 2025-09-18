use Test;

use PDF::Combiner;
use PDF::Combiner::Subs;

use File::Find;

my $dir = "t/data";
my @pdfs = find :$dir, :type<file>, :name(/watusi/);
@pdfs .= sort;

my $ofile = "watusi-news.pdf";
lives-ok {
    simple-combine @pdfs, :$ofile;
}
 
done-testing;
