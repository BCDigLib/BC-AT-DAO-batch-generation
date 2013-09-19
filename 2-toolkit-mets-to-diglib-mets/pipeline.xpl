<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:directory-list path="xml"/>
    <p:filter select="//c:file"/>
    <p:for-each name="iterate">
        <p:load>
            <p:with-option name="href" select="concat('xml/', /*/@name)"/>
        </p:load>
        <p:xslt>
            <p:input port="parameters">
                <p:empty/>
            </p:input>
            <p:input port="stylesheet">
                <p:document href="xsl/DonnellyScrapbook.xsl"/>
            </p:input>
        </p:xslt>
        <p:store>
            <p:with-option name="href" select="concat('results/', /*/@name)">
                <p:pipe port="current" step="iterate"/>
            </p:with-option>
        </p:store>
    </p:for-each>
</p:declare-step>
