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

In the example above, **our-israel-tour.txt** is a simple formatted text file containing several types of lines. See the example project `config` files in directory `/example-project` for details of the file.

Note the PDF files are expected to be in the same directory as the project file. If that is a problem for your use case, please file an issue.

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

