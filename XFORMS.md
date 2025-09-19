Using the PDF::API6 to combine PDF documents
============================================

PDF::API6
---------

Here is the code from `PDF::API6`:

    # the original from David's PDF-API6
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

    # my attempt
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

