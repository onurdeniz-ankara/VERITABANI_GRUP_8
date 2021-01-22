/*SEQUENCE YARATILIÞI*/
create sequence staff_artis
START WITH 1
INCREMENT BY 1;
create  sequence islem_artis
START WITH 1
INCREMENT BY 1;
create sequence yonetici_artis
START WITH 1
INCREMENT BY 1;


/*TABLO YARATILIÞI*/
create table staff(staffid int DEFAULT staff_artis.nextval not null,
                   staffsifre varchar(15) not null,
                   staffname varchar(15) not null,
                   stafflastname varchar(20) not null,
                   DOGT date not null,
                   TCNO int UNIQUE not null,
                   stafftelefon varchar(20) not null,
                   staffmaas int not null,
                   CONSTRAINT staff_primary PRIMARY KEY(staffid)
                   );
create table stok (kahvecekirdekleri varchar(25) not null,
                   cekirdekmiktarlari number(6,0) not null,
                   CONSTRAINT stok_cekirdek PRIMARY KEY(kahvecekirdekleri)
                   );
create table islem(islemno int DEFAULT islem_artis.nextval not null,
                   islemgeliri number(6,2) not null,
                   kullanilancekirdek varchar(25) not null,
                   cekirdekmiktari number(6,0) not null,
                   staffid int not null,
                   islem_tarih date default to_date(sysdate,'DD/MM/YYYY') not null,
                   CONSTRAINT islem_staffid FOREIGN KEY (staffid) REFERENCES staff(staffid),
                   CONSTRAINT islem_islemno PRIMARY KEY (islemno),
                   CONSTRAINT islem_cekirdek FOREIGN KEY (kullanilancekirdek) REFERENCES  stok(kahvecekirdekleri)
                   );
create table yonetici(yoneticiid int DEFAULT staff_artis.nextval not null,
                   yoneticisifre varchar(15) not null,
                   yoneticiname varchar(15) not null,
                   yoneticilastname varchar(20) not null,
                   YDOGT date not null, 
                   YTCNO int UNIQUE not null,
                   yoneticitelefon varchar(20) not null,
                   yoneticimaas int not null,
                   CONSTRAINT yonetici_primary PRIMARY KEY(yoneticiid)
                   );
create table gelir(gun date default sysdate not null,
                   gelir number(8,2)
                   );
/*TRÝGGER YARATILIÞI*/
create or replace TRIGGER TRIGGER1 
AFTER INSERT ON ISLEM 
FOR EACH ROW
DECLARE
kahve varchar(20);
BEGIN
  UPDATE STOK 
SET
 cekirdekmiktarlari = cekirdekmiktarlari - 7
 where
 kahvecekirdekleri = :new.KULLANILANCEKIRDEK;
END;

/*PROCEDURE YARATILIÞI*/
create or replace PROCEDURE GUNGELIR AS 
gelir number(6,2);

BEGIN
   select SUM(ISLEMGELIRI)INTO gelir from ISLEM WHERE ISLEM_TARIH=to_date(sysdate,'DD/MM/YYYY');
   INSERT INTO GELIR VALUES(to_date(sysdate,'DD/MM/YYYY'),gelir);
END GUNGELIR;




create or replace PROCEDURE yonetici_maas AS
BEGIN
 UPDATE YONETICI
 SET
 YONETICIMAAS = 1.1* YONETICIMAAS;
END;




create or replace PROCEDURE staff_maas AS
BEGIN
 UPDATE staff
 SET
 STAFFMAAS = 1.04 * STAFFMAAS;
END;
drop table gelir;drop table islem;drop table staff;drop table stok;drop table yonetici;

                   