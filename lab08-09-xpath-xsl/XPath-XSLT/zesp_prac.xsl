<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- Lab 09 -->

    <xsl:template match="/">
      <html>
          <body>
              <!-- Zadanie 5 -->
              <h1> Zespoły: </h1>

              <!-- Zadanie 4 -->
<!--              <xsl:apply-templates select="ZESPOLY/ROW"/> -->

              <!-- Zadanie 6 -->
              <ol>
                  <!-- Zadanie 6.A -->
<!--                  <xsl:for-each select="ZESPOLY/ROW">-->
<!--                      <li><xsl:apply-templates select="NAZWA"/></li>-->
<!--                  </xsl:for-each>-->

                  <!-- Zadanie 6.B -->
<!--                  <xsl:apply-templates select="ZESPOLY/ROW" mode="Zadanie6-mode"/>-->

                  <!-- Zadanie 9 -->
                  <xsl:apply-templates select="ZESPOLY/ROW" mode="Zadanie9-mode"/>
              </ol>

              <!-- Zadanie 7 -->
              <xsl:apply-templates select="ZESPOLY/ROW" mode="Zadanie7-mode"/>


          </body>
      </html>
    </xsl:template>

    <!-- Zadanie 6.B -->
    <xsl:template match="ROW" mode="Zadanie6-mode">
        <li><xsl:value-of select="NAZWA"/></li>
    </xsl:template>

    <!-- Zadanie 7 -->
    <xsl:template match="ROW" mode="Zadanie7-mode">
<!--        <h2>NAZWA: <xsl:apply-templates select="NAZWA"/><br/>-->
<!--            ADRES: <xsl:apply-templates select="ADRES"/></h2>-->

        <!-- Zadanie 9 -->
        <h2 id="{ID_ZESP}">
            NAZWA: <xsl:value-of select="NAZWA"/><br/>
            ADRES: <xsl:value-of select="ADRES"/>
        </h2>

        <!-- Zadanei 14 -->
        <xsl:if test="count(PRACOWNICY/ROW)>0">
            <!-- Zadanie 8 -->
            <table border="black">
                <tr>
                    <th>Nazwisko</th>
                    <th>Etat</th>
                    <th>Zatudniony</th>
                    <th>Placa pod.</th>
                    <th>Id szefa</th>
                </tr>
                <xsl:apply-templates select="PRACOWNICY/ROW" mode="Zadanie8-mode">
                    <!-- Zadanie 10 -->
                    <xsl:sort select="NAZWISKO"/>
                </xsl:apply-templates>
            </table>
        </xsl:if>

        <!-- Zadanie 13 -->
        Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>

    </xsl:template>

    <xsl:template match="ROW" mode="Zadanie8-mode">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
<!--            <td><xsl:value-of select="ID_SZEFA"/></td>-->

            <!-- Zadanie 11 -->
            <td>
                <xsl:choose>
                    <xsl:when test="ID_SZEFA">
                        <xsl:value-of select="//PRACOWNICY/ROW[ID_PRAC = current()/ID_SZEFA]/NAZWISKO"/>
                    </xsl:when>

                    <!-- Zadanie 12 -->
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <!-- Zadanie 9 -->
    <xsl:template match="ROW" mode="Zadanie9-mode">
        <li><a href="#{ID_ZESP}"><xsl:value-of select="NAZWA"/></a></li>
    </xsl:template>

</xsl:stylesheet>