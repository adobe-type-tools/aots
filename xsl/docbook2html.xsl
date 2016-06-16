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
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0">

<xsl:output
  method="xhtml"
  omit-xml-declaration='yes'
  indent="no"
  doctype-public='-//W3C//DTD XHTML 1.0 Transitional//EN'
  doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'
  encoding="UTF-8"/>


<xsl:param name='targetdir'>.</xsl:param>
<xsl:param name='imagedir'>.</xsl:param>

<xsl:preserve-space elements='programlisting'/>


<xsl:template match='/'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name='htmlPage'>
  <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
      <title><xsl:value-of select="title"/></title>
    </head>

    <body bgcolor="#ffffff">

	<p>Copyright 2000-2016 Adobe Systems Incorporated. All Rights Reserved.</p>
	<p>Licensed under the Apache License, Version 2.0 (the "License");
	you may not use these files except in compliance with the License.
	You may obtain a copy of the License at<br/>
	http://www.apache.org/licenses/LICENSE-2.0<br/>
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.</p>

      <xsl:if test='section|sect1|chapter'>
        <center><h2><xsl:value-of select='title'/></h2></center>
      </xsl:if>

      <xsl:if test='abstract'>
        <h3>Abstract</h3>
        <xsl:apply-templates select='abstract'/>
      </xsl:if>

      <xsl:if test="section|sect1|chapter">
        <h3>Table of Content</h3>
        <xsl:call-template name="toc"/>
      </xsl:if>

      <xsl:if test="articleinfo">
        <p><a href="#dd">Document History</a></p>
      </xsl:if>

      <xsl:apply-templates select='*[not (self::abstract)]'/>

      <xsl:apply-templates select='articleinfo' mode='bottom'/>

      <p><font size="-1">Copyright
      <xsl:choose>
        <xsl:when test='articleinfo/copyright/year'>
          <xsl:value-of select='articleinfo/copyright/year'/>
        </xsl:when>
        <xsl:otherwise>2000-2016</xsl:otherwise>
      </xsl:choose>
      Adobe Systems Incorporated</font></p>

    </body>
  </html>
</xsl:template>





<xsl:template match='article'>
   <xsl:call-template name='htmlPage'/>
</xsl:template>


<xsl:template match='section'>
  <a>
    <xsl:attribute name='name'>
      <xsl:choose>
        <xsl:when test='@id'>
          <xsl:value-of select='@id'/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number level='multiple' count='section|chapter' format='1.1'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </a>
  <h3>
    <xsl:number level='multiple' count='section|chapter' format='1.1. '/>
    <xsl:value-of select='title'/>
  </h3>

  <xsl:if test='@id'>
    <a name='{@id}'/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='sect1'>
  <a><h3 align='center'><xsl:value-of select='title'/></h3></a>
  <xsl:if test='@id'>
    <a name='{@id}'/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name='select_id'>
  <xsl:choose>
    <xsl:when test='@id'>
      <xsl:value-of select='@id'/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='generate-id()'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name='infile'>
</xsl:template>


<xsl:template name="toc">
  <xsl:param name='depth'>1</xsl:param>

  <table cellspacing="0" cellpadding="0" border="0">
    <xsl:for-each select='section|sect1'>
      <tr>
        <td>
	  <xsl:if test='self::section'>
	    <xsl:number level='multiple' count='section' format='1.1. '/>
	  </xsl:if>
        </td>
        <td>
          &#160;<a>
            <xsl:attribute name='href'>
                <xsl:text>#</xsl:text>
                <xsl:choose>
                  <xsl:when test='@id'>
                    <xsl:value-of select='@id'/>
		  </xsl:when>
		  <xsl:otherwise>
                    <xsl:number level='multiple' count='section' format='1.1'/>
		  </xsl:otherwise>
		</xsl:choose>
            </xsl:attribute>
            <xsl:value-of select='title'/>
          </a>
        </td>
	<xsl:if test='self::sect1'>
	  <td>
	    <xsl:text>&#x00A0;&#x00A0;&#x00A7;</xsl:text>
	    <xsl:apply-templates select='sect2[1]' mode='count'/>
	    <xsl:text> &#x2013; &#x00A7;</xsl:text>
	    <xsl:apply-templates select='sect2[position()=last()]' mode='count'/>
	  </td>
        </xsl:if>
      </tr>

      <xsl:if test="self::section">
        <xsl:if test='$depth &lt; 2 and section'>
          <tr>
            <td>&#160;</td>
            <td>
              <xsl:call-template name='toc'>
                <xsl:with-param name='depth'><xsl:value-of select='$depth+1'/></xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>

    </xsl:for-each>
  </table>
