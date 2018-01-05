<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gip="http://linuxcentre.net/xmlstuff/get_iplayer" exclude-result-prefixes="gip">
<xsl:output method="xml" indent="yes" />
<xsl:template match="gip:program_meta_data">
<episodedetails>
  <aired><xsl:value-of select="gip:lastbcastdate"/></aired>
  <episode><xsl:value-of select="gip:episodenum"/></episode>
  <genre><xsl:value-of select="gip:category"/></genre>
  <id><xsl:value-of select="gip:pid"/></id>
  <plot><xsl:value-of select="gip:desclong"/></plot>
  <season><xsl:value-of select="gip:seriesnum"/></season>
  <studio><xsl:value-of select="gip:channel"/></studio>
  <title><xsl:value-of select="gip:episodeshort"/></title>
  <thumb><xsl:value-of select="gip:thumbnail"/></thumb>
</episodedetails>
</xsl:template>
</xsl:stylesheet>
