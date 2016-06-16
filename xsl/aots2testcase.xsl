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
# Copyright 2000-2016 Adobe Systems Incorporated. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use these files except in compliance with the License.
# You may obtain a copy of the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
    
    <xsl:apply-templates select='//aots:gsub-test'/>
    <xsl:apply-templates select='//aots:gpos-test'/>
    <xsl:apply-templates select='//aots:context-test'/>
    <xsl:apply-templates select='//aots:cmap-test'/>
    <xsl:apply-templates select='//aots:cmap-uvs-test'/>
</xsl:template>

<xsl:template match='aots:cmap-test'>
  if [ `expr <xsl:value-of select='@id'/> : $1` != 0 ]; then
  java com.adobe.aots.opentype.CmapTester \
    -testname <xsl:value-of select='@id'/> \
    -font '<xsl:value-of select='@font'/>.otf' \
    -platform '<xsl:value-of select='@platformID'/>' \
    -encoding '<xsl:value-of select='@encodingID'/>' \
    -inputs   '<xsl:value-of select='@inputs'/>' \
    -expected '<xsl:value-of select='@outputs'/>'
  fi
</xsl:template>

<xsl:template match='aots:cmap-uvs-test'>
  if [ `expr <xsl:value-of select='@id'/> : $1` != 0 ]; then
  java com.adobe.aots.opentype.CmapUVSTester \
    -testname <xsl:value-of select='@id'/> \
    -font '<xsl:value-of select='@font'/>.otf' \
    -inputs   '<xsl:value-of select='@inputs'/>' \
    -expected '<xsl:value-of select='@outputs'/>'
  fi
</xsl:template>

<xsl:template match='aots:gsub-test'>
  if [ `expr <xsl:value-of select='@id'/> : $1` != 0 ]; then
  java com.adobe.aots.opentype.GsubTester \
    -testname <xsl:value-of select='@id'/> \
    -font '<xsl:value-of select='@font'/>.otf' \
    -script latn -language UNKN -features test \
    -glyphs '<xsl:value-of select='@inputs'/>' \
    -expected '<xsl:value-of select='@outputs'/>'
  fi
</xsl:template>

<xsl:template match='aots:gpos-test'>
  if [ `expr <xsl:value-of select='@id'/> : $1` != 0 ]; then
  java com.adobe.aots.opentype.GposTester \
    -testname <xsl:value-of select='@id'/> \
    -font '<xsl:value-of select='@font'/>.otf' \
    -script latn -language UNKN -features test \
    -glyphs '<xsl:value-of select='@inputs'/>' \
    -xdeltas '<xsl:value-of select='@xdeltas'/>' \
    -ydeltas '<xsl:value-of select='@ydeltas'/>' \
    <xsl:if test='@attach'>-components '<xsl:value-of select='@attach'/>'</xsl:if>
  fi
</xsl:template>


<xsl:template match='aots:context-test'>
  if [ `expr <xsl:value-of select='@id'/>_gsub : $1` != 0 ]; then
  java com.adobe.aots.opentype.GsubTester \
    -testname gsub_<xsl:value-of select='@id'/> \
    -font 'gsub_<xsl:value-of select='@font'/>.otf' \
    -script latn -language UNKN -features test \
    -glyphs '<xsl:value-of select='@inputs'/>' \
    -expected '<xsl:value-of select='@outputs'/>'
  fi

  if [ `expr <xsl:value-of select='@id'/>_gpos : $1` != 0 ]; then
  java com.adobe.aots.opentype.GposTester \
    -testname gpos_<xsl:value-of select='@id'/> \
    -font 'gpos_<xsl:value-of select='@font'/>.otf' \
    -script latn -language UNKN -features test \
    -glyphs '<xsl:value-of select='@inputs'/>' \
    -xdeltas '<xsl:value-of select='@xdeltas'/>' \
    -ydeltas '<xsl:value-of select='@ydeltas'/>' \
    <xsl:if test='@refpos'>-refpos '<xsl:value-of select='@refpos'/>'</xsl:if> \
    <xsl:if test='@attach'>-components '<xsl:value-of select='@attach'/>'</xsl:if>
  fi
</xsl:template>


</xsl:stylesheet>
