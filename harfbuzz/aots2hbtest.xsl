<?xml version="1.0" encoding="UTF-8"?>

<!--____________________________________________________________________________

    Copyright 2000-2016 Adobe Systems Incorporated. All Rights Reserved.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use these files except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
  ___________________________________________________________________________-->


<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aots="http://aots.adobe.com/2001/aots"
  version="2.0">

<xsl:output 
  method="text"
  encoding="utf-8"/>

<xsl:template match='/'>
    <xsl:apply-templates select='//aots:gpos-test'/>
    <xsl:apply-templates select='//aots:gsub-test'/>
    <xsl:apply-templates select='//aots:cmap-test'/>
    <xsl:apply-templates select='//aots:context-test'/>
</xsl:template>

<xsl:template match='aots:context-test'>
  { unsigned int in[] = { <xsl:value-of select='@inputs'/> };
    int nbIn = sizeof(in) / sizeof(in[0]);

    unsigned int select[] = { <xsl:value-of select='@select'/> };
    int nbSelect = sizeof(select) / sizeof(select[0]);
    
    unsigned int expected[] = { <xsl:value-of select='@outputs'/> };
    int nbExpected = sizeof(expected) / sizeof(expected[0]);

    if (gsub_test ("gsub_<xsl:value-of select='@id'/>",
                   "../tests/gsub_<xsl:value-of select='@font'/>.otf",
                   nbIn, in, nbSelect, select, nbExpected, expected)) {
       pass++; }
     else {
       failures++; }
  }
  
  { unsigned int in[] = { <xsl:value-of select='@inputs'/> };
    int nbIn = sizeof(in) / sizeof(in[0]);

    <xsl:choose>
      <xsl:when test='@outputs'>
        unsigned int out[] = { <xsl:value-of select='@outputs'/> };
      </xsl:when>
      <xsl:otherwise>
        unsigned int *out = in;
      </xsl:otherwise>
    </xsl:choose>

    int x[] = { <xsl:value-of select='@xdeltas'/> };
    int y[] = { <xsl:value-of select='@ydeltas'/> };
    int nbOut = sizeof(x) / sizeof(x[0]);
    
    if (gpos_test ("gpos_<xsl:value-of select='@id'/>",
                   "../tests/gpos_<xsl:value-of select='@font'/>.otf",
                   nbIn, in, nbOut, out, x, y)) {
       pass++; }
     else {
       failures++; }
  }
</xsl:template>

<xsl:template match='aots:cmap-test'>
  { unsigned int in[] = { <xsl:value-of select='@inputs'/> };
    int nbIn = sizeof(in) / sizeof(in[0]);

    unsigned int select[] = { <xsl:value-of select='@select'/> };
    int nbSelect = sizeof(select) / sizeof(select[0]);

    unsigned int expected[] = { <xsl:value-of select='@outputs'/> };
    int nbExpected = sizeof(expected) / sizeof(expected[0]);

    if (cmap_test ("<xsl:value-of select='@id'/>",
                   "../tests/<xsl:value-of select='@font'/>.otf",
                   nbIn, in, nbSelect, select, nbExpected, expected)) {
       pass++; }
     else {
       failures++; }
  }
</xsl:template>

<xsl:template match='aots:gsub-test'>
  { unsigned int in[] = { <xsl:value-of select='@inputs'/> };
    int nbIn = sizeof(in) / sizeof(in[0]);

    unsigned int select[] = { <xsl:value-of select='@select'/> };
    int nbSelect = sizeof(select) / sizeof(select[0]);
    
    unsigned int expected[] = { <xsl:value-of select='@outputs'/> };
    int nbExpected = sizeof(expected) / sizeof(expected[0]);

    if (gsub_test ("<xsl:value-of select='@id'/>",
                   "../tests/<xsl:value-of select='@font'/>.otf",
                   nbIn, in, nbSelect, select, nbExpected, expected)) {
       pass++; }
     else {
       failures++; }
  }
</xsl:template>

<xsl:template match='aots:gpos-test'>
  { unsigned int in[] = { <xsl:value-of select='@inputs'/> };
    int nbIn = sizeof(in) / sizeof(in[0]);

    <xsl:choose>
      <xsl:when test='@outputs'>
        unsigned int out[] = { <xsl:value-of select='@outputs'/> };
      </xsl:when>
      <xsl:otherwise>
        unsigned int *out = in;
      </xsl:otherwise>
    </xsl:choose>

    int x[] = { <xsl:value-of select='@xdeltas'/> };
    int y[] = { <xsl:value-of select='@ydeltas'/> };
    int nbOut = sizeof(x) / sizeof(x[0]);
    
    if (gpos_test ("<xsl:value-of select='@id'/>",
                   "../tests/<xsl:value-of select='@font'/>.otf",
                   nbIn, in, nbOut, out, x, y)) {
       pass++; }
     else {
       failures++; }
  }
</xsl:template>

</xsl:stylesheet>
