Using the PDF::API6 to combine PDF documents
============================================

PDF::API6
---------

Here is the original code from `PDF::API6`:

    # the original from David Warring's PDF::API6
    use PDF::API6;
    use PDF::Page;
    use PDF::XObject;
    use PDF::Content;
    my PDF::API6 $old .= open('our/old.pdf');
    my PDF::API6 $pdf .= new;
    my PDF::Page $page = $pdf.add-page;
    my PDF::Content $gfx = $page.gfx;

    # Import first page from the old PDF
    my PDF::XObject $xo = $old.page(1).to-xobject;

    # Add it to the new PDF's first page at 1/2 scale
    my $width = $xo.width / 2;
    my $bottom = 5;
    my $left = 10;
    $gfx.do($xo, :position[$bottom, $left], :$width);

    $pdf.save-as('our/new.pdf');

PDF::Combiner
-------------

Here is the version used with `PDF::Combiner`:

    use PDF::API6;
    use PDF::Page;
    use PDF::XObject;
    use PDF::Content;

    # The new PDF object:
    my PDF::API6 $new-pdf-obj .= new;

    # A collection of "old" PDF file paths to combine:
    for @old-pdfs -> $old-pdf {

        # We need the old PDF object:
        my PDF::API6 $old .= open($old-pdf);

        # Prepare a new page to get a copy of the old pdf's page
        my PDF::Page $new-page = $pdf-new-obj.add-page;
        my PDF::Content $gfx = $new-page.gfx;

        # Import first page from the old PDF
        my PDF::XObject $xo = $old.page(1).to-xobject;

        # Add it to the new PDF's new page via the page's graphics context
        $gfx.do($xo);
    }

    # Finally, save the conbined PDF into a file
    $new-pdf.save-as($new-pdf-path);

Note the algorithm above needs to be modified to handle combining PDF documents with multiple pages. Page numbering can be easily added and a cover page also.

Other embellishments require more work and may need the **Config** mode to handle a more complicated case.

