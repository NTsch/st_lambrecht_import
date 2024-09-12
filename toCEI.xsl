<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!--run over each regest file, creates a corpus file out of it-->
    
    <xsl:template match='/'>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="teiHeader"/>
    
    <xsl:template match="text">
        <cei:cei>
            <cei:teiHeader>
                <cei:fileDesc>
                    <cei:titleStmt>
                        <cei:title>
                            <xsl:value-of select="substring-after(substring-before(base-uri(), '.xml'), 'xml/')"/>
                        </cei:title>
                        <cei:author/>
                    </cei:titleStmt>
                    <cei:publicationStmt>
                        <cei:p/>
                    </cei:publicationStmt>
                    <cei:sourceDesc>
                        <cei:p/>
                    </cei:sourceDesc>
                </cei:fileDesc>
            </cei:teiHeader>
            <cei:text>
                <cei:group>
                    <xsl:apply-templates select="//text/body//p[@rend='background-color(#ffff00)' or hi[@rend='background-color(#ffff00)']]"/>
                </cei:group>
            </cei:text>
        </cei:cei>
    </xsl:template>
    
    <xsl:template match="p[@rend='background-color(#ffff00)' or hi[@rend='background-color(#ffff00)']]">
        <xsl:variable name="pos" select="position()"/>
        <!--get every following sibling p without color and whose nearest predecessor headline is the current headline-->
        <xsl:variable name="regest">
            <cei:abstract>
                <!--<xsl:copy-of select="following-sibling::p[not(contains(@rend, 'background-color') or hi[contains(@rend, 'background-color')]) and count(preceding-sibling::p[contains(@rend, 'background-color') or hi[@rend='background-color(#ffff00)']]) = $pos]"/>-->
                <xsl:element name="cei:{local-name()}">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates select="following-sibling::p[not(contains(@rend, 'background-color') or hi[contains(@rend, 'background-color')]) and count(preceding-sibling::p[contains(@rend, 'background-color') or hi[@rend='background-color(#ffff00)']]) = $pos]"/>
                </xsl:element>
            </cei:abstract>
        </xsl:variable>
        <xsl:variable name="endline">
            <xsl:value-of select="tokenize($regest/cei:abstract, ' – ')[last()]"/>
        </xsl:variable>
        <xsl:variable name="idno">
            <xsl:analyze-string select="." regex="(I/\d+\w*)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="place">
            <xsl:analyze-string select="." regex=",([^,:]+)[:.]?\s*$">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:choose>
                <xsl:when test="$place != ''">
                    <xsl:value-of select="normalize-space(replace(replace(substring-after(substring-before(., $place), $idno), '^ *[–-]', ''), '[,–-]+ *$', ''))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(replace(replace(substring-after(., $idno), '^ *[–-]', ''), '[:,–-]+ *$', ''))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <cei:text type='charter'>
            <cei:front/>
            <cei:body>
                <cei:idno>
                    <xsl:value-of select="normalize-space($idno)"/>
                </cei:idno>
                <cei:chDesc>
                    <xsl:copy-of select="$regest"/>
                    <cei:issued>
                        <cei:date>
                            <xsl:value-of select="$date"/>
                        </cei:date>
                        <cei:place>
                            <xsl:value-of select="normalize-space($place)"/>
                        </cei:place>
                    </cei:issued>
                    <cei:witnessOrig>
                        <cei:traditioForm>
                            <xsl:value-of select="$endline"/>
                        </cei:traditioForm>
                    </cei:witnessOrig>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="p">
        <cei:p>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="hi">
        <cei:hi>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:hi>
    </xsl:template>
    <!--Siegel mit "S:", nicht verlässlich fett-->
    
</xsl:stylesheet>