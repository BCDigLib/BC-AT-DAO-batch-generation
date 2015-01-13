<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ead="urn:isbn:1-931666-22-9" version="1.0" exclude-result-prefixes="xsi">
    <!-- headerDefault.xml contains column headers -->
    <xsl:variable name="varHeader" select="document('headerDefault.xml')"/>
    <!-- atDAOInstanceTypeLookup.xml contains lookup values to map AT Instance Type
         to mods:typeOfResource values and Language code
    -->
    <xsl:variable name="varInstanceLookup" select="document('atDAOInstanceTypeLookup.xml')"/>
    <!-- Global variables -->
    <xsl:variable name="varResourceID" select="/ead:ead/ead:archdesc[@level='collection']/ead:did/ead:unitid"/>
    <xsl:output method="text" version="1.0" encoding="UTF-8"/>
    <xsl:template match="/ead:ead">
        <!-- Output header values -->
        <xsl:value-of select="$varHeader"/>        
        <xsl:apply-templates select="ead:archdesc/ead:dsc/ead:c"/>     
    </xsl:template>
    <xsl:template match="ead:c[@level='file'] | ead:c[@level='item']">
        <xsl:variable name="varTab"><xsl:text>&#x9;</xsl:text></xsl:variable>
        <xsl:variable name="varQuote">"</xsl:variable>
        <!-- First Two Container Levels  
             ead:did/ead:unitid is flag that item has been digitized 
        -->
        <xsl:choose>
            <!-- Process container when unitid is present and dao is NOT (previously ingested item). -->
            <xsl:when test="ead:did/ead:unitid and not(ead:dao)">
                <xsl:for-each select="ead:did/ead:container">
                    <xsl:choose>
                        <xsl:when test="position()=1">
                            <xsl:value-of select="concat(@type, ' ', format-number(.,'000'))"/>                            
                        </xsl:when>
                        <xsl:when test="position()=2">
                            <xsl:choose>
                                <xsl:when test="contains(.,'-')">
                                    <xsl:value-of select="concat('; ',@type, ' ', format-number(substring-before(.,'-'),'000'))"/>   
                                    <xsl:value-of select="concat('-', format-number(substring-after(.,'-'),'000'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('; ', @type, ' ', format-number(.,'000'))"/>                                  
                                </xsl:otherwise>
                            </xsl:choose>                          
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:value-of select="$varTab"/>
                <!-- Handle format is based on item unitid -->
                <xsl:value-of select="concat('http://hdl.handle.net/2345.2/',ead:did/ead:unitid)"/><xsl:value-of select="$varTab"/>
                <!-- isComponent -->
                <xsl:text>FALSE</xsl:text><xsl:value-of select="$varTab"/>
                <!-- componentID -->  
                <xsl:value-of select="ead:did/ead:unitid"/><xsl:value-of select="$varTab"/> <!-- item level unitid -->   
                <!-- dates-->
                <!-- when the date expression is undated, use the dates of the parent c-level for begin and end dates.  If the parent
                    c-level does not have a unit date then take the begin and end dates from the archdesc inclusive unit-date-->
                <xsl:choose>
                    <xsl:when test="contains(translate(ead:did/ead:unitdate,'UNDATED','undated'),'undated')">
                        <xsl:choose>
                            <xsl:when test="(parent::ead:c/ead:did/ead:unitdate) and (parent::ead:c/ead:did/ead:unitdate !='undated')">
                                <xsl:value-of select="substring-before(parent::ead:c/ead:did/ead:unitdate/@normal,'/')"/><xsl:value-of select="$varTab"/>
                                <xsl:value-of select="substring-after(parent::ead:c/ead:did/ead:unitdate/@normal,'/')"/><xsl:value-of select="$varTab"/>
                                <xsl:value-of select="translate(normalize-space(ead:did/ead:unitdate),'UNDATED','undated')"/><xsl:value-of select="$varTab"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before(//ead:ead/ead:archdesc/ead:did/ead:unitdate[@type='inclusive']/@normal,'/')"/><xsl:value-of select="$varTab"/>
                                <xsl:value-of select="substring-after(//ead:ead/ead:archdesc/ead:did/ead:unitdate[@type='inclusive']/@normal,'/')"/><xsl:value-of select="$varTab"/>
                                <xsl:value-of select="translate(normalize-space(ead:did/ead:unitdate),'UNDATED','undated')"/><xsl:value-of select="$varTab"/>
                            </xsl:otherwise>
                        </xsl:choose>                      
                    </xsl:when>
                    <!-- when the date expression is other than undated-->
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(ead:did/ead:unitdate/@normal,'/')"/><xsl:value-of select="$varTab"/>
                        <xsl:value-of select="substring-after(ead:did/ead:unitdate/@normal,'/')"/><xsl:value-of select="$varTab"/>	
                        <xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/><xsl:value-of select="$varTab"/> 
                    </xsl:otherwise>
                </xsl:choose>
                <!-- skip label for parent -->
                <xsl:value-of select="$varTab"/>
                <!-- languageCode -->
                <xsl:variable name="varLabel"><xsl:value-of select="normalize-space(ead:did/ead:container/@label)"/></xsl:variable>
                <xsl:value-of select="$varInstanceLookup/atDAOInstanceTypeLookup/atDAOInstance[@type=$varLabel]/@lang"/><xsl:value-of select="$varTab"/>
                <!-- title -->
                <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/><xsl:value-of select="$varTab"/>
                <!-- objectType -->        
                <xsl:value-of select="$varInstanceLookup/atDAOInstanceTypeLookup/atDAOInstance[@type=$varLabel]/@mods"/><xsl:value-of select="$varTab"/>
                <!-- skip restrictionsApply, eadDaoActuate, eadDaoShow uri -->
                <xsl:value-of select="$varTab"/><xsl:value-of select="$varTab"/><xsl:value-of select="$varTab"/><xsl:value-of select="$varTab"/>
                <!-- skip useStatement abstract biographicalHistorical conditionsGoverningAccess -->
                <xsl:value-of select="$varTab"/><xsl:value-of select="$varTab"/><xsl:value-of select="$varTab"/><xsl:value-of select="$varTab"/>
                <!-- conditionsGoverningUse -->
                <xsl:value-of select="normalize-space(//ead:ead/ead:archdesc[@level='collection']/ead:userestrict/ead:p)"/><xsl:value-of select="$varTab"/>
                <!-- skip custodialHistory -->
                <xsl:value-of select="$varTab"/>
                <!-- skip dimensions -->
                <xsl:value-of select="$varTab"/>
            <xsl:text>
</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
  
    <xsl:template match="text()"/>
</xsl:stylesheet>