<?xml version="1.0" encoding="UTF-8"?>

 <!--
        *******************************************************************
        *                                                                 *
        * VERSION:          1. 01                                         *
        *                                                                 *
        * AUTHOR:           Betsy Post                                    *
        *                   betsy.post@bc.edu                             *
        *                                                                 *
        *                                                                 *
        * ABOUT:           This file has been created to convert          *
        *                  Archivists' Toolkit METS/MODS into a form      *
        *                  suitable for use in the Boston College         *
        *                  Digital Library. Oct 30, 2011                  *
        *                                                                 *
        * UPDATED:         Jan. 27, 2015                                  *
        *                                                                 *
        * USE:             Convert Archivists Toolkit MODS/METS to conform*
        *                  with Boston College and Digital Commonwealth   *
        *                  requirements.                                  *
        *******************************************************************
    -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
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
    <xsl:template match="mods:mods">
        <mods:mods
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates/>
        </mods:mods>
    </xsl:template>

    <!--(1)mods:titldInfo; Digital Commonwealth requires usage-->
    <!-- Not handling nonSort; does DACS allow nonSort?-->

    <xsl:template match="mods:titleInfo">
        <mods:titleInfo usage="primary">
            <xsl:apply-templates/>
        </mods:titleInfo>
    </xsl:template>

    <!--(2)mods:name and (3)mods:typeOfResource-->
    <!--(4) genre (one genre with a broad value displayLabel from Digital Commonwealth list required -->

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
        <!--project dependent-->
        <mods:genre authority="gmgpc" displayLabel="general">photographs</mods:genre>
    </xsl:template>

    <!--(5)mods:originInfo; (6) mods:language -->

    <xsl:template match="mods:originInfo">
        <mods:originInfo>
            <mods:dateCreated>
                <xsl:value-of select="mods:dateCreated[1]"/>
            </mods:dateCreated>
            <xsl:choose>
                <xsl:when test="mods:dateCreated[2]=mods:dateCreated[3]">
                    <mods:dateCreated encoding="w3cdtf" keyDate="yes">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                </xsl:when>
                <xsl:otherwise>
                    <mods:dateCreated encoding="w3cdtf" point="start" keyDate="yes">
                        <xsl:value-of select="mods:dateCreated[2]"/>
                    </mods:dateCreated>
                    <mods:dateCreated encoding="w3cdtf" point="end">
                        <xsl:value-of select="mods:dateCreated[3]"/>
                    </mods:dateCreated>
                </xsl:otherwise>
            </xsl:choose>
            <mods:issuance>monographic</mods:issuance>
        </mods:originInfo>

        <!--(6)mods:language.  The mods:language element is the second one output in toolkit EAD.  
        To re-arrange the elements, this template is here and the output is happening in the mods:origin template now -->

        <mods:language>
            <mods:languageTerm type="code" authority="iso639-2b">
                <xsl:value-of
                    select="preceding-sibling::mods:language/mods:languageTerm[@type='code']"/>
            </mods:languageTerm>
            <mods:languageTerm type="text">
                <xsl:value-of
                    select="preceding-sibling::mods:language/mods:languageTerm[@type='text']"/>
            </mods:languageTerm>
        </mods:language>
    </xsl:template>

    <!--(6)mods:language is processed in originInfo template-->

    <xsl:template match="mods:language"/>


    <!-- (7) mods:physicalDescription contains both constant and added data -->
 
    <xsl:template match="mods:physicalDescription">
        <mods:physicalDescription>
            <mods:form authority="marcform">electronic</mods:form>
            <!-- Internet Media Type - needs further development to handle the case where there
                are multiple internet media types (delimted by a semi-colon-->
            <mods:internetMediaType>
                <xsl:value-of
                    select="mods:note[@displayLabel='Physical Characteristics and Technical Requirements note']"
                />
            </mods:internetMediaType>
            <mods:extent unit="level/digital surrogates">
                <xsl:value-of select="mods:extent"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of
                    select="/mets:mets/mets:structMap[@TYPE='physical']/mets:div/mets:div[last()]/@ORDER"/>
                <xsl:choose>
                    <xsl:when
                        test="/mets:mets/mets:structMap[@TYPE='physical']/mets:div/mets:div[last()]/@ORDER >1 ">
                        <xsl:text> digital surrogates)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> digital surrogate)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </mods:extent>
            <mods:digitalOrigin>
                <xsl:value-of select="mods:note[@displayLabel='Material Specific Details note']"/>
            </mods:digitalOrigin>
        </mods:physicalDescription>
    </xsl:template>

    <!-- (14) mods:relatedItem[@type='host']/mods:originInfo-->
 
    <xsl:template match="mods:relatedItem/mods:originInfo">
        <mods:originInfo>
            <xsl:choose>
                <!-- handle case when host only has begin and end dates-->
                <xsl:when test="count(mods:dateCreated=2)">
                    <xsl:choose>
                        <xsl:when test="mods:dateCreated[1]=mods:dateCreated[2]">
                            <mods:dateCreated>
                                <xsl:value-of select="mods:dateCreated[1]"/>
                            </mods:dateCreated>
                            <mods:dateCreated encoding="w3cdtf" keyDate="yes">
                                <xsl:value-of select="mods:dateCreated[1]"/>
                            </mods:dateCreated>
                        </xsl:when>
                        <xsl:otherwise>
                            <mods:dateCreated>
                                <xsl:value-of select="mods:dateCreated[1]"/>
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="mods:dateCreated[2]"/>
                            </mods:dateCreated>
                            <mods:dateCreated encoding="w3cdtf" point="start" keyDate="yes">
                                <xsl:value-of select="mods:dateCreated[1]"/>
                            </mods:dateCreated>
                            <mods:dateCreated encoding="w3cdtf" point="end">
                                <xsl:value-of select="mods:dateCreated[2]"/>
                            </mods:dateCreated>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </mods:originInfo>
    </xsl:template>

    <!--(14)mods:relatedItem[@type='host']/mods:identifer.-->
    <xsl:template match="mods:relatedItem[@type='host']/mods:identifier">
        <mods:identifier type="accession number">
            <xsl:value-of select="."/>
        </mods:identifier>
    </xsl:template>

    <!--(14) mods:relatedItem[@type='host']/mods:location. -->
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

    <!--(11) Omit toolkit note.  (19) mods:extentsion; (20) mods:recordInfo-->
    <xsl:template match="mods:note[@displayLabel='Digital object made available by ']">
        <mods:extension>
            <mods:localCollectionName>
                <xsl:value-of
                    select="translate(preceding-sibling::mods:relatedItem[@type='host']/mods:identifier,'.','')"
                />
            </mods:localCollectionName>
        </mods:extension>
        <mods:recordInfo>
            <mods:recordContentSource>Boston College</mods:recordContentSource>
            <mods:recordOrigin>Boston College/Archivists Toolkit Batch DAO</mods:recordOrigin>
            <mods:languageOfCataloging>
                <mods:languageTerm type="text">English</mods:languageTerm>
                <mods:languageTerm type="code" authority="iso639-2b">eng</mods:languageTerm>
            </mods:languageOfCataloging>
            <mods:descriptionStandard authority="marcdescription">dacs</mods:descriptionStandard>
        </mods:recordInfo>
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
            <xsl:attribute name="TYPE">
                <xsl:value-of select="@TYPE"/>
            </xsl:attribute>
            <xsl:attribute name="PROFILE">
                <xsl:value-of select="@PROFILE"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </mets:mets>
    </xsl:template>

    <!--Change note in mets:hdr-->
    <xsl:template match="mets:note[1]">
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:text>Produced by Archivists' Toolkit &#153; and modified using a local xslt</xsl:text>
        </xsl:element>
    </xsl:template>

    <!--Add amdsec with preservation md-->
    <xsl:template match="mets:fileSec">
        <mets:amdSec>
            <mets:digiprovMD ID="dp01">
                <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="preservation_md">
                    <mets:xmlData>
                        <premis xmlns="info:lc/xmlns/premis-v2"
                            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
                            xsi:schemaLocation="info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/premis.xsd">
                            <!-- premis file object -->
                            <object xsi:type="file">
                                <objectIdentifier>
                                    <objectIdentifierType>handle</objectIdentifierType>
                                    <objectIdentifierValue>
                                        <xsl:value-of
                                            select="normalize-space(substring(ancestor::mets:mets/@OBJID,23))"
                                        />
                                    </objectIdentifierValue>
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
                <xsl:number level="single" count="mets:file"/>
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
    <xsl:template match="mets:FLocat">
        <xsl:element name="{'mets:'}{local-name()}">
            <xsl:attribute name="LOCTYPE">URL</xsl:attribute>
            <xsl:attribute name="xlink:type">simple</xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="concat('file://streams/', @xlink:href)"/>
            </xsl:attribute>
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
        <xsl:element name="{'mets:'}{name()}">
            <!-- Redo @ORDER @LABEL @DMDID @TYPE on Top Level Div-->
            <xsl:attribute name="ORDER">
                <xsl:value-of select="@ORDER"/>
            </xsl:attribute>
            <xsl:attribute name="LABEL">
                <xsl:value-of
                    select="/mets:mets/mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:relatedItem/mods:identifier"
                />
            </xsl:attribute>
            <xsl:attribute name="DMDID">
                <xsl:value-of select="@DMDID"/>
            </xsl:attribute>
            <xsl:attribute name="TYPE">DAO</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mets:div/mets:div">
        <xsl:element name="{'mets:'}{name()}">
            <!-- Redo @ORDER @LABEL @TYPE On Second Level Div-->
            <xsl:attribute name="ORDER">
                <xsl:value-of select="@ORDER"/>
            </xsl:attribute>
            <xsl:attribute name="LABEL">
                <xsl:value-of select="@LABEL"/>
            </xsl:attribute>
            <xsl:attribute name="TYPE">DAOcomponent</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
