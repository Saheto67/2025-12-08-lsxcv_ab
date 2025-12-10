<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:factureFunc="urn:orsys:lsx:function:facture">
	<xsl:include href="toStatistiqueXML.xslt"/>
	<xsl:variable name="allStotligne">
		<alltot>
			<xsl:copy-of select="//stotligne"/>
		</alltot>
	</xsl:variable>
	<xsl:variable name="sommeAllTot">
		<xsl:call-template name="somme-arrondi">
			<xsl:with-param name="current" select="$allStotligne//stotligne[1]"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:template name="somme-arrondi">
		<xsl:param name="somme" select="0"/>
		<xsl:param name="current"/>
		<xsl:choose>
			<xsl:when test="$current/following-sibling::*">
				<xsl:call-template name="somme-arrondi">
					<xsl:with-param name="somme" select="$somme+number(format-number($current,'0.00'))"/>
					<xsl:with-param name="current" select="$current/following-sibling::*[1]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$somme+number(format-number($current,'0.00'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="factures" mode="html-files">
		<xsl:result-document href="synthese.html" method="html" encoding="utf-8" indent="yes">
			<html>
				<head>
					<title/>
				</head>
				<body>
					<table>
						<tbody>
							<tr>
								<th colspan="5">totaux de toutes les factures</th>
							</tr>
							<xsl:call-template name="totaux">
								<xsl:with-param name="nodes" select="//facture[contains(@type,'acture')]"/>
							</xsl:call-template>
							<tr>
								<th colspan="5">totaux de touts les devis</th>
							</tr>
							<xsl:call-template name="totaux">
								<xsl:with-param name="nodes" select="//facture[contains(@type,'evis')]"/>
							</xsl:call-template>
							<tr>
								<th colspan="5">totaux de tout</th>
							</tr>
							<xsl:call-template name="totaux"/>
						</tbody>
					</table>
				</body>
			</html>
		</xsl:result-document>
		<xsl:result-document href="factures.html" method="html" encoding="utf-8" indent="yes">
			<html>
				<head>
					<title/>
					<style type="text/css">
					/*style css*/
					@media print{
						.facture{
							page-break-before:always;
							height:27cm;
						}
						.bloc-adresse{
							border:none;
							height:4cm;
						}
					}
					.facture{
						width:20cm;
						/*border:1px solid black;*/
					}
					.bloc-adresse{
						border:1px solid black;
						width:6cm;
					}
					.emeteur{}
					.client{
						margin-left:14cm;
					}
					.numerofacture{
						border:1px solid black;
						background-color:#ACACAC;
						text-align:center;
						margin:2cm 4cm;
						padding:0.3cm;
						font-weight:900;
						font-size:large;
					}
					.table-container{
						padding:0 1cm;
					}
					table{
						width:100%;
						border-spacing: 0;
						border-collapse: collapse;
					}
					table td, table th{
						border:1px solid black;
					}
					table thead{
						background-color:#AFAFAF;
					}
					.no-border{
						border:none ;
						text-align:right ;
					}
				</style>
				</head>
				<body>
					<xsl:apply-templates select="//facture" mode="#current"/>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="factures" mode="xml-files">
		<xsl:result-document href="stat.xml" method="xml" version="1.0" indent="yes">
			<xsl:apply-templates select="."/>
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="/">
		<xsl:apply-templates select="/factures" mode="html-files"/>
		<xsl:apply-templates select="/factures" mode="xml-files"/>
	</xsl:template>
	<xsl:template match="facture" mode="html-files">
		<div class="facture">
			<xsl:call-template name="emeteur"/>
			<xsl:apply-templates select="@idclient"/>
			<div class="numerofacture">numero facture</div>
			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>REF</th>
							<th>designation</th>
							<th>€/unit.</th>
							<th>quant.</th>
							<th>Total</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select=".//ligne" mode="#current"/>
						<xsl:call-template name="totaux"/>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="emeteur">
		<div class="emeteur bloc-adresse">
			<xsl:value-of select="/factures/@rsets"/>
			<br/>
			<xsl:value-of select="/factures/@adr1ets"/>
			<br/>
			<xsl:if test="string-length(/factures/@adr2ets)>0">
				<xsl:value-of select="/factures/@adr2ets"/>
				<br/>
			</xsl:if>
			<xsl:value-of select="/factures/@cpets"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="/factures/@villeets"/>
		</div>
	</xsl:template>
	<xsl:template match="@idclient">
		<xsl:variable name="idc" select="."/>
		<xsl:variable name="docClient" select="document('clients.xml')/clients/client[@id=$idc]"/>
		
			<xsl:apply-templates select="$docClient"/>
	
	</xsl:template>
	<xsl:template match="clients/client">
		<div class="client bloc-adresse">
			<xsl:value-of select="destinataire"/><br/>
			<xsl:value-of select="adr1"/><br/>
			<xsl:if test="string-length(adr2)>0">
				<xsl:value-of select="adr2"/><br/>
			</xsl:if>
			<xsl:value-of select="cp"/><xsl:text> </xsl:text>
			<xsl:value-of select="ville"/>
		</div>
	</xsl:template>
	<xsl:template match="ligne" mode="html-files">
		<tr>
			<xsl:apply-templates select="*[name()!='surface']"/>
			<!--<xsl:apply-templates select="nbUnit|ref|designation"/>-->
		</tr>
	</xsl:template>
	<xsl:decimal-format name="eur-currency" grouping-separator=" " decimal-separator=","/>
	<!--
