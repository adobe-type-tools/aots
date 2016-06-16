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
  xmlns:web="http://aots.adobe.com/2001/web"
  xmlns:aots="http://aots.adobe.com/2001/aots"
  xmlns:ots="http://aots.adobe.com/2001/ots"
  xmlns=""
  version="2.0">

<xsl:output 
  method="xml"
  standalone="yes"
  indent="no"
  encoding="utf-8"/>
 
<xsl:param name='tracedir'>.</xsl:param>
<xsl:param name='fontdir'>test_fonts</xsl:param>


<xsl:template match='article'>
  <article>
    <xsl:for-each select='@*'>
      <xsl:copy/>
    </xsl:for-each>
  <xsl:apply-templates/>

    <section id='tests-index'>
      <title>Test Font Index</title>
  
      <para>This is the list of all the test fonts in the AOTS test suite.</para>

      <simplelist>
        <xsl:for-each select='//aots:test-font'>

          <member>
             <link>
               <xsl:attribute name='linkend'>
                 <xsl:text>section.</xsl:text>
                 <xsl:number level='multiple' count='section|chapter' format='1.1'/>
               </xsl:attribute>
               <xsl:value-of select='@id'/></link></member>
        </xsl:for-each>
      </simplelist>
    </section>

    <section id='tests-index'>
      <title>Tests Index</title>
  
      <para>This is the list of all the test cases in the AOTS test suite.</para>

      <simplelist>
        <xsl:for-each select='//aots:cmap-test
                            | //aots:cmap-uvs-test
			    | //aots:gsub-test 
                            | //aots:gpos-test
			    | //aots:context-test'>

          <member>
             <link>
               <xsl:attribute name='linkend'>
                 <xsl:text>section.</xsl:text>
                 <xsl:number level='multiple' count='section|chapter' format='1.1'/>
               </xsl:attribute>
               <xsl:value-of select='@id'/></link></member>
        </xsl:for-each>
      </simplelist>
    </section>
  
  </article>
</xsl:template>


<xsl:template match='section[@role="fragment"]'>
    <section>
      <xsl:for-each select='@*'>
        <xsl:copy/>
      </xsl:for-each>

      <title><xsl:value-of select='title'/></title>

      <xsl:apply-templates select='section'/>
    </section>
</xsl:template>

<xsl:template match='section'>
  <xsl:copy>
    <xsl:attribute name='id'>
      <xsl:text>section.</xsl:text>
      <xsl:number level='multiple' count='section|chapter' format='1.1'/>
    </xsl:attribute>
    <xsl:apply-templates select='@* | node()'/>
  </xsl:copy>
</xsl:template>


<xsl:template match='code-fragment'>
  <para>
    <programlisting>
  <xsl:choose>
    <xsl:when test='code-title'>
      <anchor id='{generate-id()}'/><xsl:apply-templates select='code-title'/> ==
      <xsl:apply-templates select='code-title/following-sibling::* | code-title/following-sibling::text()' mode='code-fragment'/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode='code-fragment'/>
    </xsl:otherwise>  
  </xsl:choose>
</programlisting>
  </para>
</xsl:template>

<xsl:template match='code-title'>
  <classname><xsl:apply-templates/></classname>
</xsl:template>

<xsl:key name='code-fragment-key' match='code-fragment' use='@id'/>

<xsl:template match='code-include' mode='code-fragment'>
  <xsl:choose>
    <xsl:when test='count(key ("code-fragment-key", @linkend))=1'>
      <xsl:for-each select='key("code-fragment-key",@linkend)'>
        <link linkend='{generate-id()}'>
          <xsl:choose>
            <xsl:when test='code-title'>
              <classname><xsl:value-of select='code-title'/></classname>
            </xsl:when>
            <xsl:otherwise>
              <classname><xsl:value-of select='@linkend'/></classname>
            </xsl:otherwise>
          </xsl:choose>
        </link>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <classname>
        <xsl:choose>
          <xsl:when test='@title'>
            <xsl:value-of select='@title'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select='@linkend'/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>: </xsl:text>
        <xsl:for-each select='key("code-fragment-key",@linkend)'>
          <link linkend='{generate-id ()}'><xsl:value-of select='position()'/></link>
          <xsl:if test='position() != last ()'>, </xsl:if>
        </xsl:for-each>
      </classname>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match='aots:test-font|aots:context-test-font'>
  <bridgehead>Test Font <xsl:value-of select='@id'/>:</bridgehead>

  <p><programlisting><xsl:apply-templates mode='code-fragment'/>
  <ulink url='{$fontdir}{@id}.otf'>Download it</ulink></programlisting></p>  
</xsl:template>


<xsl:template match='aots:cmap-test'>
  <bridgehead><anchor id='{@id}'/>cmap Testcase <xsl:value-of select='@id'/>:</bridgehead>

  <simplelist>
    <member>Font: <xsl:value-of select='@font'/></member>
    <member>PlatformID: <xsl:value-of select='@platformID'/></member>
    <member>EncodingID: <xsl:value-of select='@encodingID'/></member>
    <member>Inputs: <xsl:value-of select='@inputs'/></member>
    <member>Outputs: <xsl:value-of select='@outputs'/></member>
  </simplelist>
</xsl:template>

<xsl:template match='aots:cmap-uvs-test'>
  <bridgehead><anchor id='{@id}'/>cmap Testcase <xsl:value-of select='@id'/>:</bridgehead>

  <simplelist>
    <member>Font: <xsl:value-of select='@font'/></member>
    <member>Inputs: <xsl:value-of select='@inputs'/></member>
    <member>Outputs: <xsl:value-of select='@outputs'/></member>
  </simplelist>
