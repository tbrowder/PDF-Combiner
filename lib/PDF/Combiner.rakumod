unit module PDF::Combiner;

use PDF::Lite;
use PDF::Font::Loader;

use PDF::Combiner::Subs;

=begin comment
my enum Paper <Letter A4>;
my $debug   = 0;
my $left    = 1 * 72; # inches => PS points
my $right   = 1 * 72; # inches => PS points
my $top     = 1 * 72; # inches => PS points
my $bottom  = 1 * 72; # inches => PS points
my $margin  = 1 * 72; # inches => PS points
my Paper $paper  = Letter;
my $page-numbers = False;

# defaults for US Letter paper
my $height = 11.0 * 72;
my $width  =  8.5 * 72;
# for A4
# $height =; # 11.7 in
# $width = ; #  8.3 in
=end comment

multi sub run-cli() is export {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} config=my-pdf-project.txt

    Args
        config=X - where X is the name of a configuration file listing various
                   options as well as a list of PDF documents to be combined,
                   one name or option per line, comments and blank lines are
                   ignored. See the 'example-project' directory for an example.

    'config' file options when present in the file
        =numbers   Bool [explicit 'true' or 'false' OR, with no value:
                     True if present, False if not]

                   produces page numbers on each page
                   except the cover which is number
                   one but not shown; format: 'Page N of M'

        =begin title # empty or no title bock: no cover page
                   title line for the cover page
                   # a retained blank line for the cover page
                   another title line for the cover page
        =end title
        =two-sided Bool [explicit 'true' or 'false' OR, with no value:
                     True if present, False if not]
        =back      Bool [explicit 'true' or 'false' OR, with no value:
                     True if present, False if not]
        =outfile   file name of the new document
        =paper     'Letter' or 'A4' [default: Letter]
        =margins   size in PostScript points [default: 72 (one inch)]

    Combines the input PDFs into one document
    HERE
    exit
} # multi sub run-cli() is export {

multi sub run-cli(@args) is export {

    # run all from here while calling into PDF::Combiner::Subs
    my $debug = 0;
    my Config $c;
    # default config file for debugging;
    #my $IFIL = "example-project/our-israel-trip.txt";
    my $IFIL = "/home/tbrowde/mydata/tbrowde-home/israel-trip-1980/our-israel-trip.txt"; 

    my $ifil;
    for @args {
        when /^:i d/ {
            ++$debug;
            $ifil = $IFIL;
            note "DEBUG is on";
        }
        when /^config '=' (\S+) $/ {
            $ifil = ~$0;
            unless $ifil.IO.r {
                say "FATAL: Unable to open config file '$ifil'";
                exit;
            }
        }
        default {
            say "FATAL: Unknown arg '$_'"; exit;
        }
    }

    # collect data
    $c = read-config-file $ifil, :$debug;

    my @pdf-objs;
    for $c.pdfs -> $pdf-in {
        my $pdf-obj = PDF::Lite.open: $pdf-in;
        @pdf-objs.push: $pdf-obj;
    }

    # do we need to specify 'media-box'?
    my ($centerx, $height, $width);
    my $pdf = PDF::Lite.new;
    if $c.paper eq "Letter" {
        $pdf.media-box = 'Letter';
        $height = 11.0 * 72;
        $width  =  8.5 * 72;
    }
    else {
        $pdf.media-box = 'A4';
        $height = 11.7 * 72;
        $width  =  8.3 * 72;
    }
    $centerx = 0.5 * $width;

    # manipulate the PDF some more
    my $tot-pages = 0;

    my PDF::Lite::Page $page;

    # do we need a cover?
    my @tlines;
    if $c.title.elems {
        for $c.title.values -> $val {
            @tlines.push($val) if $val ~~ /\S+/
        }
    }

    my $has-cover = False;
    my $two-sided = $c.two-sided;
    my $has-back  = $c.back;
    if @tlines.elems {
        $has-cover = True;
        # add a cover for the collection
        $page = $pdf.add-page;
        my $font  = $pdf.core-font(:family<Times-RomanBold>);
        my $font2 = $pdf.core-font(:family<Times-Roman>);

        make-cover-page $page, :config($c), :$centerx, :$font, :$font2, :$debug;
        if $c.two-sided {
            # for now just add a blank page
            $page = $pdf.add-page;
        }
    }

    for @pdf-objs.kv -> $i, $pdf-obj {

        # handle multi-page files being combined
        my $part = $i+1;

        =begin comment
        # add a cover for part $part
        $page = $pdf.add-page;
        $page.text: -> $txt {
            my $text = "Part $part";
            $txt.font = $font, 16;
            $txt.text-position = 0, 7*72; # baseline height is determined here
            # output aligned text
            $txt.say: $text, :align<center>, :position[$centerx];
        }
        =end comment

        my $pc = $pdf-obj.page-count;
        say "Input doc $part: $pc pages";
        $tot-pages += $pc;
        for 1..$pc -> $page-num {
            $pdf.add-page: $pdf-obj.page($page-num);
        }
    }

    if $has-back {
        # add a single blank page
        $page = $pdf.add-page;
        say "A single page, empty back cover added."
    }

    if $c.numbers {
        say "Page numbers being added";
        # note we vary position of the number depending
        # on two-sided or not

        #=begin comment
        # use method !paginate($pdf) from David's github.com/pod-to-pdf/Pod-To-PDF-Lite-raku
        #method !paginate($pdf) {
            my $page-count = $pdf.Pages.page-count;
            my $font = $pdf.core-font: "Helvetica";
            my $font-size := 9;
            my $align := 'right';
            my $page-num = 0;
            --$page-count if $has-back;

            PAGE: for $pdf.Pages.iterate-pages -> $page {
                ++$page-num;
                next PAGE if $page-num == 1 and $has-cover;
                last PAGE if $has-back and $page-num > $page-count;
                #if $has-back and $page-num == $page-count {
                #    last;
                #}

                my PDF::Content $gfx = $page.gfx;

                my $is-odd = $page-num % 2 ?? True !! False;

                my $text = "Page {$page-num} of $page-count";
                my @position = $gfx.width - $c.margins, $c.margins - $font-size;
                if $c.two-sided and not $is-odd {
                    # odd numbers on facing pages (obverse) are bottom right
                    #   (or none on front cover)
                    # even numbers on back side (reverse) are bottom left
                    @position = 0 + $c.margins, $c.margins - $font-size; 
                    $gfx.print: $text, :@position, :$font, :$font-size, :align<left>;
                }
                else {
                    $gfx.print: $text, :@position, :$font, :$font-size, :$align;
                }
                $page.finish;
            }
        #}
        #=end comment
    }

    say "Total input pages: $tot-pages";
    my $new-pages = $pdf.page-count;

    $pdf.save-as: $c.outfile; #$new-doc;
    say "See combined pdf: {$c.outfile}"; #$new-doc";
    say "Total pages: $new-pages";

    =begin comment
    my @pdfs-in;
    @pdfs-in = <
        pdf-docs/Creating-a-Cro-App-Part1-by-Tony-O.pdf
        pdf-docs/Creating-a-Cro-App-Part2-by-Tony-O.pdf
    >;
    # title of output pdf
    my $new-doc   = "An-Apache-Cro-Web-Server.pdf";
    # title on cover
    my $new-title = "An Apache/CRO Web Server";
    =end comment



} #multi sub run-cli(@args) is export {
#==== end of this file's content ============