l'un ou lautre (filtrage par nom de balise dans une position) ou (pipe sur no de balise ATTENTION aux priorités de match)
<xsl:template match="ligne/*[name()='stotligne' or name()='phtByUnit']" priority="1">-->
	<xsl:template match="stotligne | phtByUnit" priority="1">
		<td>
			<xsl:value-of select="format-number(.,'0,00', 'eur-currency')"/>€
		</td>
	</xsl:template>
	<xsl:template match="ligne/*">
		<td>
			<xsl:value-of select="."/>
		</td>
	</xsl:template>
	<xsl:function name="factureFunc:somme-arrondi-stotligne">
		<xsl:param name="somme"/>
		<xsl:param name="current"/>
		<xsl:choose>
			<xsl:when test="$current/following-sibling::ligne">
				<xsl:value-of select="factureFunc:somme-arrondi-stotligne($somme+number(format-number($current/stotligne[1],'0.00')),$current/following-sibling::ligne[1])"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$somme+number(format-number($current/stotligne,'0.00'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:template name="totaux">
		<xsl:param name="nodes" select="."/>
		<xsl:variable name="listStotLigne">
			<totaux>
				<xsl:copy-of select="$nodes//ligne"/>
			</totaux>
		</xsl:variable>
		<xsl:variable name="totalHT" select="factureFunc:somme-arrondi-stotligne(0,$listStotLigne//ligne[1])"/>
		<!--<xsl:variable name="totalHT" select="sum($nodes//stotligne)"/>-->
		<xsl:variable name="totalTVA" select="number(format-number($totalHT*0.2,'0.00'))"/>
		<tr>
			<td class="no-border" colspan="4">Montant total HT :</td>
			<th>
				<xsl:value-of select="format-number($totalHT,'0,00€','eur-currency')"/>
			</th>
		</tr>
		<tr>
			<td class="no-border" colspan="4">Montant TVA 20% :</td>
			<th>
				<xsl:value-of select="format-number($totalTVA,'0,00€','eur-currency')"/>
			</th>
		</tr>
		<tr>
			<td class="no-border" colspan="4">Montant total TTC :</td>
			<th>
				<xsl:value-of select="format-number($totalHT+$totalTVA,'0,00€','eur-currency')"/>
			</th>
		</tr>
	</xsl:template>
</xsl:stylesheet>