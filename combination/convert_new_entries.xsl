<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cei="http://www.monasterium.net/NS/cei" 
    xmlns:md="my_data"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:template match='/'>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:variable name="new_entries" select='doc("new_entries_to_add.xml")//md:id/text()'/>
    
    <xsl:template match="TEI">
        <cei:cei>
            <xsl:apply-templates select="//row[cell[@n='1' and text() = $new_entries]]"/>
        </cei:cei>
    </xsl:template>
    
    <xsl:template match="row[cell[@n='1']]">
        <cei:text type='charter'>
            <cei:front/>
            <cei:body>
                <!--idno-->
                <xsl:apply-templates select="cell[@n='1']"/>
                <cei:chDesc>
                    <!--abstract-->
                    <xsl:apply-templates select="cell[@n='17' and normalize-space() != '']"/>
                    <cei:issued>
                        <!--date / dateRange-->
                        <xsl:choose>
                            <xsl:when test="cell[@n='4'and not(normalize-space() = '')]">
                                <xsl:apply-templates select="cell[@n='4']"/>
                            </xsl:when>
                            <xsl:when test="cell[@n='8'and not(normalize-space() = '')]">
                                <xsl:apply-templates select="cell[@n='8']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <cei:date value='99999999'>99999999</cei:date>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--placeName-->
                        <xsl:apply-templates select="cell[@n='16' and normalize-space() != '']"/>
                    </cei:issued>
                    <cei:witnessOrig>
                        <!--traditioForm-->
                        <xsl:apply-templates select="cell[@n='33' and normalize-space() != '']"/>
                        <!--archIdentifier 28, 29 -> universal insert -->
                        <cei:physicalDesc>
                            <cei:material/>
                        </cei:physicalDesc>
                        <!--seal-->
                        <!--TODO: split individually-->
                        <cei:auth>
                            <xsl:apply-templates select="cell[@n='21' and normalize-space() != '']"/>
                            <xsl:apply-templates select="cell[@n='22' and normalize-space() != '']"/>
                        </cei:auth>
                        <!--images-->
                        <xsl:apply-templates select="cell[@n='2' and normalize-space() != '']"/>
                        <cei:archIdentifier>
                            <cei:arch>Stiftsarchiv St. Lambrecht</cei:arch>
                            <cei:settlement>St. Lambrecht</cei:settlement>
                            <cei:region>Styria</cei:region>
                            <cei:country>Austria</cei:country>
                        </cei:archIdentifier>
                    </cei:witnessOrig>
                    <cei:diplomaticAnalysis>
                        <!--listBibls-->
                        <xsl:apply-templates select="cell[@n='38' and normalize-space() != '']"/>
                        <xsl:apply-templates select="cell[@n='44' and normalize-space() != '']"/>
                    </cei:diplomaticAnalysis>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="cell[@n='1']">
        <cei:idno id="{text()}">
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="cell[@n='17']">
        <cei:abstract>
            <xsl:apply-templates/>
        </cei:abstract>
    </xsl:template>
    
    <xsl:template match="cell[@n='33']">
        <cei:traditioForm>
            <xsl:apply-templates/>
        </cei:traditioForm>
    </xsl:template>
    
    <xsl:template match="cell[@n='16']">
        <cei:placeName>
            <xsl:apply-templates/>
        </cei:placeName>
    </xsl:template>
    
    <xsl:template match="cell[@n='2']">
        <xsl:variable name="img-url" select="tokenize(text(), '\$')"/>
        <xsl:for-each select="$img-url">
            <cei:figure>
                <cei:graphic url="{.}"/>
            </cei:figure>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="cell[@n='4']">
        <cei:date value='{normalize-space()}'>
            <xsl:value-of select="preceding-sibling::cell[@n='3']/normalize-space()"/>
        </cei:date>
    </xsl:template>
    
    <xsl:template match="cell[@n='8']">
        <cei:dateRange from='{normalize-space()}' to='{following-sibling::cell[@n="9"]/normalize-space()}'>
            <xsl:value-of select="preceding-sibling::cell[@n='3']/normalize-space()"/>
        </cei:dateRange>
    </xsl:template>
    
    <xsl:template match="cell[@n='38']">
        <cei:listBiblRegest>
            <cei:bibl>
                <xsl:apply-templates/>
            </cei:bibl>
        </cei:listBiblRegest>
    </xsl:template>
    
    <xsl:template match="cell[@n='44']">
        <cei:listBiblEdition>
            <cei:bibl>
                <xsl:apply-templates/>
            </cei:bibl>
        </cei:listBiblEdition>
    </xsl:template>
    
    <xsl:template match="cell[@n='21' or @n='22']">
        <cei:sealDesc>
            <xsl:apply-templates/>
        </cei:sealDesc>
    </xsl:template>
    
</xsl:stylesheet>