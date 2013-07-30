<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ead="urn:isbn:1-931666-22-9" version="1.0" exclude-result-prefixes="xsi">
	<xsl:output method="text" version="1.0" encoding="UTF-8"/>
	<xsl:template match="/ead:ead">
		<xsl:variable name="digitalObjectID">
			<xsl:value-of select="ead:archdesc/ead:did/ead:unitid"/>
		</xsl:variable>
		<xsl:variable name="abstract">
			<xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:abstract)"/>
		</xsl:variable>
		<xsl:variable name="conditionsGoverningUse">
			<xsl:value-of select="normalize-space(ead:archdesc/ead:userrestrict/ead:p)"/>
		</xsl:variable>
		<xsl:variable name="tab">
			<xsl:text>&#x9;</xsl:text>
		</xsl:variable>

		<xsl:apply-templates select="ead:archdesc/ead:dsc">
			<xsl:with-param name="paraDigitalObjectID">
				<xsl:value-of select="$digitalObjectID"/>
			</xsl:with-param>
			<xsl:with-param name="paraAbstract">
				<xsl:value-of select="$abstract"/>
			</xsl:with-param>
			<xsl:with-param name="paraConditionsGoverningUse">
				<xsl:value-of select="$conditionsGoverningUse"/>
			</xsl:with-param>
			<xsl:with-param name="paraTab">
				<xsl:value-of select="$tab"/>
			</xsl:with-param>
			<!-- this isn't getting used
			<xsl:with-param name="paraHandle">
				<xsl:value-of select="$handle"/>
			</xsl:with-param>-->
		</xsl:apply-templates>
		<!--this isn't being used 
		<xsl:variable name="handle"><xsl:text>11</xsl:text></xsl:variable>-->
		<!-- Don't do this, this is bad form : Hardcoded for Donnelly Scrapbooks -->
		<!-- -->

	</xsl:template>

	<xsl:template match="ead:archdesc/ead:dsc">

		<xsl:param name="paraDigitalObjectID"/>
		<xsl:param name="paraAbstract"/>
		<xsl:param name="paraConditionsGoverningUse"/>
		<xsl:param name="paraTab"/>

		<xsl:apply-templates select="ead:c">
			<xsl:with-param name="paraDigitalObjectID">

				<xsl:value-of select="$paraDigitalObjectID"/>
			</xsl:with-param>
			<xsl:with-param name="paraAbstract">
				<xsl:value-of select="$paraAbstract"/>
			</xsl:with-param>
			<xsl:with-param name="paraConditionsGoverningUse">
				<xsl:value-of select="$paraConditionsGoverningUse"/>
			</xsl:with-param>
			<xsl:with-param name="paraTab">
				<xsl:value-of select="$paraTab"/>
			</xsl:with-param>

		</xsl:apply-templates>

	</xsl:template>
	<xsl:template match="ead:c">
		<xsl:param name="paraDigitalObjectID"/>
		<xsl:param name="paraAbstract"/>
		<xsl:param name="paraConditionsGoverningUse"/>
		<xsl:param name="paraTab"/>
		<!--<xsl:param name="paraHandle"/>-->

		<xsl:for-each select="ead:c[@level='file']">
			<!-- Betsy adds test to see if entry in container list has a component id-->
			<xsl:if test="ead:did/ead:unitid">

				<!-- container info for "imaging work order" delete this column later-->
				<xsl:value-of select="ead:did/ead:container/@type"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="format-number(ead:did/ead:container,'000')"/>
				<xsl:if test="ead:did/container[2]">
					<xsl:text>; </xsl:text>
					<xsl:value-of select="ead:did/ead:container/@type"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="format-number(ead:did/ead:container,'000')"/>
				</xsl:if>
				<xsl:value-of select="$paraTab"/>

				<!-- digitalObjectID -->
				<xsl:value-of select="concat('http://hdl.handle.net/2345.2/', position()-1)"/>
		
				<xsl:value-of select="$paraTab"/>

				<!-- isComponent -->
				<!--Betsy changed default to false -->
				<xsl:text>FALSE</xsl:text>
				<xsl:value-of select="$paraTab"/>
				<!-- componentID -->
				<!-- Betsy commenting this out; new component id definitiion <xsl:value-of select="@id"/>-->
				<xsl:value-of select="ead:did/ead:unitid"/>
				<xsl:value-of select="$paraTab"/>
				<!-- dateBegin -->
				<xsl:value-of select="substring-before(ead:did/ead:unitdate/@normal,'/')"/>
				<xsl:value-of select="$paraTab"/>
				<!-- dateEnd -->
				<xsl:value-of select="substring-after(ead:did/ead:unitdate/@normal,'/')"/>
				<xsl:value-of select="$paraTab"/>
				<!-- dateExpression -->
				<xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/>
				<xsl:value-of select="$paraTab"/>
				<!-- label -->
				<xsl:value-of select="$paraDigitalObjectID"/>
				<xsl:value-of select="$paraTab"/>
				<!-- languageCode -->
				<xsl:text>zxx</xsl:text>
				<xsl:value-of select="$paraTab"/>
				<!-- title -->
				<xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
				<xsl:value-of select="$paraTab"/>
				<!-- objectType -->
				<!--Betsy this needs smart mapping from toolkit value to MODS:type -->
				<xsl:text>still image</xsl:text>
				<xsl:value-of select="$paraTab"/>
				<!-- skip restrictionsApply, eadDaoActuate, eadDaoShow -->
				<xsl:value-of select="$paraTab"/>
				<xsl:value-of select="$paraTab"/>
				<xsl:value-of select="$paraTab"/>
				<!-- This will only work for the Donnelly test and for handles starting at 0 -->
				<xsl:value-of select="ead:did/ead:unitid"/>
				<xsl:value-of select="$paraTab"/>
				<!-- skip useStatement -->
				<!--Betsy adds use statement, hardcoded-->
				<xsl:text>reference image</xsl:text>
				<xsl:value-of select="$paraTab"/>
				<!-- abstract -->
				<!-- Not sure about this : I think this maps to Abstract under Notes Etc. not to the EAD abstract -->
				<!--xsl:value-of select="$paraAbstract"/-->
				<xsl:value-of select="$paraTab"/>
				<!-- Skip biographicalHistorical, conditionsGoverningAccess -->
				<xsl:value-of select="$paraTab"/>
				<xsl:value-of select="$paraTab"/>
				<!-- conditionsGoverningUse -->
				<xsl:value-of select="$paraConditionsGoverningUse"/>
				<xsl:value-of select="$paraTab"/>
				<!-- skip custodialHistory, dimensions, existenceLocationCopies -->
				<xsl:value-of select="$paraTab"/>
				<xsl:value-of select="$paraTab"/>
				<xsl:value-of select="$paraTab"/>
				<!-- existenceLocationOriginals -->
				<!-- Betsy we need to pull this data from instance information; we won't be crating this note for the analog instance-->
				<xsl:value-of select="ead:did/ead:container/@type"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="ead:did/ead:container"/>
				<xsl:if test="ead:did/container[2]">
					<xsl:text>; </xsl:text>
					<xsl:value-of select="ead:did/ead:container/@type"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ead:did/ead:container"/>
				</xsl:if>
				<xsl:value-of select="$paraTab"/>

				<xsl:text>
</xsl:text>
			</xsl:if>

		</xsl:for-each>
		<xsl:apply-templates select="ead:c">
			<xsl:with-param name="paraDigitalObjectID">

				<xsl:value-of select="$paraDigitalObjectID"/>
			</xsl:with-param>
			<xsl:with-param name="paraAbstract">
				<xsl:value-of select="$paraAbstract"/>
			</xsl:with-param>
			<xsl:with-param name="paraConditionsGoverningUse">
				<xsl:value-of select="$paraConditionsGoverningUse"/>
			</xsl:with-param>
			<xsl:with-param name="paraTab">
				<xsl:value-of select="$paraTab"/>
			</xsl:with-param>

		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="text()"/>
</xsl:stylesheet>
