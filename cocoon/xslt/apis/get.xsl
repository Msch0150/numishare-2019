<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:nm="http://nomisma.org/id/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:nuds="http://nomisma.org/nuds" xmlns:nh="http://nomisma.org/nudsHoard"
	xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">
	<xsl:include href="../geographic/templates.xsl"/>
	<xsl:include href="../linked_data/templates.xsl"/>
	<xsl:include href="../functions.xsl"/>

	<!-- url params -->
	<xsl:param name="id"/>
	<xsl:param name="format"/>
	<xsl:param name="mode"/>
	<xsl:param name="lang"/>

	<!-- config variables -->
	<xsl:variable name="url" select="/content/config/url"/>
	<xsl:variable name="geonames_api_key" select="/content/config/geonames_api_key"/>
	<xsl:variable name="sparql_endpoint" select="/content/config/sparql_endpoint"/>
	<xsl:variable name="geonames-url">
		<xsl:text>http://api.geonames.org</xsl:text>
	</xsl:variable>

	<!-- data aggregation -->
	<xsl:variable name="nudsGroup" as="element()*">
		<xsl:if test="$format='kml' or $format='json' or ($format='rdf' and $mode='pelagios')">
			<nudsGroup>
				<xsl:variable name="id-param">
					<xsl:for-each select="distinct-values(descendant::nuds:typeDesc[contains(@xlink:href, 'nomisma.org')]/@xlink:href)">
						<xsl:value-of select="substring-after(., 'id/')"/>
						<xsl:if test="not(position()=last())">
							<xsl:text>|</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<xsl:if test="string-length($id-param) &gt; 0">
					<xsl:for-each select="document(concat('http://nomisma.org/apis/getNuds?identifiers=', $id-param))//nuds:nuds">
						<object xlink:href="http://nomisma.org/id/{nuds:control/nuds:recordId}">
							<xsl:copy-of select="."/>
						</object>
					</xsl:for-each>
				</xsl:if>

				<!-- incorporate other typeDescs which do not point to nomisma.org -->
				<xsl:for-each select="descendant::nuds:typeDesc[not(contains(@xlink:href, 'nomisma.org'))]">
					<xsl:choose>
						<xsl:when test="string(@xlink:href)">
							<xsl:if test="boolean(document(concat(@xlink:href, '.xml')))">
								<object xlink:href="{@xlink:href}">
									<xsl:copy-of select="document(concat(@xlink:href, '.xml'))/nuds:nuds"/>
								</object>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<object>
								<xsl:copy-of select="."/>
							</object>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</nudsGroup>
		</xsl:if>
	</xsl:variable>

	<!-- get non-coin-type RDF in the document -->
	<xsl:variable name="rdf" as="element()*">
		<xsl:if test="$format='kml' or $format='json' or ($format='rdf' and $mode='pelagios')">
			<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:nm="http://nomisma.org/id/"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfa="http://www.w3.org/ns/rdfa#"
				xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
				<xsl:variable name="id-param">
					<xsl:for-each
						select="distinct-values(descendant::*[not(local-name()='typeDesc') and not(local-name()='reference')][contains(@xlink:href, 'nomisma.org')]/@xlink:href|exsl:node-set($nudsGroup)/descendant::*[not(local-name()='object') and not(local-name()='typeDesc')][contains(@xlink:href, 'nomisma.org')]/@xlink:href)">
						<xsl:value-of select="substring-after(., 'id/')"/>
						<xsl:if test="not(position()=last())">
							<xsl:text>|</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="rdf_url" select="concat('http://nomisma.org/apis/getRdf?identifiers=', $id-param)"/>
				<xsl:copy-of select="document($rdf_url)/rdf:RDF/*"/>
			</rdf:RDF>
		</xsl:if>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/content/*[not(local-name()='config')]" mode="root"/>
	</xsl:template>

	<xsl:template match="*" mode="root">
		<xsl:choose>
			<xsl:when test="$format='xml'">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:when test="$format='kml'">
				<xsl:call-template name="kml"/>
			</xsl:when>
			<xsl:when test="$format='json'">
				<xsl:call-template name="json"/>
			</xsl:when>
			<xsl:when test="$format='rdf'">
				<xsl:call-template name="rdf"/>
			</xsl:when>
			<xsl:otherwise>
				<error>test</error>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
