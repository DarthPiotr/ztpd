-- Operator CONTAINS - Podstawy


-- Zadanie 1
CREATE TABLE CYTATY AS
SELECT * FROM ZTPD.CYTATY;

-- Zadanie 2
SELECT *
FROM CYTATY
WHERE UPPER(TEKST) LIKE UPPER('%optymista%')
  AND UPPER(TEKST) LIKE UPPER('%pesymista%');

-- Zadanie 3
CREATE INDEX text_idx ON CYTATY(TEKST) 
    INDEXTYPE IS CTXSYS.CONTEXT;

-- Zadanie 4
SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'optymista and pesymista') > 0;

-- Zadanie 5
SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'pesymista not optymista') > 0;

-- Zadanie 6
SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'pesymista and optymista') > 0
  AND CONTAINS(TEKST, 'pesymista and optymista') < 3;

-- Zadanie 7
SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'pesymista and optymista') > 0
  AND CONTAINS(TEKST, 'pesymista and optymista') < 10;

-- Zadanie 8
SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%') > 0;

-- Zadanie 9
SELECT AUTOR, TEKST, CONTAINS(TEKST, 'życi%') DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%') > 0;

-- Zadanie 10
SELECT AUTOR, TEKST, CONTAINS(TEKST, 'życi%') AS DOPASOWANIE
FROM CYTATY
WHERE CONTAINS(TEKST, 'życi%') > 0
ORDER BY CONTAINS(TEKST, 'życi%') DESC
FETCH FIRST 1 ROWS ONLY;

-- Zadanie 11
SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'fuzzy(probelm)') > 0;

-- Zadanie 12
INSERT INTO CYTATY VALUES (39, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni
siebie, a ludzie rozsądni tacy pełni wątpliwości.');
COMMIT;

-- Zadanie 13
SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy') > 0;

-- Zadanie 14
SELECT token_text FROM DR$TEXT_IDX$I
WHERE token_text = 'GŁUPCY';

-- Zadanie 15
DROP INDEX text_idx;
CREATE INDEX text_idx ON CYTATY(TEKST) INDEXTYPE IS CTXSYS.CONTEXT;

-- Zadanie 16
SELECT token_text FROM DR$TEXT_IDX$I
WHERE token_text = 'GŁUPCY';

SELECT *
FROM CYTATY
WHERE CONTAINS(TEKST, 'głupcy') > 0;

-- Zadanie 17
DROP INDEX text_idx;
DROP TABLE CYTATY;

-- Zaawansowane indeksowanie i wyszukiwanie

-- Zadanie 1
CREATE TABLE QUOTES AS
SELECT * FROM ZTPD.QUOTES;

-- Zadanie 2
CREATE INDEX text_idx ON QUOTES(TEXT) INDEXTYPE IS CTXSYS.CONTEXT;

-- Zadanie 3
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'work') > 0;

SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, '$work') > 0;

SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'working') > 0;

SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, '$working') > 0;

-- Zadanie 4
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'it') > 0;

-- Zadanie 5
SELECT *
FROM CTX_STOPLISTS;

-- Zadanie 6
SELECT *
FROM CTX_STOPWORDS;

-- Zadanie 7
DROP INDEX text_idx;
CREATE INDEX text_idx ON QUOTES(TEXT) 
    INDEXTYPE IS CTXSYS.CONTEXT 
    PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

-- Zadanie 8
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'it') > 0;

-- Zadanie 9
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool and humans') > 0;

-- Zadanie 10
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'fool and computer') > 0;

-- Zadanie 11
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool and humans) WITHIN SENTENCE') > 0;

-- Zadanie 12
DROP INDEX text_idx;

-- Zadanie 13
begin
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;

-- Zadanie 14
CREATE INDEX group_idx ON QUOTES(TEXT) 
    INDEXTYPE IS CTXSYS.CONTEXT 
    PARAMETERS ('section group nullgroup');

-- Zadanie 15
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool and humans) WITHIN SENTENCE') > 0;

SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, '(fool and computer) WITHIN SENTENCE') > 0;

-- Zadanie 16
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans') > 0;

-- Zadanie 17
DROP INDEX group_idx;

begin
    ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m','printjoins', '-');
end;

CREATE INDEX lex_idx ON QUOTES(TEXT) 
    INDEXTYPE IS CTXSYS.CONTEXT 
    PARAMETERS ('LEXER lex_z_m');

-- Zadanie 18
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'humans') > 0;

-- Zadanie 19
SELECT *
FROM QUOTES
WHERE CONTAINS(TEXT, 'non\-humans') > 0;

-- Zadanie 20
DROP TABLE QUOTES;
BEGIN
    CTX_DDL.DROP_SECTION_GROUP('nullgroup');
    CTX_DDL.DROP_PREFERENCE('lex_z_m');
END;