Using the Config mode
=====================

The 'config' mode is designed for complex projects as exemplified in the directory 'example-projects/israel-trip/'.

'config' file options when present in the file
----------------------------------------------

### `=ofile Str`

Output file name of the new document

### `=numbers Bool`

Explicit 'true' or 'false' OR, with no value: True if present, False if not

Produces page numbers on each page except the cover which is number 'i' (one but not shown); format: 'Page N of M' (a title page by default gets a blank reverse page which is page 'ii' but is not shown)

### `=begin title`

Empty or no title block: no cover page

title line for the cover page

# a retained blank line for the cover page

another title line for the cover page

### `=end title`

### `=two-sided Bool`

Explicit 'true' or 'false' OR, with no value: True if present, False if not

### `=back Bool`

Explicit 'true' or 'false' OR, with no value: True if present, False if not

### `=paper size-type`

'Letter' or 'A4' [default: Letter]

### `=margins Numeric`

Size in PostScript points [default: 72 (one inch)]

### `=compress Numeric?`

empty OR 150 or 300 [default: empty (none)]

Numberic is the dots per inch (dpi) value

