#!/usr/bin/env raku

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} in-pdf=/path/in.pdf out=/path/out
    HERE
    exit;
}

say "To be continued...";
