<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" indent="yes" encoding="utf-8"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>Enter your title here</title>
				<style>
					table td{border:1px solid black;}
					table thead tr{background-color:#CCCCCC;}
					table{
						border-spacing: 0;
						border-collapse: collapse;
						border:1px solid black;
					}
				</style>
			</head>
			<body>
				<h1>tableau des factures</h1>
				<table>
					<thead>
						<tr>
							<td>type</td>
							<td>numero facture</td>
							<td>id client</td>
							<td>nombre d'article</td>
							<td>nombre de lignes</td>
							<td>montant total</td>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="//facture">
							<xsl:sort select="translate(@type,'df','DF')"/>
							<xsl:sort select="@numfacture"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="facture">
		<tr>
			<td>
				<xsl:value-of select="translate(@type,'df','DF')"/>
			</td>
			<td>
				<xsl:value-of select="@numfacture"/>
			</td>
			<td>
				<xsl:value-of select="@idclient"/>
			</td>
			<td>
				<xsl:value-of select="sum(.//nbUnit)"/>
			</td>
			<td>
				<xsl:value-of select="count(.//ligne)"/>
			</td>
			<td>
				<xsl:value-of select="format-number(sum(.//stotligne),'0.00€')"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>