</xsl:template>



<xsl:template match="articleinfo">
</xsl:template>

<xsl:template match="author">
  <xsl:apply-templates select="firstname"/>
  <xsl:text>&#160;</xsl:text>
  <xsl:apply-templates select="surname"/>
</xsl:template>

<xsl:template match="articleinfo" mode="bottom">
  <hr/>
  <a name="dd"/>
  <h3>Document History</h3>
  <p>Author<xsl:if test='count(author) > 1'>s</xsl:if><xsl:text>:</xsl:text>
     <xsl:for-each select='author'>
       <xsl:if test='position() != 1'>, </xsl:if>
       <xsl:apply-templates/>
     </xsl:for-each></p>
  <xsl:apply-templates select="revhistory"/>
</xsl:template>

<xsl:template match="revhistory">
  <table cellspacing="4" cellpadding="0" border="0">
    <tr>
      <td>Revision</td>
      <td>Date</td>
      <td>Comments</td>
    </tr>
    <xsl:for-each select="revision">
      <tr>
        <td valign="top"><ulink><xsl:attribute name="url">../v<xsl:value-of select="revnumber"/></xsl:attribute><xsl:apply-templates select="revnumber"/></ulink></td>
        <td valign="top"><xsl:apply-templates select="date"/></td>
        <td valign="top">
	  <xsl:choose>
	    <xsl:when test='revremark'>
	      <p><xsl:apply-templates select="revremark"/></p>
	    </xsl:when>
	    <xsl:when test='revdescription'>
	      <xsl:apply-templates select="revdescription"/>
	    </xsl:when>
	  </xsl:choose>
	</td>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match='revdescription'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="title">
</xsl:template>

<xsl:template match='abstract'>
  <blockquote>
  <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match='note[@role="open"]'>
  <p>
    <table cellspacing="4" border="0" cellpadding="0">
      <tr>
        <td valign="top"><i><u><font color="red">Open:</font></u></i></td>
        <td valign="top"><i><xsl:apply-templates/></i></td>
      </tr>
    </table>
  </p>
</xsl:template>

<xsl:template match='note'>
  <blockquote>
    Note: <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<xsl:template match='bridgehead'>
  <a name='{@id}'><h4><xsl:apply-templates/></h4></a>
</xsl:template>


<xsl:template match='sect2' mode='count'>
  <xsl:number level='any' from='/' count='sect2' format='1'/>
</xsl:template>

<xsl:template match='para'>
  <p>
    <xsl:if test='parent::sect2/descendant::para[1]=.'>
      <b>&#x00A7;<xsl:number level='any' from='/' count='sect2' format='1.'/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select='parent::sect2/descendant::title'/></b>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test='@xml:lang'>
        <font>
          <xsl:attribute name='face'>
            <xsl:choose>
              <xsl:when test='@xml:lang="x-ipa"'>SILDoulosUnicodeIPA</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <xsl:apply-templates/>
        </font>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </p>
</xsl:template>

<xsl:template match='table'>
  <i><xsl:value-of select='title'/></i><br/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='figure'>
  <center>
    <table cellpadding="10" bgcolor="#f0f0f0">
      <tr><td align="center"><xsl:apply-templates/></td></tr>
    </table><br/>
    <i><xsl:value-of select='title'/></i>
  </center>
