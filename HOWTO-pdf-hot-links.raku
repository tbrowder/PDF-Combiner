Email from David Warring:

May 12, 2024, 4:48 PM

Hi Tom, Adding a link can be done. It's a bit lower level than I'd
like and you need to know what to look for. Also needs PDF::API6,
rather than PDF::Lite.

Example:

use PDF::API6;
use PDF::Content::Color :&color, :ColorName;
use PDF::Annot::Link;
use PDF::Page;

my PDF::API6 $pdf .= new;

my PDF::Page $page = $pdf.add-page;

$page.graphics: {
    .FillColor = color Blue;
    .text: {
        .text-position = 377, 515;
        my @Border = 0,0,0; # disable border display
        my $uri = 'https://raku.org';
        my PDF::Action::URI $action = $pdf.action: :$uri;
        my PDF::Annot::Link $link = $pdf.annotation(
            :$page,
            :$action,      # action to follow the link
            :text("Raku homepage"), # display text (optional)
            :@Border,
         );
    }
}

$pdf.save-as: "link.pdf";

I'm looking at the pdfmark documentation. It's a postscript operator
and part of the Adobe SDK. It's not understood directly by the PDF
standard, but it's just a set of data-structures, so a module could be
written for it. I'll keep looking
