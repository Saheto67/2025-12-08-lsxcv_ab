<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<facturation dateTransfert="2025-12-09" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="file:///G:/partage/2025-12-08-lsxcv/xsl/facturationStatCode/facturationtransfert.xsd">
			<statFile>
				<facturesStat>
					<avgNbUnitFacture refproduits="a">
						<xsl:value-of select="sum(//nbUnit) div count(//nbUnit)"/>
					</avgNbUnitFacture>
					<ligneAvgFact>
						<xsl:value-of select="sum(//stotligne) div count(//stotligne)"/>
					</ligneAvgFact>
					<nbLignesFact>
						<xsl:value-of select="count(//ligne)"/>
					</nbLignesFact>
				</facturesStat>
			</statFile>
			<factures>
				<xsl:apply-templates select="//facture"/>
			</factures>
		</facturation>
	</xsl:template>
	<xsl:template match="facture[contains(@type,'evis')]" priority="1.1">
		<!--echapement des devis-->
		<xsl:comment>devis non pris en compte</xsl:comment>
	</xsl:template>
	<xsl:template match="/factures/facture">
		<facture idfacture="" nomClient="">
			<prixAvgArticle refproduits="a">
				<xsl:value-of select="sum(.//phtByUnit) div count(.//phtByUnit)"/>
			</prixAvgArticle>
			<ligneAvg>
				<xsl:value-of select="sum(.//stotligne) div count(.//stotligne)"/>
			</ligneAvg>
			<nbLignes>
				<xsl:value-of select="count(.//ligne)"/>
			</nbLignes>
		</facture>
	</xsl:template>
</xsl:stylesheet>