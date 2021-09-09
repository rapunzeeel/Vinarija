/* Formiranje trigera koji ce, nad tablemo Vino, obezbediti da se prilikom unosa nove torke , brisanja torke ili izmene vrednosti obelezja kiselosti, triger aktivira prilikom unosa bilo koje torke.
Ukoliko se radi o brisanju zabraniti ga. Ukoliko se radi o unosu vrsi se unos id vina koji je sledeci u sekvenceru bez obzira sta je korisnik uneo, 
a  ukoliko se radi o izmeni dozvoliti izmenu samo ako je nova vrednost kiseline vina izmedju 3.1 i 3.5 .*/

CREATE SEQUENCE seq_idv
INCREMENT BY 10
START WITH 160
NOCYCLE
CACHE 10;

CREATE OR REPLACE TRIGGER Trg_Vino
BEFORE INSERT OR DELETE OR UPDATE OF kis
ON VINO
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        SELECT seq_idv.NEXTVAL
        INTO :NEW.idv
        FROM SYS.DUAL;
    ELSIF DELETING THEN
         Raise_Application_Error(-20000, 'GRESKA: Vino se ne moze izbrisati.');
    ELSIF UPDATING('kis') THEN
        IF :NEW.kis < 3.1 THEN
            Raise_Application_Error(-20000, 'GRESKA: Kiselost vina mora biti veca od 3.1');
        ELSIF :NEW.kis > 3.5 THEN
            Raise_Application_Error(-20000, 'GRESKA: Kiselost vina mora biti manja od 3.5');
        ELSE
            INSERT INTO VINO(idv, idvin, nazv, vrv, podvr, godv, kis) VALUES(:OLD.idv, :OLD.idvin, :OLD.nazv, :OLD.vrv, :OLD.podvr, :OLD.godv, :NEW.kis);
        END IF;
    END IF;
END Trg_Vino;


insert into Vino values (SEQ_IDV.nextval,4, 'ICON CAMPANA RUBIMUS' , 'Crno', 'Merlot',2018, 3.5);
insert into Vino values (10,4, '4 konja debela' , 'Belo', 'Chardonnay',2018, 3.5);

DELETE Vino WHERE idv = 20 AND idvin = 4;
DELETE Vino WHERE idv = 30 AND idvin = 10;

UPDATE Vino SET kis = 3.0 WHERE idv = 50 AND idvin = 3;
UPDATE Vino SET kis = 3.9 WHERE idv = 60 AND idvin = 5;
