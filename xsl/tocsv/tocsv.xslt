<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="/">type;numero facture;idclient;totalHT<xsl:apply-templates select="//facture">
		<xsl:sort select="translate(@type,'df','DF')"/>
		<xsl:sort select="@numfacture"/>
	</xsl:apply-templates></xsl:template>
	<xsl:template match="facture">
		<xsl:text>
</xsl:text>
		<xsl:value-of select="translate(@type,'df','DF')"/>
		<xsl:value-of select="concat(';',@numfacture)"/>
		<xsl:text>;</xsl:text>
		<xsl:value-of select="@idclient"/>;<xsl:value-of select="sum(.//stotligne)"/>
	</xsl:template>
</xsl:stylesheet>
