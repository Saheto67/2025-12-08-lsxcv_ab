<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:graph="urn:test:irm:svg:circular" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="math fn graph">
	<xsl:output method="xml" version="1.0" encoding="UTF-8"/>
	<xsl:param name="rayon" select="100"/>
	<xsl:param name="maxValue" select="80"/>
	<xsl:template match="/" priority="0.3">
		<xsl:call-template name="svgCircularGraph"/>
	</xsl:template>
	<xsl:variable name="degToRad" select="math:pi() div 180"/>
	<xsl:output method="xml" version="1.0" media-type="text/svg" indent="yes"/>
	<xsl:template name="svgCircularGraph">
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="-{$rayon+20} -{$rayon+20} {2*($rayon+20)} {2*($rayon+20)}" width="100%" height="100%">
			<desc>
				<!-- put a description here -->
			</desc>
			<xsl:variable name="points">
				<xsl:call-template name="points"/>
			</xsl:variable>
			<polygon stroke-width="0.2" stroke="black" fill="#34eb89" points="{$points}" opacity="0.3"/>
			<g>
				<circle r="{$rayon}" cx="0" cy="0" stroke="black" fill="none"/>
				<circle r="{$rayon div 2}" cx="0" cy="0" stroke="black" stroke-width="0.3" stroke-dasharray="5 5" fill="none"/>
				<!-- your graphic here -->
				<xsl:apply-templates select="//value" mode="lines"/>
			</g>
		</svg>
	</xsl:template>
	<xsl:template match="value" mode="lines">
		<xsl:variable name="angleRad" select="angle*$degToRad"/>
		<xsl:variable name="sin" select="math:sin($angleRad)"/>
		<xsl:variable name="cos" select="math:cos($angleRad)"/>
		<line x1="{0}" y1="{0}" x2="{$sin*$rayon}" y2="{-$cos*$rayon}" stroke="grey" stroke-width="1"/>
		<text x="{$sin*($rayon + 12)}" y="{-$cos*($rayon + 10)}" text-anchor="middle" alignment-baseline="middle" font-weight="900" font-size="10"><xsl:value-of select="./angle"/>°</text>
	</xsl:template>
	<xsl:template name="points">
		<xsl:param name="lastValue" select="''"/>
		<xsl:param name="currentnode" select="/test/value[1]"/>
		<xsl:choose>
			<xsl:when test="$currentnode/following-sibling::value">
				<xsl:call-template name="points">
					<xsl:with-param name="currentnode" select="$currentnode/following-sibling::value[1]"/>
					<xsl:with-param name="lastValue" select="fn:concat($lastValue,fn:concat(' ',graph:calculatePointBR($currentnode)))"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="fn:concat($lastValue,fn:concat(' ',graph:calculatePointBR($currentnode)))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:function name="graph:calculatePointBR">
		<xsl:param name="value"/>
		<xsl:variable name="angleRad" select="$value/angle*$degToRad"/>
		<xsl:variable name="x1" select="math:sin($angleRad)*(($rayon div 2)*($value/br div $maxValue) +($rayon div 2))"/>
		<xsl:variable name="y1" select="- math:cos($angleRad)*(($rayon div 2)*($value/br div $maxValue)+($rayon div 2))"/>
		<xsl:value-of select="fn:concat($x1,fn:concat(',',$y1))"/>
	</xsl:function>
</xsl:stylesheet>