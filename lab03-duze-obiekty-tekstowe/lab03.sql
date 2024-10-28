set serveroutput on;

-- Zadanie 1

create table dokumenty (
    id number(12) primary key,
    dokument clob
);

-- Zadanie 2

DECLARE
    the_text CLOB;
BEGIN
    the_text := '';
    FOR i IN 1..10000 LOOP
        the_text := the_text || 'Oto tekst. ';
    END LOOP;
    INSERT INTO dokumenty 
        VALUES (1, the_text);
END;

-- Zadanie 3
SELECT * 
    FROM dokumenty;
SELECT UPPER(dokument) 
    FROM dokumenty;
SELECT LENGTH(dokument) 
    FROM dokumenty;
SELECT dbms_lob.getlength(dokument) 
    FROM dokumenty;
SELECT SUBSTR(dokument, 5, 1000) 
    FROM dokumenty;
SELECT dbms_lob.substr(dokument, 1000, 5) 
    FROM dokumenty;

-- Zadanie 4

INSERT INTO dokumenty 
    VALUES (2, EMPTY_CLOB());


-- Zadanie 5

INSERT INTO dokumenty
  VALUES (3, NULL);
COMMIT;

-- Zadanie 6

SELECT * 
    FROM dokumenty;
SELECT UPPER(dokument) 
    FROM dokumenty;
SELECT LENGTH(dokument) 
    FROM dokumenty;
SELECT dbms_lob.getlength(dokument) 
    FROM dokumenty;
SELECT SUBSTR(dokument, 5, 1000) 
    FROM dokumenty;
SELECT dbms_lob.substr(dokument, 1000, 5) 
    FROM dokumenty;

-- Zadanie 7

DECLARE
    lobd clob;
    fils BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;  
BEGIN
    SELECT dokument 
        INTO my_clob
        FROM dokumenty
        WHERE id = 2
        FOR UPDATE;

    dbms_lob.fileopen(my_file);
    dbms_lob.loadclobfromfile(lobd, fils, dbms_lob.getlength(fils), 
        doffset, soffset, 873, langctx, warn);    
    dbms_lob.fileclose(my_file);

    COMMIT;

    dbms_output.put_line(warn);
END;

-- Zadanie 8
UPDATE dokumenty 
    SET dokument = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt')) 
    WHERE id = 3;

-- Zadanie 9
SELECT * 
    FROM dokumenty;

-- Zadanie 10
SELECT ID, dbms_lob.getlength(dokument) 
    FROM dokumenty;

-- Zadanie 11
DROP TABLE dokumenty;

-- Zadanie 12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    my_clob IN OUT CLOB, 
    pattern VARCHAR2
) IS
    offset NUMBER := 1;
    plen NUMBER := LENGTH(pattern);
    rtxt VARCHAR2(32767);
BEGIN
    rtxt := RPAD('.', plen, '.');  
    LOOP
        offset := dbms_lob.INSTR(LOB_LOC  => my_clob, PATTERN  => pattern, OFFSET  => 1, NTH  => 1);
        EXIT WHEN offset = 0;                        
        dbms_lob.write(my_clob, plen, offset, rtxt);   
    END LOOP;          
    dbms_output.put_line(my_clob);   
END;
/
DECLARE
  my_clob CLOB := 'abrakadabra';
BEGIN
  CLOB_CENSOR(my_clob, 'abra');
END;
-- ....kad....

-- Zadanie 13
CREATE TABLE biographies AS 
    SELECT * FROM ztpd.biographies;
SELECT * 
    FROM biographies;
/
DECLARE
    bio CLOB;
BEGIN
    SELECT bio 
        INTO bio
        FROM biographies
        FOR UPDATE;

    CLOB_CENSOR(bio, 'Cimrman');
    COMMIT;
END;
/
SELECT * 
    FROM biographies;

-- Zadanie 14
DROP TABLE biographies;
