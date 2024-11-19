(: Lab 08 :)

(: ========= swiat.xml :)

(: Zadanie 28 :)
(:for $k in doc('file:///C:/Users/pmarc/Documents/Studia/_Mgr Semestr II/ztpd/lab08-xpath/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(.,'A')]:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(: Zadanie 29 :)
(:for $k in doc('file:///C:/Users/pmarc/Documents/Studia/_Mgr Semestr II/ztpd/lab08-xpath/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ:)
(:where substring($k/NAZWA, 1, 1) = substring($k/STOLICA, 1, 1):)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(: Zadanie 30 :)
(:for $k in doc('file:///C:/Users/pmarc/Documents/Studia/_Mgr Semestr II/ztpd/lab08-xpath/XPath-XSLT/swiat.xml')//KRAJ:)
(:where substring($k/NAZWA, 1, 1) = substring($k/STOLICA, 1, 1):)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(: ========= zesp_prac.xml :)
let $document := doc('file:///C:/Users/pmarc/Documents/Studia/_Mgr Semestr II/ztpd/lab08-xpath/XPath-XSLT/zesp_prac.xml')

(: Zadanie 31 :)
(:return $document:)

(: Zadanie 32 :)
(:return $document//NAZWISKO:)

(: Zadanie 33 :)
(:return $document/ZESPOLY/ROW[NAZWA = 'SYSTEMY EKSPERCKIE']//NAZWISKO/text():)

(: Zadanie 34 :)
(:return $document/ZESPOLY/ROW[ID_ZESP = '10']/PRACOWNICY/count(*):)

(: Zadanie 35 :)
(:return $document/ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA = '100']/NAZWISKO:)

(: Zadanie 36 :)
return sum($document//PRACOWNICY/ROW[ID_ZESP = //PRACOWNICY/ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP]/PLACA_POD)
