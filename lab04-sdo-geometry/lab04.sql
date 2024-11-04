-- Zadanie 1.A

CREATE TABLE FIGURY (
    ID NUMBER(1) PRIMARY KEY, 
    KSZTALT MDSYS.SDO_GEOMETRY
);

-- Zadanie 1.B

INSERT INTO FIGURY 
VALUES (1, MDSYS.SDO_GEOMETRY(
    2003, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
    MDSYS.SDO_ORDINATE_ARRAY(5,7, 3,5, 5,3)
));

INSERT INTO FIGURY 
VALUES (2, MDSYS.SDO_GEOMETRY(
    2003, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 3),
    MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
));

INSERT INTO FIGURY 
VALUES (3, MDSYS.SDO_GEOMETRY(
    2002, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2),
    MDSYS.SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1)
));

-- Zadanie 1.C

INSERT INTO FIGURY 
VALUES (9, MDSYS.SDO_GEOMETRY(
    2003, NULL, NULL,
    MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
    MDSYS.SDO_ORDINATE_ARRAY(5,2, 5,3, 5,4)
));

-- Zadanie 1.D

SELECT 
    ID, 
    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT, 0.1) VAL 
FROM FIGURY;

-- Zadanie 1.E

DELETE FROM FIGURY 
    WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT, 0.1) <> TRUE;

-- Zadanie 1.F

COMMIT;