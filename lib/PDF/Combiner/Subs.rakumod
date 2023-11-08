unit module PDF::Subs;

use PDF::Content;
use PDF::Lite;
use Text::Utils :strip-comment;

class Config is export {
    has @.pdfs;

    has $.numbers = False;
    has $.margins = 1 * 72;
    has $.paper = "Letter";
    has $.outfile;
    has $.title;

    has $.subtitle;
    has $.title-font;
    has $.title-font-size;
    has $.subtitle-font;
    has $.subtitle-font-size;

    method set-option($opt, $val is copy) {
        with $opt {
            when /:i numbers / {
                $!numbers = $val 
            }
            when /:i margins / {
                $!margins = $val 
            }
            when /:i paper / {
                $!paper = $val 
            }
            when /:i outfile / {
                $!outfile = $val 
            }
            when /^:i title / {
                $!title = $val 
            }
        }
    }
    method add-file($f) {
        @!pdfs.push: $f
    }
}

# add a cover for the collection
my PDF::Lite::Page $page = $pdf.add-page;
my $font  = $pdf.core-font(:family<Times-RomanBold>);
my $font2 = $pdf.core-font(:family<Times-Roman>);
# make this a sub: sub make-cover-page(PDF::Lite::Page $page, |c) is export
sub make-cover-page(PDF::Lite::Page $page, :$font, :$font2, :$debug) is export {
    $page.text: -> $txt {      # $txt is a child of the $page
        my ($text, $baseline);

        $baseline = 7*72;
        $txt.font = $font, 16;
        $text = $new-title;

        $txt.text-position = 0, $baseline; # baseline height is determined here
        # output aligned text
        $txt.say: $text, :align<center>, :position[$centerx];

        $txt.font = $font2, 14;
        $baseline -= 60;
        $txt.text-position = 0, $baseline; # baseline height is determined here
        $txt.say: "by", :align<center>, :position[$centerx];

        $baseline -= 30;
        my @text = "Tony O'Dell", "2022-09-23", "[https://deathbykeystroke.com]";
        for @text -> $text {
            $baseline -= 20;
            $txt.text-position = 0, $baseline; # baseline height is determined here
            $txt.say: $text, :align<center>, :position[$centerx];
        }
    }
}

sub select-font() {
}

sub read-config-file($fnam, :$debug --> Config) is export {
    my $c = Config.new;

    my $dir = $fnam.IO.parent;
    LINE: for $fnam.IO.lines -> $line is copy {
        $line = strip-comment $line;
        next if $line !~~ /\S/;
        if $line ~~ /\h* (\S+) \h* ':' (\N*) / {
            # option : value
            my $opt = ~$0.lc;
            my $val = ~$1;
            $c.set-option: $opt, $val;
        }
        elsif $line ~~ / (\S+) / {
            # file name
            my $f = ~$0;
            my $path = "$dir/$f";
            unless $path.IO.f {
                note "WARNING: File '$path' not found. Ignoring it.";
                next LINE;
            }
            $c.add-file: $path;
        }
        else {
            die "FATAL: Should not get here. Please file an issue.";
        }
    }
    $c
}

# from github/pod-to-pdf/Pod-To-PDF-Lite-raku/
# method !paginate($pdf) {
sub paginate($pdf, 
    :$margin!,
    :$number-first-page = False,
    :$count-first-page  = False,
    ) is export {

    my $page-count = $pdf.Pages.page-count;
    my $font = $pdf.core-font: "Helvetica";
    my $font-size := 9;
    my $align := 'right';
    my $page-num = 0;
    # modify page-count? 
    if not $count-first-page { # not usual in my book
        --$page-count;
        $number-first-page = False;
    }

    for $pdf.pages.iterate-pages -> $page {
        my $first-page = True;
        if $first-page {
            $first-page = False;
            next unless $count-first-page;
            if not $number-first-page {
                ++$page-num;
                next;
            }
        }
        ++$page-num;

        my PDF::Content $gfx = $page.gfx;
        # need some vertical whitespace here
        my $vspace = 0.4 * $font-size;
        #my @position = $gfx.width - $margin, $margin - $font-size;
        my @position = $gfx.width - $margin, $margin - $font-size - $vspace;

        #my $text = "Page {++$page-num} of $page-count";
        my $text = "Page $page-num of $page-count";
        $gfx.print: $text, :@position, :$font, :$font-size, :$align;
        $page.finish;
    }
}
