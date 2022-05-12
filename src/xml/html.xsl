<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:stx="https://spatext.clontz.org"
                exclude-result-prefixes="stx">

    <xsl:output method="html"/>

    <!-- kill undefined elements -->
    <xsl:template match="*"/>

    <!-- Normalize text() whitespace but don't completely trim beginning or end: https://stackoverflow.com/a/5044657/1607849 -->
    <xsl:template match="text()"><xsl:value-of select="translate(normalize-space(concat('&#x7F;',.,'&#x7F;')),'&#x7F;','')"/></xsl:template>

    <xsl:template match="/">
        <xsl:apply-templates select="stx:knowl"/>
    </xsl:template>

    <xsl:template match="stx:knowl">
        <div class="stx-knowl">
            <xsl:apply-templates select="stx:title[1]"/>
            <xsl:call-template name="knowl"/>
        </div>
    </xsl:template>

    <xsl:template match="stx:part">
        <li>
            <xsl:call-template name="knowl"/>
        </li>
    </xsl:template>

    <xsl:template name="knowl">
        <xsl:apply-templates select="stx:intro[1]"/>
        <xsl:choose>
            <xsl:when test="stx:part">
                <ol>
                    <xsl:apply-templates select="stx:part"/>
                </ol>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="stx:content[1]"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="stx:outtro[1]"/>
    </xsl:template>

    <xsl:template match="stx:title">
        <h3 class="stx-title">
            <xsl:apply-templates select="text()|stx:m|stx:q|stx:c"/>
        </h3>
    </xsl:template>

    <xsl:template match="stx:intro|stx:content">
        <xsl:apply-templates select="stx:p"/>
    </xsl:template>

    <xsl:template match="stx:outtro">
        <div class="stx-outtro">
            <xsl:apply-templates select="stx:p"/>
        </div>
    </xsl:template>

    <xsl:template name="parseDisplay">
        <xsl:apply-templates select="text()|stx:m|stx:me|stx:q|stx:c|stx:em|stx:url|stx:image"/>
    </xsl:template>

    <xsl:template match="stx:p">
        <p>
            <xsl:call-template name="parseDisplay"/>
        </p>
    </xsl:template>

    <xsl:template match="stx:m">
        <span class="math inline-math">
            <xsl:text>\(</xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>\)</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="stx:m[@mode='display']|stx:me">
        <span class="math display-math">
            <xsl:text>\[</xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>\]</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="stx:em">
        <em>
            <xsl:call-template name="parseDisplay"/>
        </em>
    </xsl:template>

    <xsl:template match="stx:c">
        <code>
            <xsl:value-of select="normalize-space(text())"/>
        </code>
    </xsl:template>

    <xsl:template match="stx:q">
        <xsl:text>"</xsl:text>
        <xsl:call-template name="parseDisplay"/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template match="stx:image">
        <img>
            <xsl:attribute name="src">
                <xsl:value-of select="@remote"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="@source"/>
            </xsl:attribute>
        </img>
    </xsl:template>

    <xsl:template match="stx:url[@href]">
        <xsl:choose>
            <xsl:when test=". != ''">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <xsl:call-template name="parseDisplay"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <xsl:value-of select="@href"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>