=finish

for @*ARGS {
    when /^ :i n[umbers]? / {
        $page-numbers = True;
    }
    when /^ :i pa[per]? '=' (\S+) / {
        $paper = ~$0;
        if $paper ~~ /^ :i a4 $/ {
            $height = 11.7 * 72;
            $width  =  8.3 * 72;
        }
        elsif $paper ~~ /^ :i L / {
            $height = 11.0 * 72;
            $width  =  8.5 * 72;
        }
        else {
            die "FATAL: Unknown paper type '$paper'";
        }
    }
    when /^ :i l[eft]? '=' (\S+) / {
        $left = +$0 * 72;
    }
    when /^ :i r[ight] '=' (\S+) / {
        $right = +$0 * 72;
    }
    when /^ :i t[op]? '=' (\S+) / {
        $right = +$0 * 72;
    }
    when /^ :i b[ottom]? '=' (\S+) / {
        $bottom = +$0 * 72;
    }
    when /^ :i m[argin]? '=' (\S+) / {
        $margin = +$0 * 72;
    }
    when /^ :i d / { ++$debug }
    when /^ :i g / {
        ; # okay: ++$go;
    }
    when /^ :i t[itle]? ['=' (\S+) ]? / {
        $new-title = ~$0;
        $new-title ~~ s:g/'.'/ /;
    }
    when /^ :i c[omb]? ['=' (\S+) ]? / {
        $new-doc = ~$0;
    }
    when /^ :i pd[f]? ['=' (\S+) ]? / {
        if $0.defined {
            note "WARNING: mode 'pdf=X' is  NYI";
            note "         Exiting..."; exit;
            @pdfs-in = read-pdf-list ~$0;
        }
        else {
            say "Using internal list of PDF files:";
            say "    $_" for @pdfs-in;
        }
    }
    default {
        note "WARNING: Unknown arg '$_'";
        note "         Exiting..."; exit;
    }
}


# make this a sub: sub make-cover-page(PDF::Lite::Page $page, |c) is export
$page.text: -> $txt {
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

for @pdf-objs.kv -> $i, $pdf-obj {
    my $part = $i+1;

    # add a cover for part $part
    $page = $pdf.add-page;
    $page.text: -> $txt {
        my $text = "Part $part";
        $txt.font = $font, 16;
        $txt.text-position = 0, 7*72; # baseline height is determined here
        # output aligned text
        $txt.say: $text, :align<center>, :position[$centerx];
    }

    my $pc = $pdf-obj.page-count;
    say "Input doc $part: $pc pages";
    $tot-pages += $pc;
    for 1..$pc -> $page-num {
        $pdf.add-page: $pdf-obj.page($page-num);
    }
}

if $page-numbers {
    # use method !paginate($pdf) from David's github.com/pod-to-pdf/Pod-To-PDF-Lite-raku
}

say "Total input pages: $tot-pages";
my $new-pages = $pdf.page-count;

$pdf.save-as: $new-doc;
say "See combined pdf: $new-doc";
say "Total pages: $new-pages";

=end comment

}
