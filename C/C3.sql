--ogranicenje za tip radnika da moze biti enolog ili menadzer
ALTER TABLE RADNIK ADD CONSTRAINT tip_radnika CHECK (tipr IN ('Enolog', 'Menadzer'));
--ogranicenje za vrstu vina da moze biti belo ili crno
ALTER TABLE Vino ADD CONSTRAINT vrsta_vina CHECK (vrv IN ('Belo', 'Crno'));


--povecanje kolicine proizvodnje vina za 8500l ukoliko je vrsta vina belo vino
UPDATE vinvin SET kol = kol + 8500
WHERE idv IN (SELECT vi.idv FROM vino v, vinvin vi
WHERE v.idv = vi.idv AND v.vrv = 'Belo');
--povecanje plate za radnike koji rade u vinarijama koje proizvode vise ili tacno 30000 l vina
UPDATE Radnik SET plt = plt * 1.1 
WHERE jmbgr IN (SELECT r.jmbgr FROM radnik r, vinrad vr, vinarija v
WHERE r.jmbgr = vr.jmbgr AND vr.idvi = v.idvi AND v.idvi IN (SELECT v.idvi FROM vinvin vi, vinarija v
WHERE vi.idvi = v.idvi AND vi.kol>=30000));
COMMIT;

--prikaz vina koji u svom nazivu sadrze slovo n, sortirano po godini proizvodnje
SELECT idv, nazv, vrv, podvr, godv FROM Vino WHERE nazv LIKE 'N%' OR nazv LIKE '%n%' ORDER BY godv;