</xsl:template>

<xsl:template match='aots:gsub-test'>
  <bridgehead><anchor id='{@id}'/>GSUB Testcase <xsl:value-of select='@id'/>:</bridgehead>

  <simplelist>
    <member>Font: <xsl:value-of select='@font'/></member>
    <member>Inputs: <xsl:value-of select='@inputs'/></member>
    <member>Outputs: <xsl:value-of select='@outputs'/></member>
<!--
    <member>Trace: <ulink url="{$tracedir}{@id}.svg">SVG</ulink>.</member> 
-->
  </simplelist>
</xsl:template>

<xsl:template match='aots:gpos-test'>
  <bridgehead><anchor id='{@id}'/>GPOS Testcase <xsl:value-of select='@id'/>:</bridgehead>

  <simplelist>
    <member>Font: <xsl:value-of select='@font'/></member>
    <member>Inputs: <xsl:value-of select='@inputs'/></member>
    <xsl:if test='test-case-attach'>
      <member>Attach: <xsl:value-of select='@attach'/></member>
    </xsl:if>
    <member>XDeltas: <xsl:value-of select='@xdeltas'/></member>
    <member>YDeltas: <xsl:value-of select='@ydeltas'/></member>
    <member>RefPos:  <xsl:value-of select='@refpos'/></member>
<!--
    <member>Trace: <ulink url="{$tracedir}{@id}.svg">SVG</ulink>.</member> 
-->
  </simplelist>
</xsl:template>

<xsl:template match='aots:context-test'>
  <bridgehead><anchor id='{@id}'/>GPOS/GSUB Testcase <xsl:value-of select='@id'/>:</bridgehead>

  <simplelist>
    <member>Font: <xsl:value-of select='@font'/></member>
    <member>Inputs: <xsl:value-of select='@inputs'/></member>
    <member>Outputs: <xsl:value-of select='@outputs'/></member>
    <xsl:if test='test-case-attach'>
      <member>Attach: <xsl:value-of select='@attach'/></member>
    </xsl:if>
    <member>XDeltas: <xsl:value-of select='@xdeltas'/></member>
    <member>YDeltas: <xsl:value-of select='@ydeltas'/></member>
    <member>RefPos:  <xsl:value-of select='@refpos'/></member>
<!--
    <member>Trace: <ulink url="{$tracedir}{@id}.svg">SVG</ulink>.</member> 
-->
  </simplelist>
</xsl:template>


<xsl:template match='otformat|ots:format'>
  <table>
    <xsl:for-each select='title'>
      <xsl:copy>
        <xsl:apply-templates select='@* | node()'/>
      </xsl:copy>
    </xsl:for-each>
    <tgroup cols='4' role='otformat'>
      <thead>
	<row>
	  <entry>Type</entry>
	  <entry>Name</entry>
	  <entry>Description</entry>
	</row>
      </thead>
      <tbody>
        <xsl:for-each select='otfield|ots:field'>
          <row>
            <xsl:apply-templates/>
          </row>
        </xsl:for-each>
      </tbody>
    </tgroup>
  </table>
</xsl:template>
     
<xsl:template match='otfieldoffs'>
</xsl:template>

<xsl:template match='otfieldtype|otfieldname|otfielddesc|ots:type|ots:name|ots:desc'>
  <entry><xsl:apply-templates/></entry>
</xsl:template>



<xsl:template match='otexample|ots:example'>
  <table>
    <xsl:for-each select='title'>
      <xsl:copy>
        <xsl:apply-templates select='@* | node()'/>
      </xsl:copy>
    </xsl:for-each>
    <tgroup cols='3' role='otexample'>
      <thead>
	<row>
          <entry>HexData</entry>
	  <entry>Source</entry>
	  <entry>Comment</entry>
	</row>
      </thead>
      <tbody>
        <xsl:for-each select='otexline|ots:exline'>
          <row>
            <xsl:apply-templates/>
          </row>
        </xsl:for-each>
      </tbody>
    </tgroup>
  </table>
</xsl:template>
     

<xsl:template match='otexdata|otexsrc|otexcom|ots:exdata|ots:exsrc|ots:excom'>
  <entry><xsl:apply-templates/></entry>
</xsl:template>




<xsl:template match='ottable|ots:table'>
  <link>
    <xsl:attribute name='linkend'>
      <xsl:text>chapter.</xsl:text>
      <xsl:choose>
        <xsl:when test='. = "OS/2"'>
          <xsl:text>OS2</xsl:text>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select='.'/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select='.'/>
  </link>
</xsl:template>


<xsl:template match='@* | node()'>
  <xsl:copy>
    <xsl:apply-templates select='@* | node()'/>
  </xsl:copy>
</xsl:template>


<xsl:template match='*' mode='code-fragment'>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select='local-name()'/>
  <xsl:apply-templates select='@*' mode='code-fragment'/>
  <xsl:choose>
    <xsl:when test='node()'>
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates select='node()' mode='code-fragment'/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select='local-name()'/>
      <xsl:text>&gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>/></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match='@*' mode='code-fragment'>
  <xsl:text> </xsl:text>
  <xsl:value-of select='local-name()'/>
  <xsl:text>='</xsl:text>
  <xsl:value-of select='.'/>
  <xsl:text>'</xsl:text>
</xsl:template>

<xsl:template match='text()' mode='code-fragment'>
  <xsl:value-of select='.'/>
</xsl:template>

</xsl:stylesheet>
