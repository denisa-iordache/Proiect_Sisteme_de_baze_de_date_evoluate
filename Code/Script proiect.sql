--CERERI IERARHICE
--1. Sa se afiseze numele angajatilor care nu au subalterni si care au aceeasi functie ca angajatul Popescu, 
--denumirea functiei, denumirea departamentului si nivelul ierarhic.
select a.nume, f.denumire_functie, d.denumire_departament, level, connect_by_isleaf
from angajati_banca a, departamente_banca d, functii_angajati f
where a.id_departament=d.id_departament
and a.id_functie=f.id_functie
and connect_by_isleaf=1
connect by prior a.id_angajat = a.id_manager 
start with a.id_functie=(select id_functie from angajati_banca where nume='Popescu');

--2. Sa se afiseze numele, prenumele, departamentul si nivelul ierarhic pentru subordonatii lui Ionescu Andrei daca acestia se incadreaza in top 3 cele mai mici salarii din firma.
select a.nume, a.prenume, d.denumire_departament, level
from angajati_banca a, departamente_banca d
where a.id_departament=d.id_departament
and a.salariu in (select salariu from (select salariu from angajati_banca order by salariu asc) where rownum<=3)
connect by prior a.id_angajat = a.id_manager 
start with a.nume='Ionescu' and a.prenume='Andrei';

--3. Sa se afiseze superiorii Cristinei Micu sub forma ierarhica (lpad) si sub forma de cale daca acestia au salariul mai mare sau egal cu al ei sau sunt angajati dupa ea.
select level, lpad(' ', level*2)|| nume || ' ' || prenume || ' are salariul ' || salariu || ' si este mai mare cu ' || (salariu - (select salariu from angajati_banca where nume = 'Micu' and prenume = 'Cristina')) || ' lei decat al Cristinei Micu' angajat
from angajati_banca
where salariu > (select salariu from angajati_banca where nume = 'Micu' and prenume = 'Cristina')
or data_angajarii>(select data_angajarii from angajati_banca where nume = 'Micu' and prenume = 'Cristina')
connect by id_angajat= prior id_manager
start with nume='Micu' and prenume='Cristina'
order by level;

select nume || ' ' || prenume || ' are salariul ' || salariu || ' si este mai mare cu ' || (salariu - (select salariu from angajati_banca where nume = 'Micu' and prenume = 'Cristina')) || ' lei decat al Cristinei Micu' angajat,
sys_connect_by_path(nume, '/') cale
from angajati_banca
where salariu > (select salariu from angajati_banca where nume = 'Micu' and prenume = 'Cristina')
or data_angajarii>(select data_angajarii from angajati_banca where nume = 'Micu' and prenume = 'Cristina')
connect by id_angajat= prior id_manager
start with nume='Micu' and prenume='Cristina';

--4. Sa se afiseze subalternii Denisei Iordache care functia Functionar.
select a.nume, a.prenume, f.denumire_functie, level
from angajati_banca a, functii_angajati f
where a.id_functie=f.id_functie
and f.denumire_functie='Functionar'
connect by prior a.id_angajat = a.id_manager 
start with a.nume='Iordache' and a.prenume='Denisa'

--Interogari cu diverse tipuri de jonctiuni, subcereri, agregari
--1. Sa se afiseze cat % din nr de angajati sunt in fiecare departament si cat % din fondul de salarii ii revine fiecarui departament din total salarii.
select id_departament, trunc(nr_ang_dep*100/nr_ang_tot,2) "% nr angajati", trunc(sum_sal_dep*100/sum_sal_tot,2) "% salarii"
from(select id_departament, count(id_angajat) nr_ang_dep, sum(salariu) sum_sal_dep
from angajati_banca group by id_departament),
(select count(id_angajat)nr_ang_tot , sum(salariu) sum_sal_tot from angajati_banca)
order by 2 desc;

