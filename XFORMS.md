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

    sub simple-combine-pdf-api6(
        @old-pdfs!,  #= input PDF file paths to be combined
        :$ofile!,    #= the desired output PDF path
        :$page-nums, #= option
        :$debug,
    ) is export {
        use PDF::API6;
        use PDF::Page;
        use PDF::XObject;
        use PDF::Content;

        # The new PDF object:
        my PDF::API6 $new-pdf-obj .= new;
        my $total-pages = 0;

        # A collection of "old" PDF file paths to combine:
        for @old-pdfs -> $old-pdf {

            # We need the old PDF object:
            my PDF::API6 $old-obj .= open($old-pdf);

            # The old PDF may have more than one page
            my $pc = $old-obj.page-count;
            $total-pages += $pc;

            for 1..$pc -> $num {

                # Prepare a new page to get a copy of the old pdf's page
                my PDF::Page $new-page = $new-pdf-obj.add-page;

                # We need the new page's graphics context to add new content
                my PDF::Content $gfx = $new-page.gfx;

                # Import the first page's content from the old PDF
                my PDF::XObject $xo = $old-obj.page(1).to-xobject;

                # Add it to the new PDF's new page via the page's graphics context
                $gfx.do($xo);
            }
        }

        # Finally, save the conbined PDF into a file
        $new-pdf-obj.save-as($ofile);
    }

