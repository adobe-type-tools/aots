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
 
<xsl:strip-space elements='*'/>
<xsl:preserve-space elements='code-fragment'/>

<xsl:param name='fontdir'>.</xsl:param>

<xsl:template match='/'>
  <xsl:apply-templates select='/descendant::aots:test-font
                              |/descendant::aots:context-test-font'/>
</xsl:template>



<xsl:template match='aots:test-font'>
  <xsl:result-document href="{$fontdir}/{@id}.xml" method='xml' 
       standalone='yes' indent='yes'>

<xsl:text>
</xsl:text>

<xsl:comment>____________________________________________________________________________
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
  ___________________________________________________________________________</xsl:comment>

<font xmlns="">
  <xsl:attribute name='name'><xsl:value-of select='@id'/></xsl:attribute>

  <xsl:apply-templates/>

  <xsl:call-template name='testfonts.name'>
    <xsl:with-param name='id'><xsl:value-of select='@id'/></xsl:with-param>
  </xsl:call-template>

</font>
  </xsl:result-document>
</xsl:template>




<xsl:template match='aots:context-test-font'>
  <xsl:result-document href="{$fontdir}/gsub_{@id}.xml" method='xml' 
       standalone='yes' indent='yes'>
 
<xsl:text>
</xsl:text>

<xsl:comment>
____________________________________________________________________________
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
  ___________________________________________________________________________
</xsl:comment>


<font xmlns="">
  <xsl:attribute name='name'>gsub_<xsl:value-of select='@id'/></xsl:attribute>

  <base-font name='base.otf'/>

  <xsl:apply-templates select='key("scrap-key", "testfonts.context.gdef")'/>

  <GSUB major='1' minor='0'>
    <xsl:apply-templates
     select='key("scrap-key", "testfonts.gsub.scripts_features")'/>
    <lookupList>
      <xsl:apply-templates 
       select='key("scrap-key", "testfonts.context.gsub.lookups")'/>
      <xsl:apply-templates select='*'/>
    </lookupList>
  </GSUB>

  <xsl:call-template name='testfonts.name'>
    <xsl:with-param name='id'>gsub_<xsl:value-of select='@id'/></xsl:with-param>
  </xsl:call-template>

</font>
  </xsl:result-document>


  <xsl:result-document href="{$fontdir}/gpos_{@id}.xml" method='xml' 
       standalone='yes' indent='yes'>
 
<xsl:text>
</xsl:text>

<xsl:comment>
_____________________________________________________________________________

  ADOBE SYSTEMS INCORPORATED
  © 2000-2005 Adobe Systems Incorporated
  All Rights Reserved.

  NOTICE: Adobe permits you to use, modify, and distribute this file in
  accordance with the terms of the Adobe license agreement accompanying
  it.  If you have received this file from a source other than Adobe,
  then your use, modification, or distribution of it requires the prior
  written permission of Adobe.
  ____________________________________________________________________________
</xsl:comment>

<font xmlns="">
  <xsl:attribute name='name'>gpos_<xsl:value-of select='@id'/></xsl:attribute>

  <base-font name='base.otf'/>

  <xsl:apply-templates select='key("scrap-key", "testfonts.context.gdef")'/>

  <GPOS major='1' minor='0'>
    <xsl:apply-templates 
     select='key("scrap-key", "testfonts.gpos.scripts_features")'/>
    <lookupList>
      <xsl:apply-templates 
       select='key("scrap-key", "testfonts.context.gpos.lookups")'/>
      <xsl:apply-templates select='*'/>
    </lookupList>
  </GPOS>

  <xsl:call-template name='testfonts.name'>
    <xsl:with-param name='id'>gpos_<xsl:value-of select='@id'/></xsl:with-param>
  </xsl:call-template>

</font>
  </xsl:result-document>
</xsl:template>


<xsl:template name='testfonts.name'>
  <xsl:param name='id'/>

  <name>
    <name-record platformID='3' encodingID='1' languageID='1033' 
		 nameID='1' v='{$id}'/>
    <name-record platformID='3' encodingID='1' languageID='1033' 
		 nameID='2' v='Regular'/>
    <name-record platformID='3' encodingID='1' languageID='1033' 
		 nameID='3' v='{$id}'/>
    <name-record platformID='3' encodingID='1' languageID='1033' 
		 nameID='4' v='{$id}'/>
    <name-record platformID='3' encodingID='1' languageID='1033' 
		 nameID='5' v='Version1.0'/>
    <name-record platformID='3' encodingID='1' languageID='1033' 
		 nameID='6' v='{$id}'/>
  </name>
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
