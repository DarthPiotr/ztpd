-- Zadanie 1.A

INSERT INTO USER_SDO_GEOM_METADATA
VALUES ('FIGURY','KSZTALT', MDSYS.SDO_DIM_ARRAY(
    MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.01),
    MDSYS.SDO_DIM_ELEMENT('Y', 0, 8, 0.01) ),
    null
);

-- Zadanie 1.B

SELECT
    SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0)
FROM FIGURY;

-- Zadanie 1.C

CREATE INDEX indeks_figury ON FIGURY(KSZTALT) 
    INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- Zadanie 1.D

SELECT ID
    FROM FIGURY
    WHERE SDO_FILTER(
            KSZTALT, 
            SDO_GEOMETRY(2001, null, 
                SDO_POINT_TYPE(3, 3, null),
                null, null)
        ) = 'TRUE';

-- Wynik wskazuje, że wszystkie 3 figury zawierają punkt (3,3).
-- W rzeczywistości tylko kwadrat zawiera ten punkt.
-- Jest to spowodowane wykorzystaniem indeksu do estymacji kandydatów zawierających punkt.
-- Nie jest sprawdzane dokładne zawieranie punktu.

-- Zadanie 1.E

SELECT ID
    FROM FIGURY
    WHERE SDO_RELATE(
            KSZTALT, 
            SDO_GEOMETRY(2001, null, 
                SDO_POINT_TYPE(3, 3, null),
                null, null),
            'mask=ANYINTERACT'
        ) = 'TRUE';

-- Zadanie 2.A

SELECT GEOM FROM MAJOR_CITIES WHERE CITY_NAME = 'Warsaw';
SELECT 
    CITY_NAME MIASTO, 
    SDO_NN_DISTANCE(1) ODL
FROM MAJOR_CITIES
WHERE SDO_NN(GEOM, 
    SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(21.0118794, 52.2449452, NULL), NULL, NULL),
    'sdo_num_res=10 unit=km',1) = 'TRUE'
    AND CITY_NAME <> 'Warsaw';

-- Zadanie 2.B

SELECT CITY_NAME MIASTO
FROM MAJOR_CITIES
WHERE SDO_WITHIN_DISTANCE(GEOM,
    SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(21.0118794, 52.2449452, NULL), NULL, NULL),
    'distance=100 unit=km') = 'TRUE'
    AND CITY_NAME <> 'Warsaw';

-- Zadanie 2.C

SELECT B.CNTRY_NAME KRAJ, C.CITY_NAME
    FROM COUNTRY_BOUNDARIES B, MAJOR_CITIES C
    WHERE SDO_RELATE(C.GEOM, B.GEOM, 'mask=INSIDE') = 'TRUE'
      AND B.CNTRY_NAME = 'Slovakia';    

-- Zadanie 2.D

SELECT 
    B2.CNTRY_NAME PANSTWO, 
    SDO_GEOM.SDO_DISTANCE(B1.GEOM, B2.GEOM, 1, 'unit=km') ODL
FROM COUNTRY_BOUNDARIES B1, COUNTRY_BOUNDARIES B2
WHERE B1.CNTRY_NAME = 'Poland' 
  AND B2.CNTRY_NAME <> 'Poland'
  AND SDO_RELATE(B1.GEOM, B2.GEOM, 'mask=TOUCH') <> 'TRUE';

-- Zadanie 3.A

SELECT 
    B2.CNTRY_NAME PANSTWO, 
    SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B1.GEOM, B2.GEOM, 1), 1, 'unit=km') DLUGOSC
FROM COUNTRY_BOUNDARIES B1, COUNTRY_BOUNDARIES B2
WHERE B1.CNTRY_NAME = 'Poland' 
  AND B2.CNTRY_NAME <> 'Poland'
  AND SDO_RELATE(B1.GEOM, B2.GEOM, 'mask=TOUCH') = 'TRUE'
ORDER BY dlugosc desc;

-- Zadanie 3.B

SELECT CNTRY_NAME
    FROM COUNTRY_BOUNDARIES
    order by SDO_GEOM.SDO_AREA(GEOM, 1, 'unit=SQ_KM') DESC
    FETCH FIRST 1 ROWS ONLY

-- Zadanie 3.C

SELECT SDO_GEOM.SDO_AREA(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(C1.GEOM, C2.GEOM, 1)), 1, 'unit=SQ_KM') SQ_KM
FROM COUNTRY_BOUNDARIES B, MAJOR_CITIES C1, MAJOR_CITIES C2
WHERE SDO_RELATE(C1.GEOM, B.GEOM, 'mask=INSIDE') = 'TRUE'
    AND B.CNTRY_NAME = 'Poland'
    AND C1.CITY_NAME = 'Warsaw'
    AND C2.CITY_NAME = 'Lodz';

-- Zadanie 3.D

SELECT SDO_GEOM.SDO_UNION(B.GEOM, C.GEOM, 1).SDO_GTYPE GTYPE
FROM COUNTRY_BOUNDARIES B, MAJOR_CITIES C
WHERE B.CNTRY_NAME = 'Poland'
  AND C.CITY_NAME = 'Prague';

-- Zadanie 3.E

SELECT  C.CITY_NAME, B.CNTRY_NAME
FROM COUNTRY_BOUNDARIES B, MAJOR_CITIES C
ORDER BY SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(B.GEOM,1), C.GEOM, 1, 'unit=km')
FETCH FIRST 1 ROWS ONLY;

-- Zadanie 3.F

SELECT 
    R.NAME, 
    SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B.GEOM, R.GEOM, 1), 1, 'unit=km')) DLUGOSC
FROM COUNTRY_BOUNDARIES B, RIVERS R
WHERE SDO_RELATE(B.GEOM, R.GEOM, 'mask=ANYINTERACT') = 'TRUE'
  AND B.CNTRY_NAME = 'Poland'
GROUP BY R.NAME;