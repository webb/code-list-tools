<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
   exclude-result-prefixes="t xs xsl"
   version="2.0"
   xmlns:t="http://wr.gatech.edu/namespace/table/"
   xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   >

  <xsl:output method="xml" version="1.0" indent="yes" encoding="US-ASCII"/>

  <xsl:param name="code-list" as="document-node()"/>
  <xsl:param name="empty-text" as="xs:string" select="''"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="SimpleCodeList" priority="1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:choose>
        <xsl:when test="exists($code-list)">
          <xsl:apply-templates select="$code-list"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">Variable code-list is not set</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="t:table/text()" priority="1"/>
  <xsl:template match="t:row/text()" priority="1"/>
  <xsl:template match="gc:CodeList/text()" priority="1"/>
  <xsl:template match="gc:CodeList//Identification/text()" priority="1"/>
  <xsl:template match="gc:CodeList//SimpleCodeList/text()" priority="1"/>
  <xsl:template match="gc:CodeList//ColumnSet/text()" priority="1"/>
  <xsl:template match="gc:CodeList//Column/text()" priority="1"/>
  <xsl:template match="gc:CodeList//Data/text()" priority="1"/>
  <xsl:template match="gc:CodeList//ColumnRef/text()" priority="1"/>
  <xsl:template match="gc:CodeList//KeyRef/text()" priority="1"/>
  <xsl:template match="gc:CodeList//Key/text()" priority="1"/>

  <xsl:template match="t:table">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="t:row[position() = 1]" priority="2"/>

  <xsl:template match="t:row" priority="1">
    <Row>
      <xsl:apply-templates/>
    </Row>
  </xsl:template>

  <xsl:template match="t:column" priority="1">
    <Value>
      <SimpleValue><xsl:value-of select="."/></SimpleValue>
    </Value>
  </xsl:template>

</xsl:stylesheet>
<!--
    Local Variables:
    mode: sgml
    indent-tabs-mode: nil
    fill-column: 9999
    End:
  -->