</xsl:template>

<xsl:template match='informalfigure'>
  <center><xsl:apply-templates/></center>
</xsl:template>

<xsl:template match='screenshot|mediaobject|imageobject'>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match='imagedata[@format="SVG"] | inlinegraphic[@format="SVG"]'>
  <script language="JavaScript">
    <xsl:comment>
      emitSVG('src="<xsl:value-of select="@fileref"/>" width="<xsl:value-of select='@width'/>" height="<xsl:value-of select='@height'/>" type="image/svg-xml"');
    // </xsl:comment>
  </script>
  <noscript>
    <embed src="{@fileref}" width="{@width}" height="{@height}" type="image/svg-xml" pluginspage="http://www.adobe.com/svg/viewer/install/">
      <xsl:if test='@name'>
        <xsl:attribute name='name'><xsl:value-of select='@name'/></xsl:attribute>
      </xsl:if>
    </embed>
  </noscript>
</xsl:template>

<xsl:template match='imagedata'>
      <xsl:choose>
        <xsl:when test='starts-with(@fileref,"http:")'>
          <img src='{@fileref}'/>
        </xsl:when>
        <xsl:otherwise>
          <img src='{$imagedir}/{@fileref}'/>
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

<xsl:template match='itemizedlist'>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match='orderedlist'>
  <ol>
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match='listitem'>
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match='para//listitem/para'>
  <div><xsl:apply-templates/></div>
</xsl:template>


<xsl:template match='simplelist'>
  <div style="margin-left: 10pt">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match='member'>
  <xsl:apply-templates/><BR/>
</xsl:template>

<xsl:template match='emphasis'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='firstterm'>
  <i><font color="red"><xsl:apply-templates/></font></i>
</xsl:template>

<xsl:template match='term'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='ulink'>
  <a href='{@url}'>
    <xsl:if test='@type="newwindow"'>
      <xsl:attribute name='target'>_blank</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test='text()'>
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select='@url'/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>




<xsl:key name='link-key' match='*[@id]'  use='@id'/>

<xsl:template match='link'>
  <xsl:variable name='infile'>
    <xsl:for-each select='key("link-key",@linkend)'>
      <xsl:call-template name='infile'/>
    </xsl:for-each>
  </xsl:variable>
  <a href='{$infile}#{@linkend}'><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match='anchor'>
  <a name='{@id}'/>
</xsl:template>




<xsl:template match='citetitle'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='userinput'>
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match='guimenuitem|guibutton|guilabel|filename'>
  <tt><i><xsl:apply-templates/></i></tt>
</xsl:template>

<xsl:template match='caution'>
  <blockquote><HR/><I><B><FONT COLOR="red">Editor's note</FONT></B><xsl:apply-templates/></I><HR/></blockquote>
</xsl:template>



<xsl:template match='blockquote'>
  <blockquote><xsl:apply-templates/></blockquote>
</xsl:template>

<xsl:template match='quote'>
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match='address'>
  <xsl:apply-templates select='firstname'/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select='surname'/>
  <br />
  <a>
    <xsl:attribute name='href'>
      <xsl:text>mailto:</xsl:text>
      <xsl:value-of select='email'/>
    </xsl:attribute>
    <xsl:apply-templates select='email'/></a>
  <br />
  <xsl:for-each select='street'>
    <xsl:apply-templates select='.'/> <br/>
  </xsl:for-each>

  <xsl:apply-templates select='city'/>
  <xsl:text>, </xsl:text>
  <xsl:apply-templates select='state'/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select='postcode'/>
</xsl:template>


<xsl:template match='inlinegraphic'>
  <img src='{@fileref}'/>
</xsl:template>




<xsl:template match='tgroup'>
  <table cellspacing="2" cellpadding="2" border="0">
    <xsl:apply-templates/>
  </table>
  <xsl:for-each select='.//footnote'>
    <xsl:number level='any' from='tgroup' format='a.'/>
    <xsl:apply-templates/>
  </xsl:for-each>
