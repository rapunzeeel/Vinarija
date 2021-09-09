 --svi radnici koji u svom imenu imaju slovo 'l'  i rade u vinariji sa zadatim imenom
SELECT jmbgr as "jmbg radnika",imer as "ime radnika", przr as "prezime radnika" 
FROM Radnik
WHERE imer LIKE '%l%'
INTERSECT
SELECT jmbgr,imer, przr FROM Radnik
WHERE jmbgr IN (SELECT jmbgr FROM vinrad vi, vinarija v WHERE  vi.idvi = v.idvi AND v.imevi LIKE 'Vinarija Zvonko Bogdan');


--prikaz jmbgr, imer, przr, radnika i imevi ime vinarije, radnici koji rade u vinariji u kojoj se proizvodi vise ili tacno 25000l vina 
SELECT DISTINCT r.jmbgr as "jmbg radnika", r.imer as "ime radnika", r.przr as "prezime radnika", v.imevi as "ime vinarije"
FROM radnik r 
INNER JOIN  vinrad vr ON r.jmbgr = vr.jmbgr 
INNER JOIN vinarija v ON vr.idvi = v.idvi 
INNER JOIN vinvin vi ON v.idvi = vi.idvi 
WHERE vi.kol >= 25000;


-- prikaz vinarija i broja vina koji se proizvodi u vinariji koji je veci od 1 i sortirano po broju proizvedenih vina
SELECT idvi as "id vinarije", COUNT(idv) as "broj proizvoda"
FROM vinvin 
GROUP BY idvi 
HAVING COUNT(idv)>1 
ORDER BY COUNT(idv);


--prikaz id vinarije, ime vinarije i prosecne kiselosti vina koje vinarija proizvodi
WITH vinarijaPodaci as (
SELECT vi.idvi, sum(v.kis) ukupna_kiselost, count(v.idv) broj_proizvoda 
FROM Vino v, Vinarija vi WHERE v.idvin = vi.idvi GROUP BY vi.idvi)
SELECT DISTINCT vi.idvi as "id vinarije", vi.imevi as "ime vinarije", round(vip.ukupna_kiselost/ vip.broj_proizvoda, 1) as "prosecna kiselost"
FROM Vinarija vi, vinarijaPodaci vip, Vino v
WHERE vi.idvi = v.idvin AND v.idvin = vip.idvi;


--prikazati sve vinarije i vina koja se prozvode u vinarijama, ukoliko postoje vinarije koje ne proizvode nijedno vino treba zameniti sa 'ne postoji' 
--(uneta vrednost je za naziv, vrstu i podvrstu), sortirano po imenima vinarija
CREATE VIEW sve_vinarije (imevi, vlvi, nazv, podvr, vrv) as
SELECT v.imevi as "ime vinarije", v.vlvi as "vlasnik vinarije", NVL(vi.nazv, 'Ne postoji') as "naziv vina", NVL(vi.podvr, 'Ne postoji') as "podvrsta vina" ,NVL(vi.vrv, 'Ne postoji') as "vrsta vina"
FROM vinarija v 
LEFT OUTER JOIN vino vi ON vi.idvin = v.idvi
ORDER BY v.imevi;





