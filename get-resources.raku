#!/usr/bin/env raku

use File::Find;

use PDF::Content;
use PDF::Lite;
use PDF::Content::Page;

my $dir = "t/data";
say "Searching dir: $dir";

my @pdfs = find :$dir, :type<file>, :name(/watusi/);
@pdfs .= sort;

# say $_ for @pdfs;

for @pdfs -> $pdf {

    my PDF::Lite $pdfo .= open: $pdf;
    my PDF::Lite::Page $page = $pdfo.page(1);

    my %h = $page.Resources;
    for %h.keys -> $k {
        say "key: '$k'";
        my $v = %h{$k};
        if $v ~~ Hash {
            say "    value is another Hash";
        }
        else {
            say "    value: '$v'";
        }
    }

    #last;
}

