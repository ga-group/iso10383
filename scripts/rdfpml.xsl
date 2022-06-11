<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="//ColumnSet">
    <xsl:apply-templates/>
    <xsl:text>&#0010;</xsl:text>
  </xsl:template>

  <xsl:template match="Column[position()=1]">
    <xsl:value-of select="ShortName"/>
  </xsl:template>
  <xsl:template match="Column[position()>1]">
    <xsl:text>&#0009;</xsl:text>
    <xsl:value-of select="ShortName"/>
  </xsl:template>

  <xsl:template match="//SimpleCodeList">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="Row">
    <xsl:apply-templates/>
    <xsl:text>&#0010;</xsl:text>
  </xsl:template>

  <xsl:template match="Value[position()=1]">
    <xsl:value-of select="SimpleValue"/>
  </xsl:template>
  <xsl:template match="Value[position()>1]">
    <xsl:text>&#0009;</xsl:text>
    <xsl:value-of select="SimpleValue"/>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:stylesheet>
