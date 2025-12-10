<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;"> 
	<!ENTITY euro "&#x20AC;"> 
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<xsl:apply-templates select="/factures"/>
	</xsl:template>
	<xsl:template match="factures">
		<facturation dateTransfert="2025-12-09" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="file:///G:/partage/2025-12-08-lsxcv/xsl/facturationStatCode/facturationtransfert.xsd">
			<statFile>
				<facturesStat>
					<avgNbUnitFacture>
						<xsl:attribute name="refproduits">
							<xsl:apply-templates select="//ligne"/>
						</xsl:attribute>
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
			<!--	<xsl:for-each select="//facture">
					<xsl:sort select="@numfacture"/>					
				</xsl:for-each>-->
				<xsl:apply-templates select="//facture">
					<xsl:sort select="@numfacture"/>					
				</xsl:apply-templates>
			</factures>
		</facturation>
	</xsl:template>
	<!--<xsl:template match="facture[contains(@type,'evis')]" priority="1.1">		-->
	<!--echapement des devis-->
	<!--		<xsl:comment>devis non pris en compte</xsl:comment>	</xsl:template>-->
	<xsl:template match="ligne">
		<xsl:if test="position()>1">&nbsp;</xsl:if>
		<!-- interdit les 2 if pour le meme test xsl:if test="position()=1"></xsl:if-->
		<xsl:value-of select="ref"/>
	</xsl:template>
	<xsl:template match="/factures/facture">
		<facture idfacture="{@numfacture}" nomClient="{@idclient}">
			<prixAvgArticle>
				<xsl:attribute name="refproduits">
					<xsl:apply-templates select=".//ligne"/>
				</xsl:attribute>
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