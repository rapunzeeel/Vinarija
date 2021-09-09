/*PL/SQL izvestaj vina koji se nalaze u odredjenim vinarija. Vrsi se unos minimalnog broja proizvoda koji vinarija treba da proizvede. 
Izlistavaju se sve vinarije koje proizvode isti ili veci broj porizvoda od unetog. 
Zatim se za svaku vinariju izlistavaju proizvodi odnosno vina koja se u njoj proizvode.*/

ACCEPT v_min_vrednost PROMPT 'Unesite donju granicu broja proizvoda: '
DECLARE
    v_min_vrednost INTEGER;
    
    TYPE T_Vino IS TABLE OF VINO.IDV%TYPE INDEX BY BINARY_INTEGER;
    TYPE T_VinVin IS RECORD(VinoPodaci VINO%ROWTYPE, Vina T_Vino);
    Type T_VinaVinarije IS TABLE OF T_VinVin INDEX BY BINARY_INTEGER;
    TabelaVinaVinarije T_VinaVinarije;
    
    TYPE T_Vinarija IS TABLE OF VINARIJA.IDVI%TYPE INDEX BY BINARY_INTEGER;
    TYPE T_Vin_Slog IS RECORD (VinarijaPodaci VINARIJA%ROWTYPE, Vinarije T_Vinarija);
    TYPE T_ProizvodiVinarije IS TABLE OF T_Vin_Slog INDEX BY BINARY_INTEGER;
    TabelaProizvodiVinarije T_ProizvodiVinarije;
    
    CURSOR vina IS SELECT * FROM Vino;
    CURSOR vinaVinarije(idVina Vino.idv%TYPE) IS SELECT v.idv FROM Vino v, Vinarija vi WHERE v.idvin = vi.idvi AND vi.idvi = idVina;
    
    CURSOR vinarije IS SELECT * FROM Vinarija;
    CURSOR brojProizvoda(idVinarije Vinarija.idvi%TYPE) IS SELECT count(v.idv) FROM Vino v, Vinarija vi WHERE v.idvin = vi.idvi AND vi.idvi = idVinarije;
    
    i BINARY_INTEGER :=0;
    j BINARY_INTEGER :=1;
    m BINARY_INTEGER :=0;
BEGIN 
    FOR vinarija in vinarije LOOP
        TabelaProizvodiVinarije(i).VinarijaPodaci := vinarija;
        m := 0;
        FOR vino in vina LOOP
            IF vinarija.idvi = vino.idvin THEN
                m := m + 1;
            END IF;
        END LOOP;
        TabelaProizvodiVinarije(i).Vinarije(i) := m;
        i := i + 1;
    END LOOP;
            
    FOR jednoVino in vina LOOP
        TabelaVinaVinarije(i).VinoPodaci := jednoVino;
        FOR vino in vinaVinarije(jednoVino.idvin) LOOP
            TabelaVinaVinarije(i).Vina(j) := vino.idv;
            j := j + 1;
        END LOOP;
        i := i + 1;
    END LOOP;
    
    i := TabelaProizvodiVinarije.FIRST;
    WHILE i <= TabelaProizvodiVinarije.LAST LOOP
        j:=TabelaProizvodiVinarije(i).Vinarije.FIRST;
         WHILE j <= TabelaProizvodiVinarije(i).Vinarije.LAST LOOP
            IF TabelaProizvodiVinarije(i).Vinarije(j) >= &&v_min_vrednost THEN
                DBMS_OUTPUT.PUT_LINE('---------------- Vinarija ----------------');
                DBMS_OUTPUT.PUT_LINE('id vinarije:' || TabelaProizvodiVinarije(i).VinarijaPodaci.idvi);
                DBMS_OUTPUT.PUT_LINE('ime vinarije:' || TabelaProizvodiVinarije(i).VinarijaPodaci.imevi);
                DBMS_OUTPUT.PUT_LINE('___________________________________________');
                m := TabelaVinaVinarije.FIRST;
                WHILE m <= TabelaVinaVinarije.LAST LOOP
                    IF TabelaVinaVinarije(m).VinoPodaci.idvin = TabelaProizvodiVinarije(i).VinarijaPodaci.idvi THEN
                        DBMS_OUTPUT.PUT_LINE('Naziv vina: ' || TabelaVinaVinarije(m).VinoPodaci.nazv);
                        DBMS_OUTPUT.PUT_LINE('Vrsta vina: ' || TabelaVinaVinarije(m).VinoPodaci.vrv);
                        DBMS_OUTPUT.PUT_LINE('Podvrsta vina: ' || TabelaVinaVinarije(m).VinoPodaci.podvr);
                        DBMS_OUTPUT.PUT_LINE('Godina proizvodnje vina: ' || TabelaVinaVinarije(m).VinoPodaci.godv);
                        DBMS_OUTPUT.PUT_LINE('Kiselost vina: ' || TabelaVinaVinarije(m).VinoPodaci.kis);
                        DBMS_OUTPUT.PUT_LINE('__________________________________________');
                    END IF;
                    m:=TabelaVinaVinarije.NEXT(m);
                END LOOP;
            END IF;
            j := TabelaProizvodiVinarije(i).Vinarije.NEXT(j);
        END LOOP;
        i :=TabelaProizvodiVinarije.NEXT(i);
    END LOOP;
END;
