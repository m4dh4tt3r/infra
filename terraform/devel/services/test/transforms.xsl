<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Identity transform -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Match CD-ROM disks and update the bus -->
  <xsl:template match="devices/disk[@device='cdrom']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="driver"/>
      <xsl:apply-templates select="source"/>
      <target dev="sdb" bus="sata"/>
      <xsl:apply-templates select="readonly | address"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