--2. Sa se calculeze valoarea comisionului pe care il primesc angajatii astfel : cei care au incheiat mai putin sau 6 contracte : 
--0,05% din salariu, cei care au incheiat 7 contracte: 0,06% din salariu, iar cei care au incheiat mai mult de 7: 0,07% din salariu.
SELECT a.nume, COUNT(c.id_contract) numar_contracte,
0.0005* SUM(c.valoare_credit) valoare_comision
FROM angajati_banca a, contracte_clienti c
WHERE a.id_angajat=c.id_angajat
GROUP BY a.nume
HAVING COUNT(c.id_contract) <= 6
UNION 
SELECT a.nume, COUNT(c.id_contract) numar_contracte,
0.0006* SUM(c.valoare_credit) valoare_comision
FROM angajati_banca a, contracte_clienti c
WHERE a.id_angajat=c.id_angajat
GROUP BY a.nume
HAVING COUNT(c.id_contract) = 7
UNION
SELECT a.nume, COUNT(c.id_contract) numar_contracte,
0.0007* SUM(c.valoare_credit) valoare_comision
FROM angajati_banca a, contracte_clienti c
WHERE a.id_angajat=c.id_angajat
GROUP BY a.nume
HAVING COUNT(c.id_contract) > 7;

--3. Sa se afiseze denumirea departamentului, salariul minim si maxim si numarul de angajati care fac parte din el, indiferent daca are sau nu angajati, in ordine descrescatoare a numarului de angajati.
select d.denumire_departament, min(a.salariu) salariu_minim, max(a.salariu) salariu_maxim, count(a.id_angajat) numar_angajati
from departamente_banca d, angajati_banca a
where d.id_departament=a.id_departament (+)
group by d.denumire_departament
order by numar_angajati desc;

--4. Sa se se perceapa comisionul de 2% pentru operatiunea de „Retragere numerar” ce are atribuit un card.
SELECT o.id_card, tip_operatiune, suma,
DECODE(tip_operatiune , 'Retragere numerar',2, 0) || '%' procent_comision,
DECODE(tip_operatiune , 'Retragere numerar',0.02*suma, 0) || ' lei' valoare_comision
FROM operatiuni_card o
where exists
(select c.id_card from card_de_credit c where c.id_card = o.id_card);

--5. Sa se afiseze angajatii care au incheiat contracte de credit in primul an in care Popescu Andreeea a incheiat contracte.
SELECT a.nume, a.prenume, c.data_semnare, a.salariu FROM angajati_banca a, contracte_clienti c
where a.id_angajat=c.id_angajat
and EXTRACT(year from data_semnare) = 
(SELECT EXTRACT(YEAR FROM c.data_semnare) FROM angajati_banca a, contracte_clienti c 
where a.id_angajat=c.id_angajat
and nume='Popescu' and prenume='Andreea'
and rownum<=1);

--6. Sa se afiseze departamentele fara salariati care fac parte fie din sucursala F sau I.
select d.id_departament, d.denumire_departament, s.denumire_sucursala 
from departamente_banca d, sucursale_banca s
where d.id_sucursala=s.id_sucursala
and d.id_departament not in
(select id_departament from angajati_banca 
group by id_departament
having count(id_departament) >= 1)
and s.denumire_sucursala in ('Sucursala BT F', 'Sucursala BT I');

--7. Sa se afiseze angajatii angajati dupa anul 2020 care nu au incheiat contracte de credit cu clientii.
select nume, prenume, data_angajarii
from angajati_banca a, contracte_clienti c
where a.id_angajat = c.id_angajat(+)
and extract(year from data_angajarii)>=2020
minus
select nume, prenume, data_angajarii
from angajati_banca a, contracte_clienti c
where a.id_angajat(+) = c.id_angajat
and extract(year from data_angajarii)>=2020

--8.Sa se afiseze din tabela ANGAJATI_BANCA numele cu majuscule, prenumele cu litera mare la inceput, id_departament si denumirea departamentului cu litere mici unde salariu>=3000
select distinct upper(a.nume), initcap(a.prenume), a.id_departament, lower(denumire_departament)
from angajati_banca a, departamente_banca d
where a.id_departament=d.id_departament
and a.id_departament not in(select id_departament from angajati_banca where salariu <3000);

