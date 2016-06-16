JAVAC=javac
JAVA=java

xslt = $(JAVA) -jar jars/saxon9he.jar

all::

clean::
	rm -fr html java schemas tests jars/aots.jar


java/com/adobe/aots/opentype/Font.java : \
		src/opentype.xml src/cff.xml src/type2.xml xsl/lp.xsl
	$(xslt) -s:src/opentype.xml -xsl:xsl/lp.xsl targetdir=schemas javadir=java
	$(xslt) -s:src/cff.xml      -xsl:xsl/lp.xsl targetdir=schemas javadir=java
	$(xslt) -s:src/type2.xml    -xsl:xsl/lp.xsl targetdir=schemas javadir=java 

java/com/adobe/aots/opentype/Font.class: \
		java/com/adobe/aots/opentype/Font.java
	(cd java; $(JAVAC) -cp '../jars/*' com/adobe/aots/opentype/*.java com/adobe/aots/util/*.java)


java/com/adobe/aots/opentype/opentype.rnc: \
		schemas/opentype.rnc
	cp schemas/opentype.rnc   java/com/adobe/aots/opentype/opentype.rnc
	cp schemas/cfffontset.rnc java/com/adobe/aots/opentype/cfffontset.rnc


jars/aots.jar: \
		java/com/adobe/aots/opentype/Font.class \
		java/com/adobe/aots/opentype/opentype.rnc
	(cd java; jar cf ../jars/aots.jar com)


tests/gsub1_1_font1.xml: src/opentype.xml xsl/aots2testfont.xsl
	$(xslt) -s:src/opentype.xml -xsl:xsl/aots2testfont.xsl fontdir=tests

tests/base.otf: src/base.otf
	mkdir -p tests
	cp src/base.otf tests/


tests/gsub1_1_font1.otf: \
		tests/base.otf tests/gsub1_1_font1.xml jars/aots.jar
	(cd tests; \
	  for f in *.xml; do \
	    echo -- compiling $$f; \
	    $(JAVA) -cp '../jars/*' com.adobe.aots.opentype.Compiler \
		-o `basename  $$f .xml`.otf $$f; \
	  done)


tests/testcases.sh: src/opentype.xml xsl/aots2testcase.xsl
	$(xslt) -s:src/opentype.xml -xsl:xsl/aots2testcase.xsl -o:tests/testcases.sh

TESTS=.
testengine:: tests/testcases.sh tests/gsub1_1_font1.otf
	(cd tests; CLASSPATH=../java sh ./testcases.sh $(TESTS))


testdecompiler:: tests/gsub1_1_lookupflag_f1.otf
	@(cd tests; \
	 rm -fr decompiler; \
	 mkdir decompiler; \
	 echo ========== decompiling; \
	 for f in classdef*.otf gpos*.otf gsub*.otf context*.otf; do \
	    echo -- decompiling to decompiler/`basename $$f .otf`.xml; \
	    $(JAVA) -cp '../jars/*' com.adobe.aots.opentype.Decompiler -t GSUB,GPOS,GDEF,name \
                -exact \
		$$f > decompiler/`basename $$f .otf`.xml; \
	    done; \
	 echo ========== compiling; \
	 for f in decompiler/*.xml; do \
	    echo -- compiling to decompiler/`basename $$f .xml`.otf; \
	    $(JAVA) -cp '../jars/*' com.adobe.aots.opentype.Compiler \
		-o decompiler/`basename $$f .xml`.otf $$f; \
	    done; \
	 echo ========== comparing; \
	 for f in decompiler/*.otf ; do \
	    echo -- comparing $$f; \
	    diff $$f `basename $$f`; \
            done)

htmls:: html/opentype.html html/cff.html html/type2.html

html/opentype.html: src/opentype.xml
	mkdir -p html
	$(xslt) -s:src/opentype.xml -xsl:xsl/aots2docbook.xsl fontdir=../tests/ tracedir=../tests/ | \
	$(xslt) -s:- -xsl:xsl/docbook2html.xsl -o:html/opentype.html imagedir=../src/images

html/cff.html: src/cff.xml
	mkdir -p html
	$(xslt) -s:src/cff.xml -xsl:xsl/aots2docbook.xsl fontdir=../tests/ tracedir=../tests/ | \
	$(xslt) -s:- -xsl:xsl/docbook2html.xsl -o:html/cff.html  imagedir=../src/images

html/type2.html: src/type2.xml
	mkdir -p html
	$(xslt) -s:src/type2.xml -xsl:xsl/aots2docbook.xsl fontdir=../tests/ tracedir=../tests/ | \
	$(xslt) -s:- -xsl:xsl/docbook2html.xsl -o:html/type2.html imagedir=../src/images


all:: testengine htmls

clean::

