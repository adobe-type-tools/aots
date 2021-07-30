JAVAC=javac
JAVA=java

xslt = $(JAVA) -jar ../jars/saxon9he.jar

all: hb-aots-tester
	./hb-aots-tester

hb-aots-tester.h: ../src/opentype.xml aots2hbtest.xsl
	$(xslt) -s:$<  -xsl:aots2hbtest.xsl > $@

hb-aots-tester: hb-aots-tester.cpp hb-aots-tester.h
	c++ $< -o $@ $(shell pkg-config --cflags --libs harfbuzz)
