unit module PDF::Combiner::Classes;


use PDF::Content;
use PDF::Lite;
use Text::Utils :strip-comment, :normalize-string;

class Config is export {
    has @.pdfs;

    has $.simple    = False;
    has $.zip       = 150;              # undefined or "150" or "300"

    has $.numbers   = False;
    has $.two-sided = False;
    has $.back      = False;

    has $.margins   = 1 * 72;
    has $.paper     = "Letter";

    has $.outfile;
    has @.title;
    has @.preface;
    has @.afterword;

    has $.title-font;
    has $.title-font-size;
    has $.subtitle-font;
    has $.subtitle-font-size;

    # paper and other info
    method set-option($opt, $val) {
        if not $val.defined {
            die "FATAL: Unexpected undefined value for option '$opt";
        }
        sub return-bool($val --> Bool) {
            my $res;
            if $val ~~ Bool {
                $res = $val
            }
            elsif $val ~~ Str {
                $res = $val ~~ /:i true / ?? True !! False
            }
            $res
        }
        with $opt {
            when /:i numbers / {
                $!numbers = return-bool $val
            }
            when /:i 'two-sided' / {
                $!two-sided = return-bool $val
            }
            when /:i back / {
                $!back = return-bool $val
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
            when /:i simple / {
                $!simple = True
            }
            =begin comment
            when /^ :i '=' zip / {

                if not $val.defined {
                    $!zip = 150;
                }
                else {
                    $val .= Int;
                    if $val  < 150 {
                        $!zip = 150;
                    }
                    else {
                        unless $val == 150 or $val == 300 {
                            die "FATAL: zip value must be 150 or 300, val is '$val'";
                        }
                        $!zip = $val;
                    }
                    $!zip = 150;
                }
                else {
                    $!zip = 0;
                }

            }
            =end comment
            =begin comment
            when /:i zip ['=' (\d+)]? $/ {
                if $0.defined {
                    $val = +$0;
                    unless $val ~~ /150|300/ {
                        die "FATAL: zip value must be 150 or 300, val is '$val'";
                    }
                    $!zip = $val
                }
                elsif $val !~~ /150|300/ {
                    die "FATAL: zip value must be 150 or 300, val is '$val'";
                }
                else {
                    $!zip = $val
                }
            }
            =end comment
            default {
                die "FATAL: Unrecognized option '$opt'";
            }

        }
    }
    method add-file($f) {
        @!pdfs.push: $f
    }
    method add-title-line($s) {
        @!title.push: $s
    }
    method add-preface-line($s) {
        @!preface.push: $s
    }
}
