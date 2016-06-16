AOTS
====

The **Annotated OpenType specification** interleaves a number of pieces:

* the OpenType specification

* annotations to clarify the specification, when needed

* an XML representation of OpenType fonts. This includes a Relax NG schema, which
implements the bulk of the validity checking.

* a compiler, to convert from the XML representation to font files.

* a decompiler, to convert font files to their XML representation.

* a font library, to access the data in fonts, and also to apply GSUB/GPOS features.
The goal of this code is to illustrate the specification, and may be substantially
different from production code.

* a test suite for the compiler, decompiler and font library; this
      consists of ~200 hand crafted test fonts and ~300
      test cases (inputs and expected output) that exercise the
      library. There is also a test harness to exercise Harfbuzz.

Similarly, there is an Annotated CFF specification, and an Annotated Type2 specification.


Building
--------

All the code is written in Java, so you will need a Java installation.

To build AOTS, simply run `make`.

AOTS uses a [literate programming](https://en.wikipedia.org/wiki/Literate_programming)
style. The source material is all in src/. The build process tangles the code in java/ and
jars/, the schemas in schemas/, the test fonts and test cases in tests/. It weaves in html/.

The build process also runs the tests against the code.

After you have built AOTS, it may be helpful to look at a simple
piece of the specification, Section 25.6, [Single Substitution Format 1](html/opentype.html#25.6),
to see how this Annotated Specification is organized.


Limitations
-----------

This is work in progress. Among the major missing pieces:

* the text of the OpenType specification is (approximately)
      that of the 1.4 specification, but some parts are absent.

* the XML representation does not cover a number of tables; when decompiling to XML, those
will generate an `<unknownTable>` element, except the glyf and loca tables which disappear
entirely

* the functionality of the library is somewhat spotty; the methods were added as needed

* there is a bit of documentation for the options of the compiler and decompiler below;
you have to read the code to get the full story.


The font decompiler
-------------------

The decompiler is implemented as the main method of the class
`com.adobe.aots.opentype.Decompiler`. It takes an
OpenType font file and produces an XML representation of
it.

The order of arguments matters.

Optional: `-t` followed by names of tables,
separated by ',' (e.g. `-t 'CFF,GPOS,GSUB'`), to
select which tables to decompile. All tables if this argument is
absent.

Optional: one of `-exact` or
    `-readable`, defaults to readable. In exact mode,
    the decompilation result is made to closely reflect what is in the
    font; for example, the details of how a coverage is defined are
    visible. In readable mode, the result is made as readable as
    possible; for example, you will only know which glyphs are
    covered, not how this coverage is expressed. However, readable
    does not loose information.

Optional: one of `-pointers=never`,
    `-pointers=asneeded` or
    `-pointers=always`, defaults to never in readable
    mode, to asneeded in exact mode. OpenType fonts have internal
    pointers between data structures. With always, those pointers are
    explicitly represented; with never, they are never represented;
    with asneeded, they are represented only if the thing that is
    pointed to is pointed from multiple places.

Optional: `-o` _outputfile_ sends the output to _outputfile, defaults to standard output.

Mandatory: _fontfile_

Current limitations: not all tables are supported. There
    will be no trace of the 'glyf' and 'loca' tables; for the other
    unsupported table, you will have an
    `<unknownTable>` element.


The font compiler
-----------------

The compiler is implemented as the main method of the class
    `com.adobe.aot.opentype.Compiler`. It takes an XML
    representation of an OpenType font and creates a font file.

The order of arguments matters.

Mandatory: `-r` _schemafile_ points to the RNG schema for the XML
    representation: `schemas/opentype.rnc`.

Mandatory: `-o` _outputfile_ for the resulting font file

Mandatory: _inputfile_

Current limitations: probably many. Use with caution.

