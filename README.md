[![Actions Status](https://github.com/tbrowder/PDF-Combiner/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/PDF-Combiner/actions) [![Actions Status](https://github.com/tbrowder/PDF-Combiner/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/PDF-Combiner/actions) [![Actions Status](https://github.com/tbrowder/PDF-Combiner/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/PDF-Combiner/actions)

NAME
====

**PDF::Combiner** - Provides routines and a program to combine and title PDF documents

SYNOPSIS
========

```raku
use PDF::Combiner;
combine-pdfs config=our-israel-tour.txt
compress-pdf our-israel-tour.pdf
```

Installation requirements
=========================

**PDF::Combiner** requires the system binary program, `ps2pdf`, in order to compress PDF files. To install it on a Debian system, execute:

    sudo apt-get install ps2pdf

To compress any PDF execute:

    ps2pdf -dPDFSETTINGS=/ebook large.pdf smaller.pdf # 150 dpi

    ps2pdf -dPDFSETTINGS=/printer large.pdf smaller.pdf # 300 dpi

A 78 Mb combined PDF compressed to the following sizes:

  * with '-dPDFSETTINGS=/ebook': 2.9 Mb

  * with '-dPDFSETTINGS=/printer': 15 Mb

I could not see any differences in one printed page, but your results may vary. Choose output file compresion on the command line. You may also set it in your project configuration file.

DESCRIPTION
===========

**PDF::Combiner** is a simple but useful tool to combine PDF documents into a single PDF document.

In the example above, **our-israel-tour.txt** is a simple formatted text file containing several types of lines. See the example project `config` files in directory `/example-project` for usable examples of the input file.

Note at the moment, the PDF files are expected to be in the same directory as the project file. If that is a problem for your use case, please file an issue.

Changing PDF Format Versions
----------------------------

Currently, the Raku PDF tools can't reliably handle versions greater than 1.4. However, there is a Ghostscript procedure that may be able to downgrade without causing too much fidelity and is worth trying. The code here was obtained from Stack ********

`config` file
=============

The configuration (or project) file is a typical text file with data in single-line format for most options or in blocks of text. Its suffix is not specified, but the example files have extensions of `.txt` (the author's preference). Options are entered in a format taken from Rakudoc: `=option-name value....` or `=begin option-name`...`=end option-name`..

Blank lines are ignored (except in text blocks) and comments on a line begin at the first `#` character and continue to the end of the line.

Note comments in a text block resulting in a blank line will result in that blank line being retained in the block.

Options
-------

  * `=begin title`...`=end title`

    The lines between the begin/end options are used to populate a cover with the first line being the title and the following lines shown below it after some blank lines.

    Note no cover is produced without this text block, nor is any cover produced if **all** lines are blank.

  * `=numbers` value?

    The 'value' is optional. Without it, the result is `True` if the option alone is present. If the option is **not** present, the result is `False`. If the 'value' is present, it is evaluated for truthiness.

    A true value currently produces page numbers on each page (except any cover which is number one but not shown); format: 'Page N of M'.

    A value of 'per-file' allows a custom page number define per input PDF file. For example:

        pd01.pdf      page01
        pdX.pdf       page02

  * `=two-sided` value?

    The 'value' is optional. Without it, the result is `True` if the option alone is present. If the option is **not** present, the result is `False`. If the 'value' is present, it is evaluated for truthiness.

  * `=back` value?

    The 'value' is optional. Without it, the result is `True` if the option alone is present. If the option is **not** present, the result is `False`. If the 'value' is present, it is evaluated for truthiness.

  * `=outfile` value!

    The option and 'value' are required.

    'value' is the file name of the new document which should have no spaces and have a suffix of `.pdf`.

  * `=paper` value!

    The option is **not** required. But if it is used, then 'value' is required.

    'value' defines the paper size. Current choices are 'Letter' or 'A4'. If the option is not used, the default size is 'Letter'.

  * `=zip` value!

    The option is **not** required. But if it is used, then 'value' is required.

    'value' defines the compression level for the output file. It **must** be either '150' or '300' (dots per inch). It is very useful for PDFs generated from scans. The '150' DPI approximates the density of an ebook while '300' DPI approximates the output from a printer.

Possible additional options
===========================

  * `=begin introduction`...`=end introduction`

CREDITS
=======

Thanks to prolific Raku module distribution author David Warring for his wonderful PDF project ([https://github.com/pdf-raku](https://github.com/pdf-raku)) and especially for his example of how to combine PDF files into one.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2022-2025 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

