<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="version"/>

<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>


<xsl:template match="string[. = 'selected']">
	<string>
	<xsl:choose>
		<xsl:when test="preceding-sibling::string[. = 'entropy-php.pkg']">required</xsl:when>
		<xsl:when test="preceding-sibling::string[. = 'entropy-php-extension-pdflib_commercial.pkg']">unselected</xsl:when>
		<xsl:otherwise>selected</xsl:otherwise>
	</xsl:choose>
	</string>
</xsl:template>


</xsl:stylesheet>