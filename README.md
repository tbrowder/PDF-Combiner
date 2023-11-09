[![Actions Status](https://github.com/tbrowder/PDF-Combiner/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/PDF-Combiner/actions) [![Actions Status](https://github.com/tbrowder/PDF-Combiner/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/PDF-Combiner/actions) [![Actions Status](https://github.com/tbrowder/PDF-Combiner/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/PDF-Combiner/actions)

NAME
====

**PDF::Combiner** - Provides routines and a program to combine and title PDF documents

SYNOPSIS
========

```raku
use PDF::Combiner;
combine-pdfs config=our-israel-tour.txt
```

DESCRIPTION
===========

**PDF::Combiner** is a simple but useful tool to combine PDF documents into a single PDF document.

In the example above, **our-israel-tour.txt** is a simple formatted text file containing several types of lines. See the example project `config` files in directory `/example-project` for usable examples of the input file.

Note the PDF files are expected to be in the same directory as the project file. If that is a problem for your use case, please file an issue.

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

  * `=two-sided` value?

    The 'value' is optional. Without it, the result is `True` if the option alone is present. If the option is **not** present, the result is `False`. If the 'value' is present, it is evaluated for truthiness.

  * `=back` value?

    The 'value' is optional. Without it, the result is `True` if the option alone is present. If the option is **not** present, the result is `False`. If the 'value' is present, it is evaluated for truthiness.

  * `=outfile` value!

    The option and 'value' are required.

    It is the file name of the new document which should have no spaces and have a suffix of `.pdf`.

  * `=paper` value! 

    The option is **not** required. But if it is used, then 'value' is required.

    'value' defines the paper size. Current choices are 'Letter' or 'A4'. If the option is not used, the default size is 'Letter'.

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

© 2022-2023 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

