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
    
    <xsl:template match="p[contains(@rend, 'background-color(#ffff00)') or hi[contains(@rend, 'background-color(#ffff00)')]]">
        <!--get the following sibling p without color-->
        <xsl:variable name="regest">
            <cei:abstract>
                <xsl:element name="cei:{local-name()}">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates select="following-sibling::p[not(contains(@rend, 'background-color(#ffff00)') or hi[contains(@rend, 'background-color(#ffff00)')])][1]"/>
                </xsl:element>
            </cei:abstract>
        </xsl:variable>
        <xsl:variable name="endline">
            <xsl:value-of select="tokenize(string-join($regest/cei:abstract//text()), ' – (?=.+S:)', ';j')[last()]"/>
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
                    <xsl:value-of select="normalize-space(replace(replace(substring-after(substring-before(., $place), $idno), '^ *[–\-]', ''), '[,–\-\s]+$', ''))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(replace(replace(substring-after(., $idno), '^ *[–\-]', ''), '[:,–\-\s]+$', ''))"/>
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
                            <xsl:if test="contains($endline, '– Or. Perg.')">
                                <xsl:text>Original</xsl:text>
                            </xsl:if>
                        </cei:traditioForm>
                        <cei:archIdentifier/>
                        <cei:physicalDesc>
                            <cei:material>
                                <xsl:if test="contains($endline, '– Or. Perg.')">
                                <xsl:text>Pergament</xsl:text>
                            </xsl:if>
                            </cei:material>
                        </cei:physicalDesc>
                        <cei:auth>
                            <cei:sealDesc>
                                <xsl:for-each select="tokenize(string-join($regest/cei:abstract//text()), 'S\d?:')[position() > 1]">
                                    <cei:seal>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </cei:seal>
                                </xsl:for-each>
                            </cei:sealDesc>
                        </cei:auth>
                    </cei:witnessOrig>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:variable name="endline-begin" select="count(.//text()[contains(., '– Or. Perg.')]/preceding-sibling::node())"/>
        <cei:p>
            <xsl:copy-of select="@*"/>
            <!--<xsl:apply-templates/>-->
            <xsl:for-each select="node()[position()&lt;=$endline-begin]">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="hi">
        <cei:hi>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:hi>
    </xsl:template>
    
</xsl:stylesheet>