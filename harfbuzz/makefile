JAVAC=javac
JAVA=java

xslt = $(JAVA) -jar ../jars/saxon9he.jar

all::
	$(xslt) -s:../src/opentype.xml  -xsl:aots2hbtest.xsl  > hb-aots-tester.h

