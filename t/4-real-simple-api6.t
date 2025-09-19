use Test;

use PDF::Combiner;
use PDF::Combiner::Subs;

use File::Find;

my $debug = 1;

is 1, 1;

my $dir = "t/data";
my @pdfs = find :$dir, :type<file>, :name(/watusi/);
@pdfs .= sort;

for @pdfs -> $pdf {
    say "See pdf file '$pdf'";
}

if $debug {
    my $ofile = "watusi-news.pdf";
    lives-ok {
        simple-combine-pdf-api6 @pdfs, :$ofile;
    }
}

done-testing;