--Interogari cu functii analitice
--1.Sa se afle valoarea minima, medie si maxima a creditelor incheiate de angajatul Popescu cu valoarea mai mica sau egala decat cel curent (pentru minim), mai mare sau egala decat cel curent (pentru maxim si medie)
select a.nume, id_contract, valoare_credit, min(valoare_credit) 
over (partition by a.nume
order by valoare_credit rows between unbounded preceding and current row ) val_min, max(valoare_credit) over 
(partition by a.nume
order by valoare_credit rows between current row and unbounded following) val_max, avg(valoare_credit) over 
(partition by a.nume
order by valoare_credit rows between current row and unbounded following) val_medie
from contracte_clienti c, angajati_banca a
where a.id_angajat=c.id_angajat;

--2. Sa se afiseze ultimele maxim 2 operatiuni pentru cardurile clientilor, descendent dupa suma interogata.
select * from (select c.nume_client, c.prenume_client, o.id_card, o.tip_operatiune, o.suma, rank() over ( 
order by o.suma desc) a  from clienti_banca c, card_de_credit ca, operatiuni_card o
where c.id_client=ca.id_client and ca.id_card=o.id_card) where ROWNUM <= 2;

--3. Sa se afiseze valorile precedente si cele curente ale contractelor incheiate de fiecare client al bancii in parte.
SELECT 
c.nume_client, 
data_scadenta, 
valoare_credit,
LAG(valoare_credit) OVER (
PARTITION BY c.nume_client
ORDER BY data_scadenta) valoare_credite_anterioare
FROM contracte_clienti cc, clienti_banca c
where cc.id_client=c.id_client;

--4. Sa se afiseze cel mai mic si cel mai mare credit intocmit de fiecare angajat in parte
SELECT a.nume,id_contract, tip_credit, valoare_credit, FIRST_VALUE(id_contract || '-' ||tip_credit)
OVER (PARTITION BY a.nume ORDER BY valoare_credit --daca scot desc primul e cel mai prost platit, asa e cel mai bine platit
 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED 
FOLLOWING)
 AS "credit_minim",
 last_VALUE(id_contract || '-' ||tip_credit)
OVER (PARTITION BY a.nume ORDER BY valoare_credit
 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED 
FOLLOWING)
 AS "credit_maxim"
FROM angajati_banca a, contracte_clienti c
where a.id_angajat=c.id_angajat
ORDER BY id_departament;

--5. Sa se afiseze numarul de clienti care au valoarea creditului cu o diferenta de +/-2000 fata de cel curent (inclusiv), luand in considerare doar creditele din aceeasi categorie.
select id_client,tip_credit, valoare_credit, 
count(id_client) over (partition by tip_credit order by valoare_credit range between 2000 preceding and 2000
following) numar_clienti_diferenta
from contracte_clienti
order by valoare_credit;

--6. Sa se afiseze suma si media salariilor pe fiecare departament pentru cei angajati dupa cel curent si care sunt manageri.
select a.id_departament, d.denumire_departament, a.data_angajarii, a.nume, a.salariu, 
sum(a.salariu) over (partition by a.id_departament order by a.data_angajarii rows between 
current row and unbounded following) suma_salarii,
avg(a.salariu) over (partition by a.id_departament order by a.data_angajarii rows between 
current row and unbounded following) medie_salarii
from angajati_banca a, departamente_banca d
where a.id_departament=d.id_departament
order by a.id_departament, a.data_angajarii;

--7. Sa se afiseze numarul de angajati din fiecare departament si din fiecare sucursala
select d.denumire_departament, s.denumire_sucursala, count(*) numar_angajati 
from departamente_banca d, sucursale_banca s, angajati_banca a
where d.id_sucursala=s.id_sucursala
and a.id_departament=d.id_departament
group by rollup(d.denumire_departament,s.denumire_sucursala)
order by d.denumire_departament;

--8. Sa se afiseze media contractelor (ca si valoare) emise in fiecare an, luand in considerare toate contractele incheiate in acel an.
select extract(year from data_semnare) ,id_contract, tip_credit, valoare_credit,
avg(valoare_credit) over (partition by extract(year from data_semnare) order by valoare_credit rows between unbounded preceding and unbounded following) credit_mediu
from contracte_clienti 
order by extract(year from data_semnare);
