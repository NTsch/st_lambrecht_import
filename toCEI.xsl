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
        <xsl:variable name="full_text" select="following-sibling::p[not(contains(@rend, 'background-color(#ffff00)') or hi[contains(@rend, 'background-color(#ffff00)')]) and generate-id(preceding-sibling::p[contains(@rend, 'background-color(#ffff00)') or hi[contains(@rend, 'background-color(#ffff00)')]][1]) = generate-id(current())]"/>
        <!--get all following siblings p until the next one that is marked with color-->
        <xsl:variable name="regest">
            <cei:abstract>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates select="$full_text"/>
            </cei:abstract>
        </xsl:variable>
        
        <!--only make charters for regests that actually have content, and not just "Inhalt?"-->
        <xsl:if test="not($regest[//text()[matches(., 'Inhalt\s*\?')]])">
            <xsl:call-template name="regest_with_content">
                <xsl:with-param name="regest" select="$regest"/>
                <xsl:with-param name="full_text" select="$full_text"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="regest_with_content">
        <xsl:param name="regest"/>
        <xsl:param name="full_text"/>
        <xsl:variable name="endline">
            <xsl:value-of select="tokenize(string-join($regest/cei:abstract//text()), ' – (?=.+S:)', ';j')[last()]"/>
        </xsl:variable>
        <xsl:variable name="idno">
            <xsl:analyze-string select="." regex="(I+/\d+[\sa-zA-Zαβγ/]*\d?)\s?(\([!?sic]+\)\s?)?[-–]">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(regex-group(1))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="place">
            <!--don't include \. in the exception for group 1, it eliminates e.g. St. Lambrecht-->
            <xsl:analyze-string select="." regex=",([^,:]+)[:\.]?\s*[^\-]*$">
                <xsl:matching-substring>
                    <xsl:value-of select="replace(regex-group(1), '\.$', '')"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:choose>
                <xsl:when test="$place != ''">
                    <xsl:value-of select="normalize-space(replace(replace(substring-after(substring-before(., $place), $idno), '^\s*[–\-]', ''), '[,–\-\s]+$', ''))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(replace(replace(substring-after(., $idno), '^\s*[–\-]', ''), '[:,–\-\s]+$', ''))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <cei:text type='charter'>
            <cei:front/>
            <cei:body>
                <xsl:choose>
                    <xsl:when test="$idno != ''">
                        <cei:idno id="{normalize-space($idno)}">
                            <xsl:value-of select="normalize-space($idno)"/>
                        </cei:idno>
                    </xsl:when>
                    <xsl:otherwise>
                        <cei:idno id="{concat(./base-uri(), '_', position())}">
                            <xsl:value-of select="concat(./base-uri(), '_', position())"/>
                        </cei:idno>
                    </xsl:otherwise>
                </xsl:choose>
                <cei:chDesc>
                    <xsl:copy-of select="$regest"/>
                    <cei:issued>
                        <cei:date>
                            <xsl:attribute name="value">
                                <xsl:variable name='year'>
                                    <xsl:analyze-string select="$date" regex="(\d{{4}})">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(1)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:variable>
                                <xsl:variable name='month'>
                                    <xsl:analyze-string select="$date" regex="\s([IVX]+)\b" flags="!">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1))"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:variable>
                                <xsl:variable name='day'>
                                    <xsl:analyze-string select="$date" regex="\s(\d\d)\b" flags="!">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1))"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$year != ''">
                                        <xsl:value-of select="substring($year, 1, 4)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>9999</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="$month = 'I'">
                                        <xsl:text>01</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'II'">
                                        <xsl:text>02</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'III'">
                                        <xsl:text>03</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'IV'">
                                        <xsl:text>04</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'V'">
                                        <xsl:text>05</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'VI'">
                                        <xsl:text>06</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'VII'">
                                        <xsl:text>07</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'VIII'">
                                        <xsl:text>08</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'IX'">
                                        <xsl:text>09</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'X'">
                                        <xsl:text>10</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'XI'">
                                        <xsl:text>11</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$month = 'XII'">
                                        <xsl:text>12</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>99</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="matches(normalize-space($day), '\d{2}')">
                                        <xsl:value-of select="substring($day, 1, 2)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>99</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:value-of select="$date"/>
                        </cei:date>
                        <cei:placeName>
                            <xsl:value-of select="normalize-space($place)"/>
                        </cei:placeName>
                    </cei:issued>
                    <xsl:choose>
                        <xsl:when test="matches(string-join($full_text//text()), '– \d Or. P')">
                            <xsl:variable name="num_charts">
                                <xsl:analyze-string select="string-join($full_text//text())" regex="– (\d) Or. P">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="xs:integer(regex-group(1))"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:variable>
                            <cei:witListPar>
                                <xsl:for-each select="1 to $num_charts">
                                    <cei:witness n="{position()}">
                                        <cei:archIdentifier/>
                                        <cei:traditioForm>
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                    <xsl:text>Original</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>Abschrift</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </cei:traditioForm>
                                        <cei:physicalDesc>
                                            <cei:material>
                                                <xsl:choose>
                                                    <xsl:when test="contains(string-join($full_text//text()), 'Or. Perg')">
                                                        <xsl:text>Pergament</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="contains(string-join($full_text//text()), 'Or. Pap')">
                                                        <xsl:text>Papier</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </cei:material>
                                        </cei:physicalDesc>
                                        <cei:auth>
                                            <cei:sealDesc>
                                                <xsl:for-each select="tokenize(string-join($full_text//text()), 'S\d?:')[position() > 1]">
                                                    <cei:seal>
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                    </cei:seal>
                                                </xsl:for-each>
                                            </cei:sealDesc>
                                        </cei:auth>
                                    </cei:witness>
                                </xsl:for-each>
                            </cei:witListPar>
                        </xsl:when>
                        <xsl:otherwise>
                            <cei:witnessOrig>
                             <cei:traditioForm>
                                 <xsl:if test="contains($endline, '– Or. P')">
                                     <xsl:text>Original</xsl:text>
                                 </xsl:if>
                             </cei:traditioForm>
                             <cei:archIdentifier/>
                             <cei:physicalDesc>
                                 <cei:material>
                                     <xsl:choose>
                                         <xsl:when test="contains($endline, '– Or. Perg')">
                                             <xsl:text>Pergament</xsl:text>
                                         </xsl:when>
                                         <xsl:when test="contains($endline, '– Or. Pap')">
                                             <xsl:text>Papier</xsl:text>
                                         </xsl:when>
                                     </xsl:choose>
                                 </cei:material>
                             </cei:physicalDesc>
                             <cei:auth>
                                 <cei:sealDesc>
                                     <xsl:for-each select="tokenize(string-join($full_text//text()), 'S\d?:')[position() > 1]">
                                         <cei:seal>
                                             <xsl:value-of select="normalize-space(.)"/>
                                         </cei:seal>
                                     </xsl:for-each>
                                 </cei:sealDesc>
                             </cei:auth>
                            </cei:witnessOrig>
                        </xsl:otherwise>
                    </xsl:choose>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test=".[text()[contains(., ' – ') and not(./following-sibling::text()[contains(., ' – ')])]]">
                <!--get all text before the endline after " – ", usually followed by "Org. P"-->
                <xsl:variable name="endline-begin" select="count(.//text()[contains(., ' – ') and not(./following-sibling::text()[contains(., ' – ')])]/preceding-sibling::node())"/>
                <xsl:copy-of select="@*"/>
                <xsl:for-each select="node()[position() &lt;= $endline-begin]">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
                <xsl:analyze-string select="node()[position() = $endline-begin + 1]" regex="([\s\S]+)–">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="hi">
        <cei:hi>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:hi>
    </xsl:template>
    
</xsl:stylesheet>