</xsl:template>

<xsl:template match='tgroup//footnote'>
  <sup><xsl:number level='any' from='tgroup' format='a'/></sup>
</xsl:template>

<xsl:template match='thead'>
  <thead><xsl:apply-templates/></thead>
</xsl:template>

<xsl:template match='tbody'>
  <tbody><xsl:apply-templates/></tbody>
</xsl:template>

<xsl:template match='row'>
  <tr><xsl:apply-templates/></tr>
</xsl:template>




<xsl:template name="colspec.colnum">
  <xsl:param name="colspec" select="."/>
  <xsl:choose>
    <xsl:when test="$colspec/@colnum">
      <xsl:value-of select="$colspec/@colnum"/>
    </xsl:when>
    <xsl:when test="$colspec/preceding-sibling::colspec">
      <xsl:variable name="prec.colspec.colnum">
        <xsl:call-template name="colspec.colnum">
          <xsl:with-param name="colspec"
                          select="$colspec/preceding-sibling::colspec[1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$prec.colspec.colnum + 1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="calculate.colspan">
  <xsl:param name="entry" select="."/>
  <xsl:variable name="namest" select="$entry/@namest"/>
  <xsl:variable name="nameend" select="$entry/@nameend"/>

  <xsl:variable name="scol">
    <xsl:call-template name="colspec.colnum">
      <xsl:with-param name="colspec"
                      select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ecol">
    <xsl:call-template name="colspec.colnum">
      <xsl:with-param name="colspec"
                      select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$ecol - $scol + 1"/>
</xsl:template>



<xsl:template match='entry'>
   <td valign='top'>
   <xsl:if test="@align">
     <xsl:attribute name="align">
       <xsl:value-of select="@align"/>
     </xsl:attribute>
   </xsl:if>
   <xsl:if test="@valign">
     <xsl:attribute name="valign">
       <xsl:value-of select="@valign"/>
     </xsl:attribute>
   </xsl:if>
    <xsl:if test="@namest">
      <xsl:attribute name="colspan">
        <xsl:call-template name="calculate.colspan"/>
      </xsl:attribute>
    </xsl:if>
   <xsl:if test="@morerows != '0'">
     <xsl:attribute name="rowspan">
       <xsl:value-of select="@morerows+1"/>
     </xsl:attribute>
   </xsl:if>
   <xsl:if test="ancestor::thead">
     <xsl:attribute name="bgcolor">#c0c0c0</xsl:attribute>
   </xsl:if>
   <xsl:if test="ancestor::tbody">
     <xsl:attribute name="bgcolor">#f0f0f0</xsl:attribute>
   </xsl:if>
   <xsl:choose>
     <xsl:when test='node()|text()'>
       <xsl:apply-templates/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:text>&#160;</xsl:text>
     </xsl:otherwise>
   </xsl:choose>
   </td>
</xsl:template>


<xsl:template match="literal">
  <tt><font color="blue"><xsl:apply-templates/></font></tt>
</xsl:template>



<xsl:template match='classname'>
  <i>[<xsl:apply-templates/>]</i>
</xsl:template>

<xsl:template match='literallayout/text()'>
  <xsl:call-template name='cr-replace'>
    <xsl:with-param name='text'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text'>
          <xsl:call-template name='sp-replace'>
            <xsl:with-param name='text' select='.'/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match='programlisting/text()'>
  <tt><xsl:call-template name='cr-replace'>
    <xsl:with-param name='text'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text'>
          <xsl:call-template name='sp-replace'>
            <xsl:with-param name='text'>
              <xsl:call-template name='tab-replace'>
                <xsl:with-param name='text' select='.'/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template></tt>
</xsl:template>

