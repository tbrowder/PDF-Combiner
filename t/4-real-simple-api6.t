use Test;

use PDF::Combiner;
use PDF::Combiner::Subs;

use File::Find;

is 1, 1;

my $dir = "t/data";
my @pdfs = find :$dir, :type<file>, :name(/watusi/);
@pdfs .= sort;

for @pdfs -> $pdf {
    say "See pdf file '$pdf'";
}

=begin comment
my $ofile = "watusi-news.pdf";
lives-ok {
    simple-combine-pdf-api6 @pdfs, :$ofile;
}
=end comment

done-testing;
