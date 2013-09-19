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
        <xsl:text>&#xa;</xsl:text>
        <mods:name authority="naf" type="corporate">
            <xsl:text>&#xa;</xsl:text>
            <mods:namePart>Boston College</mods:namePart>
            <xsl:text>&#xa;</xsl:text>
            <mods:namePart>John J. Burns Library</mods:namePart>
            <xsl:text>&#xa;</xsl:text>
            <mods:displayForm>Boston College. John J. Burns Library</mods:displayForm>
            <xsl:text>&#xa;</xsl:text>
            <mods:role>
            <xsl:text>&#xa;</xsl:text>
                <mods:roleTerm type="code" authority="marcrelator">own</mods:roleTerm>
            <xsl:text>&#xa;</xsl:text>
                <mods:roleTerm type="text" authority="marcrelator">Owner</mods:roleTerm>
            <xsl:text>&#xa;</xsl:text>
            </mods:role>
            <xsl:text>&#xa;</xsl:text>
        </mods:name>
        <xsl:text>&#xa;</xsl:text>
        <xsl:element name="{'mods:'}{local-name()}">
            <xsl:attribute name="manuscript">yes</xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!--(5)mods:originInfo; (6) mods:language; (7) mods:physicalDescription-->
    <xsl:template match="mods:mods/mods:originInfo">
        <xsl:text>&#xa;</xsl:text>
        <xsl:element name="{'mods:'}{local-name()}">
            <xsl:text>&#xa;</xsl:text>
            <mods:dateCreated>
                <xsl:value-of select="mods:dateCreated[1]"/>
            </mods:dateCreated>
            <xsl:text>&#xa;</xsl:text>
            <xsl:choose>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]!='Undated'">
                    <mods:dateCreated keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:when>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated keyDate="yes" qualifier="inferred" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:when>

                <xsl:when
                    test="mods:dateCreated[2]!=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated point="start" keyDate="yes" qualifier="approximate"
                        encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                    <mods:dateCreated point="end" qualifier="approximate" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <mods:dateCreated point="start" keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                    <mods:dateCreated point="end" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#xa;</xsl:text>
            <mods:issuance>monographic</mods:issuance>
            <xsl:text>&#xa;</xsl:text>
        </xsl:element>
        <!-- Upgrade later to handle all languages.  Right now this is just constant data for English-->
        <xsl:text>&#xa;</xsl:text>
        <mods:language>
        <xsl:text>&#xa;</xsl:text>
            <mods:languageTerm type="code" authority="iso639-2b">eng</mods:languageTerm>
            <xsl:text>&#xa;</xsl:text>
            <mods:languageTerm type="text">English</mods:languageTerm>
            <xsl:text>&#xa;</xsl:text>
        </mods:language>
        <xsl:text>&#xa;</xsl:text>
    
        <!--Upgrade physical description later.  This is all constant data now and the extent only applies to single letters.-->
        <xsl:text>&#xa;</xsl:text>
        <mods:physicalDescription>
            <xsl:text>&#xa;</xsl:text>
            <mods:form authority="marcform">electronic</mods:form>
            <xsl:text>&#xa;</xsl:text>
            <mods:internetMediaType>image/jpeg</mods:internetMediaType>
            <xsl:text>&#xa;</xsl:text>
            <mods:extent>1 scrapbook</mods:extent>
            <xsl:text>&#xa;</xsl:text>
            <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
            <xsl:text>&#xa;</xsl:text>
        </mods:physicalDescription>
        <xsl:text>&#xa;</xsl:text>

    </xsl:template>
    <!--(6)mods:language.  This just needed to be moved down.  The output is happening in the mods:origin template now 
        (and only English is being handled for now).  Upgrade later.-->
    <xsl:template match="mods:mods/mods:language"/>

    <!--(13)mods:relatedItem[@type='host']/mods:originInfo-->
    <xsl:template match="mods:relatedItem[@type='host']/mods:originInfo">
        <xsl:element name="{'mods:'}{local-name()}">
            <xsl:text>&#xa;</xsl:text>
            <mods:dateCreated>
                <xsl:value-of select="mods:dateCreated[1]"/>
            </mods:dateCreated>
            <xsl:text>&#xa;</xsl:text>
            <xsl:choose>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]!='Undated'">
                    <mods:dateCreated keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:when>
                <xsl:when
                    test="mods:dateCreated[2]=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated keyDate="yes" qualifier="inferred" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:when>


                <xsl:when
                    test="mods:dateCreated[2]!=mods:dateCreated[3] and mods:dateCreated[1]='Undated'">
                    <mods:dateCreated point="start" keyDate="yes" qualifier="approximate" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                    <mods:dateCreated point="end" qualifier="approximate" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <mods:dateCreated point="start" keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                    <mods:dateCreated point="end" encoding="w3cdtf">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

    </xsl:template>
    <!--(13)mods:relatedItem[@type='host']/mods:identifer.-->
    <xsl:template match="mods:relatedItem[@type='host']/mods:identifier">  
        <xsl:text>&#xa;</xsl:text>
       <mods:identifier type="accession number"><xsl:value-of select="."/></mods:identifier>   
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!--(13) mods:relatedItem[@type='host']/mods:location.  This template is needed to get part info in.-->

    <xsl:template match="mods:relatedItem[@type='host']/mods:location">
        <xsl:text>&#xa;</xsl:text>
        <xsl:element name="{'mods:'}{local-name()}">
            <xsl:text>&#xa;</xsl:text>
            <xsl:element name="mods:url">
                <xsl:attribute name="displayLabel">
                    <xsl:value-of select="preceding-sibling::mods:titleInfo/mods:title"/>
                </xsl:attribute>
            <xsl:value-of select="mods:url"/>
            </xsl:element>   
            <xsl:text>&#xa;</xsl:text>            
        </xsl:element>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <!--Omit mods:relatedItem[@type='original']-->
    <xsl:template match="mods:relatedItem[@type='original']"/>
    <!--Omit toolkit note.  (16) Add mods:accessCondition; (18) mods:extentsion; (19) mods:recordInfo-->
    <xsl:template match="mods:note[@displayLabel='Digital object made available by ']">
        <mods:accessCondition type="useAndReproduction">These materials are made available for use in research, teaching and private study, pursuant to U.S. Copyright Law. The user must assume full responsibility for any use of the materials, including but not limited to, infringement of copyright and publication rights of reproduced materials. Any materials used for academic research or otherwise should be fully credited with the source. The original authors may retain copyright to the materials.</mods:accessCondition>
        <xsl:text>&#xa;</xsl:text>
        	<mods:extension>
        	    <xsl:text>&#xa;</xsl:text>
        			 
			<mods:localCollectionName><xsl:value-of select="translate(preceding-sibling::mods:relatedItem[@type='host']/mods:identifier,'.','')"></xsl:value-of></mods:localCollectionName>
        	    <xsl:text>&#xa;</xsl:text>
        	</mods:extension>	
        <xsl:text>&#xa;</xsl:text>
        
        <mods:recordInfo>
            <xsl:text>&#xa;</xsl:text>
			<mods:languageOfCataloging>
			    <xsl:text>&#xa;</xsl:text>
			<mods:languageTerm type="text">English</mods:languageTerm>
			    <xsl:text>&#xa;</xsl:text>
			<mods:languageTerm type="code" authority="iso639-2b">eng</mods:languageTerm>
			    <xsl:text>&#xa;</xsl:text>
			</mods:languageOfCataloging>
			<xsl:text>&#xa;</xsl:text>
        </mods:recordInfo>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <!--Special templates for selected mets nodes-->
    <xsl:template match="mets:mets">
 
        <mets:mets
            xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd">
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
               <xsl:text>&#xa;</xsl:text>
  <mets:digiprovMD ID="dp01">
      <xsl:text>&#xa;</xsl:text>
   <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="preservation_md">
       <xsl:text>&#xa;</xsl:text>
    <mets:xmlData>
        <xsl:text>&#xa;</xsl:text>
    <premis xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0" xsi:schemaLocation="info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/premis.xsd">
     <!-- premis file object -->
        <xsl:text>&#xa;</xsl:text>
     <object  xsi:type="file">
         <xsl:text>&#xa;</xsl:text>
         <objectIdentifier>
             <xsl:text>&#xa;</xsl:text>
             <objectIdentifierType>handle</objectIdentifierType>
             <xsl:text>&#xa;</xsl:text>
             <objectIdentifierValue><xsl:value-of select="normalize-space(substring(ancestor::mets:mets/@OBJID,23))"/></objectIdentifierValue>
             <xsl:text>&#xa;</xsl:text>
         </objectIdentifier>
         <xsl:text>&#xa;</xsl:text>
      <preservationLevel>
          <xsl:text>&#xa;</xsl:text>
       <preservationLevelValue/><xsl:text>&#xa;</xsl:text>
      </preservationLevel><xsl:text>&#xa;</xsl:text>
      <objectCharacteristics><xsl:text>&#xa;</xsl:text>
       <compositionLevel>0</compositionLevel><xsl:text>&#xa;</xsl:text>
       <fixity><xsl:text>&#xa;</xsl:text>
        <messageDigestAlgorithm/><xsl:text>&#xa;</xsl:text>
        <messageDigest/><xsl:text>&#xa;</xsl:text>
       </fixity><xsl:text>&#xa;</xsl:text>
       <format><xsl:text>&#xa;</xsl:text>
        <formatRegistry><xsl:text>&#xa;</xsl:text>
         <formatRegistryName/><xsl:text>&#xa;</xsl:text>
         <formatRegistryKey/><xsl:text>&#xa;</xsl:text>
        </formatRegistry><xsl:text>&#xa;</xsl:text>
       </format>  <xsl:text>&#xa;</xsl:text>
      </objectCharacteristics><xsl:text>&#xa;</xsl:text>
      <xsl:text>&#xa;</xsl:text>
     </object>
     <xsl:text>&#xa;</xsl:text>
     <xsl:text>&#xa;</xsl:text>
    </premis><xsl:text>&#xa;</xsl:text>
    </mets:xmlData><xsl:text>&#xa;</xsl:text>
   </mets:mdWrap><xsl:text>&#xa;</xsl:text>
  </mets:digiprovMD><xsl:text>&#xa;</xsl:text>
 </mets:amdSec><xsl:text>&#xa;</xsl:text>
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <!--mets:file add mimetype and sequence number, to make sure thumbnails show up after the ingest-->
    <xsl:template match="mets:file">
        <xsl:text>&#xa;</xsl:text>
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:attribute name="SEQ">
                <xsl:number level="single" count="mets:file"></xsl:number>
            </xsl:attribute>          
            <xsl:choose>
                <xsl:when test="@USE='archive image'">
                  <xsl:attribute name="MIMETYPE">image/tiff</xsl:attribute>                   
                    <xsl:apply-templates select="@*|node()"/>
                    <xsl:text>&#xa;</xsl:text>
                  
                </xsl:when>
                <xsl:otherwise>
                                      <xsl:attribute name="MIMETYPE">image/jpeg</xsl:attribute>  
                    <xsl:apply-templates select="@*|node()"/>
                    
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:element>
        
    </xsl:template>

    

    <!--Omit logical structMap-->
    <xsl:template match="mets:structMap[@TYPE='logical']"></xsl:template>





</xsl:stylesheet>


