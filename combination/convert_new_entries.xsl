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
            <cei:front>
                <!--listBiblRegest hier? 38 & 44-->
            </cei:front>
            <cei:body>
                <!--idno-->
                <xsl:apply-templates select="cell[@n='1']"/>
            </cei:body>
            <cei:chDesc>
                <!--abstract-->
                <xsl:apply-templates select="cell[@n='17']"/>
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
                    <xsl:apply-templates select="cell[@n='16']"/>
                </cei:issued>
                <cei:witnessOrig>
                    <!--traditioForm-->
                    <xsl:apply-templates select="cell[@n='33']"/>
                    <!--archIdentifier 28, 29-->
                    <cei:physicalDesc>
                        <cei:material/>
                    </cei:physicalDesc>
                    <!--seal (21, 22)-->
                    <!--images-->
                    <xsl:apply-templates select="cell[@n='2']"/>
                </cei:witnessOrig>
            </cei:chDesc>
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
    
</xsl:stylesheet>