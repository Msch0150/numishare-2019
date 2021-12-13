<?xml version="1.0" encoding="UTF-8"?>

<!-- Author: Ethan Gruber
	Date last modified: March 2019
	Function: This is the first version of the Numishare distribution and metrical analysis interface. The Distribution interface is based on Solr facets. As of March 2019, 
	the metrical analysis interface has been migrated into a new system at visualize/metrical based on APIs that deliver d3.js compliant JSON and CSV downloads,
	with XSLT and Javascript adapted from the Nomisma.org analyses. 
	
	The new distribution interface is available at visualize/distribution, and also derived from local or Nomisma.org SPARQL queries, but the old distribution interface
	based on Solr facet results will remain intact to support visualizing queries directly from the browse interface. The Solr facets were once HTML tables generated by a pipeline
	and embedded in the HTML document for this page and then rendered in the Highcharts library. As of March 2019, the Solr-based distribution results have been migrated to an API for
	JSON results to be displayed in d3.js -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:numishare="https://github.com/ewg118/numishare"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../templates.xsl"/>
	<xsl:include href="../functions.xsl"/>
	<xsl:include href="../templates-search.xsl"/>

	<xsl:variable name="pipeline">visualize</xsl:variable>
	<xsl:variable name="display_path"/>
	<xsl:variable name="include_path"
		select="
			if (string(//config/theme/themes_url)) then
				concat(//config/theme/themes_url, //config/theme/orbeon_theme)
			else
				concat('http://', doc('input:request')/request/server-name, ':8080/orbeon/themes/', //config/theme/orbeon_theme)"/>

	<!-- request parameters -->
	<xsl:param name="langParam" select="doc('input:request')/request/parameters/parameter[name = 'lang']/value"/>
	<xsl:param name="lang">
		<xsl:choose>
			<xsl:when test="string($langParam)">
				<xsl:value-of select="$langParam"/>
			</xsl:when>
			<xsl:when test="string(doc('input:request')/request//header[name[. = 'accept-language']]/value)">
				<xsl:value-of select="numishare:parseAcceptLanguage(doc('input:request')/request//header[name[. = 'accept-language']]/value)[1]"/>
			</xsl:when>
		</xsl:choose>
	</xsl:param>

	<xsl:param name="q" select="doc('input:request')/request/parameters/parameter[name = 'q']/value"/>

	<!-- typological comparison -->
	<xsl:param name="dist" select="doc('input:request')/request/parameters/parameter[name = 'category']/value"/>
	<xsl:param name="compare" select="doc('input:request')/request/parameters/parameter[name = 'compare']/value"/>
	<xsl:param name="numericType" select="doc('input:request')/request/parameters/parameter[name = 'type']/value"/>

	<!-- config variables -->
	<xsl:variable name="url" select="//config/url"/>
	<xsl:variable name="collection_type" select="//config/collection_type"/>
	<!-- load facets into variable -->
	<xsl:variable name="facets" select="//lst[@name = 'facet_fields']" as="node()*"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="//config/title"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="numishare:normalizeLabel('header_visualize', $lang)"/>
				</title>
				<link rel="shortcut icon" type="image/x-icon" href="{$include_path}/images/favicon.png"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"/>

				<xsl:for-each select="//config/includes/include">
					<xsl:choose>
						<xsl:when test="@type = 'css'">
							<link type="text/{@type}" rel="stylesheet" href="{@url}"/>
						</xsl:when>
						<xsl:when test="@type = 'javascript'">
							<script type="text/{@type}" src="{@url}"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>

				<!-- bootstrap -->
				<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
				<script src="https://netdna.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"/>

				<!-- Add fancyBox -->
				<link rel="stylesheet" href="{$include_path}/css/jquery.fancybox.css?v=2.1.5" type="text/css" media="screen"/>
				<script type="text/javascript" src="{$include_path}/javascript/jquery.fancybox.pack.js?v=2.1.5"/>
				<link type="text/css" href="{$include_path}/css/style.css" rel="stylesheet"/>

				<!-- visualization libraries -->
				<script type="text/javascript" src="{$include_path}/javascript/d3.min.js"/>
				<script type="text/javascript" src="{$include_path}/javascript/d3plus-plot.full.min.js"/>
				<script type="text/javascript" src="{$include_path}/javascript/search_functions.js"/>
				<script type="text/javascript" src="{$include_path}/javascript/visualize_functions.js"/>

				<xsl:if test="string(//config/google_analytics)">
					<script type="text/javascript">
						<xsl:value-of select="//config/google_analytics"/>
					</script>
				</xsl:if>
			</head>
			<body>
				<xsl:call-template name="header"/>
				<xsl:call-template name="body"/>
				<xsl:call-template name="footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div class="container-fluid">
			<xsl:if test="//config/languages/language[@code = $lang]/@rtl = true()">
				<xsl:attribute name="style">direction: rtl;</xsl:attribute>
			</xsl:if>
			<div class="row">
				<div class="col-md-12">
					<!-- depreciation message -->

					<xsl:if test="$collection_type = 'cointype'">
						<div class="alert alert-box alert-warning">
							<span class="glyphicon glyphicon-info-sign"></span>
							<strong><xsl:value-of select="numishare:regularize_node('note', $lang)"/>:</strong> The distribution analysis interface is
							going to be deprecated in favor of a <a
								href="./visualize/distribution{if (string($langParam)) then concat('?lang=', $langParam) else ''}">new system</a>. The metrical
							analyses have migrated to <a href="./visualize/metrical{if (string($langParam)) then concat('?lang=', $langParam) else ''}"
							>here</a>.</div>
					</xsl:if>


					<h1>
						<xsl:value-of select="numishare:normalizeLabel('header_visualize', $lang)"/>
					</h1>
					<p><xsl:value-of select="numishare:normalizeLabel('visualize_desc', $lang)"/>: <a href="http://wiki.numismatics.org/numishare:visualize"
							target="_blank">http://wiki.numismatics.org/numishare:visualize</a>.</p>

					<!-- March 2019: tabs disabled. Metrical interface linked to new page -->
					<xsl:apply-templates select="/content/response"/>
				</div>
			</div>
		</div>

		<div class="hidden">
			<span id="display_path">
				<xsl:value-of select="$display_path"/>
			</span>
			<div id="searchBox">
				<h3>
					<xsl:value-of select="numishare:normalizeLabel('visualize_add_query', $lang)"/>
				</h3>
				<xsl:call-template name="search_forms"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="response">

		<h3>
			<xsl:value-of select="numishare:normalizeLabel('visualize_typological', $lang)"/>
		</h3>

		<div id="distribution">
			<xsl:if test="string($dist) and count($compare) &gt; 0">
				<xsl:call-template name="chart">
					<xsl:with-param name="hidden" select="false()" as="xs:boolean"/>
					<xsl:with-param name="interface">distribution</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

			<xsl:call-template name="distribution-form"/>
		</div>
	</xsl:template>

	<!-- ************** SOLR-BASED VISUALIZATION FORM ************** -->
	<xsl:template name="distribution-form">

		<form action="{concat($display_path, 'visualize')}" role="form" id="distributionForm" class="quant-form" method="get">

			<div class="form-group">
				<h4>
					<xsl:value-of select="numishare:normalizeLabel('visualize_response_type', $lang)"/>
				</h4>
				<input type="radio" name="type" value="percentage">
					<xsl:if test="not(string($numericType)) or $numericType = 'percentage'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="numishare:normalizeLabel('numeric_percentage', $lang)"/>
				</input>
				<br/>
				<input type="radio" name="type" value="count">
					<xsl:if test="$numericType = 'count'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="numishare:normalizeLabel('numeric_count', $lang)"/>
				</input>
			</div>

			<!-- select distribution category by checklist -->
			<div class="form-group">
				<h4>Category</h4>

				<select name="category" class="form-control" id="categorySelect">
					<option value="">Select...</option>
					<xsl:for-each select="//lst[@name = 'facet_fields']/lst">
						<option value="{@name}">
							<xsl:if test="@name = $dist">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="numishare:normalize_fields(@name, $lang)"/>
						</option>
					</xsl:for-each>
				</select>
			</div>

			<div class="form-group">
				<h4>
					<xsl:choose>
						<xsl:when test="string($q)">
							<xsl:value-of select="numishare:normalizeLabel('visualize_compare_optional', $lang)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="numishare:normalizeLabel('visualize_compare', $lang)"/>
						</xsl:otherwise>
					</xsl:choose>
					<small style="margin-left:10px;">
						<a href="#searchBox" class="addQuery" id="compareQuery">
							<span class="glyphicon glyphicon-plus"/>
							<xsl:value-of select="numishare:normalizeLabel('visualize_add_query', $lang)"/>
						</a>
					</small>
				</h4>
				<div id="compareQueryDiv">
					<div id="empty-query-alert">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="string($compare)">alert alert-box alert-danger hidden</xsl:when>
								<xsl:otherwise>alert alert-box alert-danger</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<span class="glyphicon glyphicon-exclamation-sign"/>
						<strong><xsl:value-of select="numishare:normalizeLabel('visualize_alert', $lang)"/>:</strong> There must be at least one query to
						visualize.</div>

					<xsl:for-each select="tokenize($compare, '\|')">
						<div class="compareQuery">
							<b><xsl:value-of select="numishare:normalizeLabel('visualize_comparison_query', $lang)"/>: </b>
							<span class="query">
								<xsl:value-of select="."/>
							</span>
							<a href="#" class="removeQuery">
								<span class="glyphicon glyphicon-remove"/>
								<xsl:value-of select="numishare:normalizeLabel('visualize_remove_query', $lang)"/>
							</a>
						</div>
					</xsl:for-each>
				</div>
			</div>

			<xsl:if test="string($langParam)">
				<input type="hidden" name="lang" value="{$lang}"/>
			</xsl:if>
			<input type="hidden" name="compare" value="{$compare}"/>
			<br/>

			<input type="submit" value="{numishare:normalizeLabel('visualize_generate', $lang)}" class="btn btn-default visualize-submit" disabled="disabled"/>
		</form>
	</xsl:template>

	<!-- templates -->
	<xsl:template name="chart">
		<xsl:param name="hidden"/>
		<xsl:param name="interface"/>

		<xsl:variable name="api">getSolrDistribution</xsl:variable>

		<div>
			<xsl:choose>
				<xsl:when test="$hidden = true()">
					<xsl:attribute name="class">hidden chart-container</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">chart-container</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<div id="{$interface}-chart"/>

			<!-- only display model-generated link when there are URL params (distribution page) -->
			<div style="margin-bottom:10px;" class="control-row text-center">
				<p>The chart is limited to 100 results. For the full distribution, please download the CSV.</p>

				<xsl:choose>
					<xsl:when test="$hidden = false()">
						<xsl:variable name="queryParams" as="element()*">
							<params>
								<xsl:if test="string($dist)">
									<param>
										<xsl:value-of select="concat('category=', $dist)"/>
									</param>
								</xsl:if>
								<xsl:if test="string($numericType)">
									<param>
										<xsl:value-of select="concat('type=', $numericType)"/>
									</param>
								</xsl:if>
								<xsl:if test="string($compare)">
									<param>
										<xsl:value-of select="concat('compare=', $compare)"/>
									</param>
								</xsl:if>
								<xsl:if test="string($langParam)">
									<param>
										<xsl:value-of select="concat('lang=', $langParam)"/>
									</param>
								</xsl:if>
								<param>format=csv</param>
							</params>
						</xsl:variable>

						<a href="{$display_path}apis/{$api}?{string-join($queryParams/*, '&amp;')}" title="Download CSV" class="btn btn-primary">
							<span class="glyphicon glyphicon-download"/>Download CSV</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="#" title="Download" class="btn btn-primary">
							<span class="glyphicon glyphicon-download"/>Download CSV</a>
						<a href="#" title="Bookmark" class="btn btn-primary">
							<span class="glyphicon glyphicon-download"/>View in Separate Page</a>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>

	</xsl:template>
</xsl:stylesheet>
