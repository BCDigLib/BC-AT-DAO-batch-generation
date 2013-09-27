<?xml version="1.0" encoding="UTF-8"?>

 <!--
        *******************************************************************
        *                                                                 *
        * VERSION:          1.00                                          *
        *                                                                 *
        * AUTHOR:           Betsy McKelvey                                *
        *                   mckelvee@bc.edu                               *
        *                                                                 *
        *                                                                 *
        * ABOUT:           This file has been created to convert          *
        *                  Archivists' Toolkit METS/MODS into a form      *
        *                  suitable for use in the Boston College         *
        *                  Digital Library. Oct 30, 2011                  *
        *                                                                 *
        * UPDATED:  
        * 
        * USE:             1.)  mods:names are project specific and need to be updated for each project
        *                  2.)  mods:typeOfResource has a manuscript attribute
        *                  3.) mods:physicalDescription assumes 1 letter with tiff and jpg manifestations.
        
        *******************************************************************
    -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd"
    version="2.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    <!--Identity Template.  This version of the Identity Template does not copy over namespaces.  
        Nodes that need special processing other than copying have their own template below the 
        Identity Template-->
    
    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="substring(name(),1,4)='mods'">
                <xsl:element name="{name()}">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{'mets:'}{name()}">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@*|text()|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <!--End of Identity Template-->

    <!--Special templates for selected mods nodes-->
    <!--(2)mods:name and (3)mods:typeOfResource-->
    <xsl:template match="mods:typeOfResource">
        <mods:name authority="naf" type="corporate">
            <mods:namePart>Boston College</mods:namePart>
            <mods:namePart>John J. Burns Library</mods:namePart>
            <mods:displayForm>Boston College. John J. Burns Library</mods:displayForm>
            <mods:role>
                <mods:roleTerm type="code" authority="marcrelator">own</mods:roleTerm>
                <mods:roleTerm type="text" authority="marcrelator">Owner</mods:roleTerm>
            </mods:role>
        </mods:name>
        <xsl:element name="{'mods:'}{local-name()}">
            <xsl:attribute name="manuscript">yes</xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <!--(5)mods:originInfo; (6) mods:language; (7) mods:physicalDescription-->
    <xsl:template match="mods:mods/mods:originInfo">
        <xsl:element name="{'mods:'}{local-name()}">
            <mods:dateCreated>
                <xsl:value-of select="mods:dateCreated[1]"/>
            </mods:dateCreated>
            <xsl:choose>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]!='Undated'">
                    <mods:dateCreated keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated keyDate="yes" qualifier="inferred" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:when
                    test="mods:dateCreated[2]!=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated point="start" keyDate="yes" qualifier="approximate" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <mods:dateCreated point="end" qualifier="approximate" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:otherwise>
                    <mods:dateCreated point="start" keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <mods:dateCreated point="end" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                </xsl:otherwise>
            </xsl:choose>
            <mods:issuance>monographic</mods:issuance>
        </xsl:element>
        <!-- Upgrade later to handle all languages.  Right now this is just constant data for English-->
        <mods:language>
            <mods:languageTerm type="code" authority="iso639-2b">eng</mods:languageTerm>
            <mods:languageTerm type="text">English</mods:languageTerm>
        </mods:language>
        <!--Upgrade physical description later.  This is all constant data now and the extent only applies to single letters.-->
        <mods:physicalDescription>
            <mods:form authority="marcform">electronic</mods:form>
            <!-- Map internetMediaType for each distinct fileGrp -->
            <xsl:for-each select="/mets:mets/mets:fileSec/mets:fileGrp">
                    <mods:internetMediaType>
                        <xsl:variable name="varFileExt">
                            <xsl:value-of select="substring-after(mets:file[1]/mets:FLocat/@xlink:href,'.')"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$varFileExt = 'jpg'">image/jpeg</xsl:when>
                            <xsl:when test="$varFileExt = 'jpeg'">image/jpeg</xsl:when>
                            <xsl:when test="$varFileExt = 'tif'">image/tiff</xsl:when>
                            <xsl:when test="$varFileExt = 'tiff'">image/tiff</xsl:when>
                        </xsl:choose>
                    </mods:internetMediaType>    
            </xsl:for-each>        
            <mods:extent>1 scrapbook</mods:extent>
            <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
        </mods:physicalDescription>
    </xsl:template>
    
    <!--(6)mods:language.  This just needed to be moved down.  The output is happening in the mods:origin template now 
        (and only English is being handled for now).  Upgrade later.-->
    <xsl:template match="mods:mods/mods:language"/>
    <!--(13)mods:relatedItem[@type='host']/mods:originInfo-->
    <xsl:template match="mods:relatedItem[@type='host']/mods:originInfo">
        <xsl:element name="{'mods:'}{local-name()}">
            <mods:dateCreated>
                <xsl:value-of select="mods:dateCreated[1]"/>
            </mods:dateCreated>
            <xsl:choose>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]!='Undated'">
                    <mods:dateCreated keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated keyDate="yes" qualifier="inferred" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:when test="mods:dateCreated[2]!=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated point="start" keyDate="yes" qualifier="approximate" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <mods:dateCreated point="end" qualifier="approximate" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:otherwise>
                    <mods:dateCreated point="start" keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <mods:dateCreated point="end" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

    </xsl:template>
    <!--(13)mods:relatedItem[@type='host']/mods:identifer.-->
    <xsl:template match="mods:relatedItem[@type='host']/mods:identifier">  
       <mods:identifier type="accession number"><xsl:value-of select="."/></mods:identifier>   
    </xsl:template>

    <!--(13) mods:relatedItem[@type='host']/mods:location.  This template is needed to get part info in.-->
    <xsl:template match="mods:relatedItem[@type='host']/mods:location">
        <xsl:element name="{'mods:'}{local-name()}">
            <xsl:element name="mods:url">
                <xsl:attribute name="displayLabel">
                    <xsl:value-of select="preceding-sibling::mods:titleInfo/mods:title"/>
                </xsl:attribute>
            <xsl:value-of select="mods:url"/>
            </xsl:element>              
        </xsl:element>
    </xsl:template>
    
    <!--Omit mods:relatedItem[@type='original']-->
    <xsl:template match="mods:relatedItem[@type='original']"/>
    
    <!--Omit toolkit note.  (16) Add mods:accessCondition; (18) mods:extentsion; (19) mods:recordInfo-->
    <xsl:template match="mods:note[@displayLabel='Digital object made available by ']">
        <mods:accessCondition type="useAndReproduction">These materials are made available for use in research, teaching and private study, pursuant to U.S. Copyright Law. The user must assume full responsibility for any use of the materials, including but not limited to, infringement of copyright and publication rights of reproduced materials. Any materials used for academic research or otherwise should be fully credited with the source. The original authors may retain copyright to the materials.</mods:accessCondition>
        	<mods:extension>		 
			 <mods:localCollectionName><xsl:value-of select="translate(preceding-sibling::mods:relatedItem[@type='host']/mods:identifier,'.','')"></xsl:value-of></mods:localCollectionName>
        	</mods:extension>	
        <mods:recordInfo>
            <mods:languageOfCataloging>
			     <mods:languageTerm type="text">English</mods:languageTerm>
			     <mods:languageTerm type="code" authority="iso639-2b">eng</mods:languageTerm>
			</mods:languageOfCataloging>
        </mods:recordInfo>
    </xsl:template>
    
    <!--Special templates for selected mets nodes-->
    <xsl:template match="mets:mets">
        <mets:mets xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd">
            <xsl:attribute name="OBJID">
                <xsl:value-of select="@OBJID"/>
            </xsl:attribute>
            <xsl:attribute name="LABEL">
                <xsl:value-of select="@LABEL"/>
            </xsl:attribute>
            <xsl:attribute name="TYPE">text-monograph-whole</xsl:attribute>
            <xsl:attribute name="PROFILE">
                <xsl:value-of select="@PROFILE"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </mets:mets>
    </xsl:template>
    
    <!--Change note in mets:hdr-->
    <xsl:template match="mets:note[1]">
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:text>Produced by Archivists' Toolkit &amp;#153; and modified using a local xslt</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <!--Add amdsec with preservation md-->
    <xsl:template match="mets:fileSec">
        <mets:amdSec>             
            <mets:digiprovMD ID="dp01">
                <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="preservation_md">
                    <mets:xmlData>
                        <premis xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0" xsi:schemaLocation="info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/premis.xsd">
     <!-- premis file object -->
     <object  xsi:type="file">
         <objectIdentifier>
             <objectIdentifierType>handle</objectIdentifierType>
             <objectIdentifierValue><xsl:value-of select="normalize-space(substring(ancestor::mets:mets/@OBJID,23))"/></objectIdentifierValue>
         </objectIdentifier>
      <preservationLevel>
       <preservationLevelValue/>
      </preservationLevel>
      <objectCharacteristics>
       <compositionLevel>0</compositionLevel>
       <fixity>
        <messageDigestAlgorithm/>
        <messageDigest/>
       </fixity>
       <format>
        <formatRegistry>
         <formatRegistryName/>
         <formatRegistryKey/>
        </formatRegistry>
       </format>  
      </objectCharacteristics>
     </object>
    </premis>
    </mets:xmlData>
   </mets:mdWrap>
  </mets:digiprovMD>
 </mets:amdSec>
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <!--mets:file add mimetype and sequence number, to make sure thumbnails show up after the ingest-->
    <xsl:template match="mets:file"> 
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:attribute name="SEQ">
                <xsl:number level="single" count="mets:file"></xsl:number>
            </xsl:attribute>          
            <xsl:choose>
                <xsl:when test="@USE='archive image'">
                  <xsl:attribute name="MIMETYPE">image/tiff</xsl:attribute>                   
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="MIMETYPE">image/jpeg</xsl:attribute>  
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>        
    </xsl:template>

    <!--Omit logical structMap-->
    <xsl:template match="mets:structMap[@TYPE='logical']"/>
    <xsl:template match="mets:structMap[@TYPE='physical']">
        <!-- Update Top Level div to Manuscript number -->
        <xsl:element name="{'mets:'}{name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mets:div[@DMDID]">
        <xsl:element name="{'mets:'}{name()}"> <!-- Redo @ORDER @LABEL @DMDID @TYPE -->
            <xsl:attribute name="ORDER"><xsl:value-of select="@ORDER"/></xsl:attribute>
            <xsl:attribute name="LABEL"><xsl:value-of select="/mets:mets/mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:relatedItem/mods:identifier"/></xsl:attribute>
            <xsl:attribute name="DMDID"><xsl:value-of select="@DMDID"/></xsl:attribute>
            <xsl:attribute name="TYPE"><xsl:value-of select="@TYPE"/></xsl:attribute>            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>

