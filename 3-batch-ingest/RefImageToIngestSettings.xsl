<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns:info="info:lc/xmlns/premis-v2" exclude-result-prefixes="mets xlink mods info xsi"> 
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/mets:mets">
        <xb:ingest_settings xmlns:xb="http://com/exlibris/digitool/common/jobs/xmlbeans">
            <pretransformer_task_class/>
            <transformer_task
                class_name="com.exlibris.digitool.ingest.transformer.metsbased.MetsBasedTransformer"
                name="METS xml file and associated file stream(s)">
                <param name="multi_mets_upload" value="No"/>
                <param name="mets_file" value="mets.xml"/>
                <param name="downloadFiles" value=""/>
            </transformer_task>
            <tasks_chain name="bcimages">
                <task_settings task_name="TechnicalMetadataExtractor" name="Technical Metadata Extraction"
                    id="0">
                    <param name="text_md" value="xml,pdf,html,txt,doc,ram,sgm,htm"/>
                    <param name="image_niso" value="sid,tif,jpg,jpeg,jp2,j2k,jpf,gif,bmp"/>
                    <param name="audio_md" value="wav,mp3,mid"/>
                    <param name="video_md" value="avi,mpg"/>
                    <param name="Extension" value="jpg"/>
                    <param name="Overwrite" value="False"/>
                </task_settings>
                <task_settings task_name="Thumbnail" name="Thumbnail Creation" id="1">
                    <param name="Extension" value="jpg"/>
                </task_settings>
                <task_settings task_name="AttributeAssignment" name="Control section Attribute Assignment"
                    id="2">
                    <param name="Name1" value="usage_type"/>
                    <param name="Value1" value="VIEW_MAIN"/>
                    <param name="Name2" value=" "/>
                    <param name="Value2" value=""/>
                    <param name="Name3" value=" "/>
                    <param name="Value3" value=""/>
                    <param name="apply_to_parent_only" value="true"/>
                    <param name="extension" value=""/>
                    <param name="size" value=""/>
                </task_settings>
            </tasks_chain>
            <xsl:element name="ingest_task">
                <xsl:attribute name="name">
                    <xsl:value-of select="substring-after(mets:amdSec/mets:digiprovMD/mets:mdWrap/mets:xmlData/info:premis/info:object/info:objectIdentifier[info:objectIdentifierType='handle']/info:objectIdentifierValue,'/')"/>
                </xsl:attribute>
            </xsl:element>
            <auto_rollback>false</auto_rollback>            
        </xb:ingest_settings>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
