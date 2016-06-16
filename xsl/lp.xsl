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
  xmlns="http://www.w3.org/TR/REC-html40"
  version="2.0">


<xsl:output 
  method="text"
  encoding="utf-8"/>
 
<xsl:strip-space elements='*'/>
<xsl:preserve-space elements='code-fragment'/>

<xsl:param name='targetdir'>.</xsl:param>
<xsl:param name='javadir'>.</xsl:param>

<xsl:template match='/'>
  <xsl:apply-templates select='/descendant::code-fragment[@class or @file]'/>
</xsl:template>

<xsl:template match='code-fragment[@class]'>
  <xsl:result-document href="{$javadir}/{translate(@package,'.','/')}/{@class}.java">
/*______________________________________________________________________________

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
  ____________________________________________________________________________*/

    <xsl:apply-templates/>
  </xsl:result-document>
</xsl:template>


<xsl:template match='code-fragment[@method="xml"][@file]'>
  <xsl:result-document href="{$targetdir}/{@file}" method='xml'>

    <xsl:apply-templates select='code-title/following-sibling::* | code-title/following-sibling::text()'/>
  </xsl:result-document>
</xsl:template>


<xsl:template match='code-fragment[@file][@method="text"]'>
  <xsl:result-document href="{$targetdir}/{@file}" method="text">
    <xsl:call-template name='trim-cr'>
      <xsl:with-param name='text'>
        <xsl:apply-templates select='code-title/following-sibling::* | code-title/following-sibling::text()'/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:result-document>
</xsl:template>

  
<xsl:template name='trim-cr'>
  <xsl:param name='text'/>
  <xsl:variable name="cr"><xsl:text>&#xa;</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test='starts-with($text,$cr)'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text' select='substring($text,2)'/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test='substring($text,string-length($text))=$cr'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text' select='substring($text,1,string-length($text)-1)'/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$text'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<xsl:key name='scrap-key' match='code-fragment' use='@id'/>


<xsl:template match='code-fragment'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='code-include'>
  <xsl:apply-templates select='key("scrap-key", @linkend)'/>
</xsl:template>

<xsl:template match='code-title'>
</xsl:template>

<xsl:template match='@* | node()'>
  <xsl:copy>
    <xsl:apply-templates select='@* | node()'/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