<xsl:template name='trim-cr'>
  <xsl:param name='text'/>
  <xsl:variable name="cr"><xsl:text>&#xa;</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test='starts-with($text,$cr) and position()=1'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text' select='substring($text,2)'/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test='substring($text,string-length($text))=$cr and position()=last()'>
      <xsl:call-template name='trim-cr'>
        <xsl:with-param name='text' select='substring($text,1,string-length($text)-1)'/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$text'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="cr-replace">
  <xsl:param name="text"/>
  <xsl:variable name="cr"><xsl:text>&#xa;</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($text,$cr)">
      <xsl:value-of select="substring-before($text,$cr)"/><br/><xsl:text>&#xa;</xsl:text>
      <xsl:call-template name="cr-replace">
        <xsl:with-param name="text" select="substring-after($text,$cr)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="sp-replace">
  <xsl:param name="text"/>
  <xsl:variable name="sp"><xsl:text> </xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($text,$sp)">
      <xsl:value-of select="substring-before($text,$sp)"/>
      <xsl:text>&#160;</xsl:text>
      <xsl:call-template name="sp-replace">
        <xsl:with-param name="text" select="substring-after($text,$sp)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tab-replace">
  <xsl:param name="text"/>
  <xsl:variable name="sp"><xsl:text>	</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($text,$sp)">
      <xsl:value-of select="substring-before($text,$sp)"/>
      <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
      <xsl:call-template name="tab-replace">
        <xsl:with-param name="text" select="substring-after($text,$sp)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match='doc-ref'>
  <xsl:variable name='id' select='@url'/>
  <xsl:variable name='xml'><xsl:value-of select='@url'/>.xml</xsl:variable>
  <a href='{@url}.html'><xsl:value-of select='document($xml,$id)/*/title'/></a><br/>
</xsl:template>


<xsl:template match='varname|function|sgmltag'>
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match='glosslist'>
  <div style='margin-left: 10pt'><dl><xsl:apply-templates/></dl></div>
</xsl:template>

<xsl:template match='glossterm'>
  <dt><xsl:apply-templates/></dt>
</xsl:template>

<xsl:template match='glossdef'>
  <dd><xsl:apply-templates/></dd>
</xsl:template>



<xsl:template match='superscript'>
  <sup><xsl:apply-templates/></sup>
</xsl:template>

<xsl:template match='subscript'>
  <sub><xsl:apply-templates/></sub>
</xsl:template>


<xsl:template match='annot'>
  <span style="text-decoration:underline"><xsl:apply-templates/></span>
    <xsl:text> </xsl:text>
    <xsl:number level='any' from='section' format='[1]'/>
</xsl:template>

<xsl:template match='annotref'>
  <xsl:for-each select='key("link-key",@target)'>
    <span style='background-color: #f0f0f0'>
      <xsl:number level='any' from='section' format='[1]'/>
    </span>
  </xsl:for-each>
</xsl:template>



<xsl:template match='person'>
  <p>  <xsl:number level='multiple' count='person' format='1'/>
<xsl:apply-templates/><hr/></p>
</xsl:template>

<xsl:template match='name'>
  <span lang='{@xml:lang}'>
    <font size='24'>
      <xsl:attribute name='face'>
        <xsl:choose>
          <xsl:when test='@xml:lang="gu"'>Shruti</xsl:when>
          <xsl:when test='@xml:lang="te"'>Gautami</xsl:when>
          <xsl:when test='@xml:lang="hi"'>Mangal</xsl:when>
          <xsl:when test='@xml:lang="jp"'>MS Mincho</xsl:when>
          <xsl:when test='@xml:lang="zh-tw"'>MingLiu</xsl:when>
          <xsl:when test='@xml:lang="zh-cn"'>SimSun</xsl:when>
          <xsl:otherwise>serif</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </font>
  </span>
  <br/>
</xsl:template>


<xsl:template name='tocp'>
  <xsl:param name='str'/>
  <xsl:value-of select='$str'/>
</xsl:template>


<xsl:template match='font'>
  <span style='font-family:{@name}; font-size={@size}'><xsl:apply-templates/></span>
</xsl:template>

</xsl:stylesheet>
