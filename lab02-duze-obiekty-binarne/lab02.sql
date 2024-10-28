-- Zadanie 1

create table movies 
    as select * from ztpd.movies;

-- Zadanie 2

describe movies;

-- Name      Null?    Type           
-- --------- -------- -------------- 
-- ID        NOT NULL NUMBER(12)     
-- TITLE     NOT NULL VARCHAR2(400)  
-- CATEGORY           VARCHAR2(50)   
-- YEAR               CHAR(4)        
-- CAST               VARCHAR2(4000) 
-- DIRECTOR           VARCHAR2(4000) 
-- STORY              VARCHAR2(4000) 
-- PRICE              NUMBER(5,2)    
-- COVER              BLOB           
-- MIME_TYPE          VARCHAR2(50)  

-- Zadanie 3

select id, title
    from movies
    where cover is null;

-- Zadanie 4

select id, title, dbms_lob.getlength(cover) filesize
    from movies
    where cover is not null;

-- Zadanie 5

select id, title, dbms_lob.getlength(cover) filesize
    from movies
    where cover is null;
-- Ostatnia kolumna ma wartości null

-- Zadanie 6

select directory_name, directory_path 
  from all_directories 
  where directory_name = 'TPD_DIR';

-- Zadanie 7

update movies 
    set cover     = empty_blob(), 
        mime_type = 'image/jpeg' 
    where id = 66;

-- Zadadnie 8

select id, title, dbms_lob.getlength(cover) filesize 
    from movies 
    where id in (65, 66);

-- Zadanie 9
DECLARE
    my_file BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
    my_blob BLOB;
BEGIN

    SELECT cover 
        INTO my_blob
        FROM movies
        WHERE id = 66
        FOR UPDATE;

    dbms_lob.fileopen(my_file);
    dbms_lob.loadfromfile(my_blob, my_file, dbms_lob.getlength(my_file));    
    dbms_lob.fileclose(my_file);

    COMMIT;
END;

-- Zadanie 10

create table temp_covers (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

-- Zadanie 11

insert into temp_covers 
    values(65, BFILENAME('TPD_DIR', 'escape.jpg'), 'image/jpeg');
commit;

-- Zadanie 12

select movie_id, dbms_lob.getlength(image) filesize 
    from temp_covers;

-- Zadanie 13

DECLARE
    my_image BFILE;
    tmp_lob BLOB;
    mime VARCHAR2(50);
BEGIN
    select image, mime_type
        into my_image, mime
        from temp_covers
        where movie_id = 65; 

    dbms_lob.createtemporary(tmp_lob, TRUE);

    dbms_lob.fileopen(my_image);
    dbms_lob.loadfromfile(tmp_lob, my_image, dbms_lob.getlength(my_image));    
    dbms_lob.fileclose(my_image);

    update movies 
        set cover = tmp_lob, 
            mime_type = mime 
        wheRE id = 65; 

    dbms_lob.freetemporary(tmp_lob);

    COMMIT;
END;

-- Zadanie 14

select id movie_id, dbms_lob.getlength(cover) filesize 
    from movies 
    where id in (65, 66);

-- Zadanie 15

DROP TABLE movies;
DROP TABLE temp_covers;
