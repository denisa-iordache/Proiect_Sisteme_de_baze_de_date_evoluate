create table angajati_banca
(
    id_angajat number(3) not null,
    nume varchar2(20),
    prenume varchar2(20),
    telefon varchar2(10),
    email varchar2(25),
    salariu number(7),
    data_angajarii date,
    id_functie varchar2(10),
    id_manager number(3),
    id_departament number(4)
);

create index AN_DEPARTAMENT_IX on ANGAJATI_BANCA (ID_DEPARTAMENT);
create index AN_FUNCTIE_IX on ANGAJATI_BANCA (ID_FUNCTIE);
create index AN_MANAGER_IX on ANGAJATI_BANCA (ID_MANAGER);
create index AN_NUME_PRENUME_IX on ANGAJATI_BANCA (NUME, PRENUME);
alter table ANGAJATI_BANCA
  add constraint AN_ID_ANGAJAT_PK primary key (ID_ANGAJAT);
alter table ANGAJATI_BANCA
  add constraint AN_EMAIL_UK unique (EMAIL);
alter table ANGAJATI_BANCA
  add constraint AN_DATA_ANG_NN
  check ("DATA_ANGAJARII" IS NOT NULL);
alter table ANGAJATI_BANCA
  add constraint AN_EMAIL_NN
  check ("EMAIL" IS NOT NULL);
alter table ANGAJATI_BANCA
  add constraint AN_FUNCTIE_NN
  check ("ID_FUNCTIE" IS NOT NULL);
alter table ANGAJATI_BANCA
  add constraint AN_NUME_NN
  check ("NUME" IS NOT NULL);
alter table ANGAJATI_BANCA
  add constraint AN_PRENUME_NN
  check ("PRENUME" IS NOT NULL);
alter table ANGAJATI_BANCA
  add constraint AN_SALARIU_P
  check (SALARIU > 0);
alter table ANGAJATI_BANCA
  add constraint AN_FUNCTIE_FK foreign key (ID_FUNCTIE)
  references FUNCTII_ANGAJATI (ID_FUNCTIE);
alter table ANGAJATI_BANCA
  add constraint AN_DEPT_FK foreign key (ID_DEPARTAMENT)
  references DEPARTAMENTE_BANCA (ID_DEPARTAMENT);
alter table ANGAJATI_BANCA
  add constraint AN_MANAGER_FK foreign key (ID_MANAGER)
  references ANGAJATI_BANCA (ID_ANGAJAT);

alter table angajati_banca modify constraint AN_FUNCTIE_FK enable;
alter table angajati_banca modify constraint AN_DEPT_FK enable;
alter table angajati_banca modify constraint AN_MANAGER_FK enable;

create table functii_angajati
(
    id_functie varchar2(10) not null,
    denumire_functie varchar2(30),
    salariu_minim number(7),
    salariu_maxim number(7)
);

alter table FUNCTII_ANGAJATI
  add constraint ID_FC_PK primary key (ID_FUNCTIE);
alter table FUNCTII_ANGAJATI
  add constraint DEN_FC_NN
  check ("DENUMIRE_FUNCTIE" IS NOT NULL);  
alter table FUNCTII_ANGAJATI
  add constraint FC_SALARIU_P
  check (SALARIU_MINIM > 0);
alter table FUNCTII_ANGAJATI
  add constraint FC_SALARIUM_P
  check (SALARIU_MAXIM > 0);

create table departamente_banca
(
    id_departament number(4),
    denumire_departament varchar2(35),
    id_manager number(3),
    id_sucursala number(4)
);

create index DEP_SUC_IX on DEPARTAMENTE_BANCA (id_sucursala);
alter table DEPARTAMENTE_BANCA
  add constraint DEP_ID_PK primary key (ID_DEPARTAMENT);
alter table DEPARTAMENTE_BANCA
  add constraint DEP_NAME_NN
  check ("DENUMIRE_DEPARTAMENT" IS NOT NULL);
alter table DEPARTAMENTE_BANCA
  add constraint DEP_SUC_FK foreign key (id_sucursala)
  references sucursale_banca (id_sucursala);
alter table DEPARTAMENTE
  add constraint DEP_MGR_FK foreign key (ID_MANAGER)
  references ANGAJATI_BANCA (ID_ANGAJAT)
  disable
  novalidate;

alter table departamente_banca modify constraint DEP_SUC_FK  enable;

create table sucursale_banca
(
    id_sucursala number(2),
    denumire_sucursala varchar2(30),
    id_locatie number(4)
);

create index SUC_LOC_IX on sucursale_banca (ID_LOCATIE);
alter table sucursale_banca
  add constraint SUC_ID_PK primary key (id_sucursala);
alter table sucursale_banca
  add constraint SUC_NAME_NN
  check ("DENUMIRE_SUCURSALA" IS NOT NULL);
alter table sucursale_banca
  add constraint SUC_LOC_FK foreign key (ID_LOCATIE)
  references LOCATII_SUCURSALE (ID_LOCATIE);

alter table sucursale_banca modify constraint SUC_LOC_FK enable;

create table locatii_sucursale
(
    id_locatie number(4),
    adresa varchar2(40),
    cod_postal varchar2(6),
    oras varchar2(25)
);

create index LO_ORAS_IX on LOCATII_SUCURSALE (ORAS);
alter table LOCATII_SUCURSALE
  add constraint LO_ID_PK primary key (ID_LOCATIE);
alter table LOCATII_SUCURSALE
  add constraint LO_OR_NN
  check ("ORAS" IS NOT NULL);

create table clienti_banca
(
    id_client number(6) not null,
    nume_client varchar2(20),
    prenume_client varchar2(20),
    CNP varchar2(13),
    telefon_client varchar2(10),
    email_client varchar2(25),
    varsta number(3),
    venit_net number(8,2)
);

create index CL_N_P_IX on CLIENTI_BANCA (NUME_CLIENT,PRENUME_CLIENT);
alter table CLIENTI_BANCA
  add constraint CL_ID_CLIENT_PK primary key (ID_CLIENT);
alter table CLIENTI_BANCA
  add constraint CLI_NUME_NN
  check ("NUME_CLIENT" IS NOT NULL);
alter table CLIENTI_BANCA
  add constraint CLI_PRENUME_NN
  check ("PRENUME_CLIENT" IS NOT NULL);
alter table CLIENTI_BANCA
  add constraint CLI_CNP_UK unique (CNP);
alter table CLIENTI_BANCA
  add constraint CLI_EMAIL_UK unique (EMAIL_CLIENT);
alter table CLIENTI_BANCA
  add constraint CLI_VASRTA_P
  check (VARSTA > 0);
alter table CLIENTI_BANCA
  add constraint CLI_VEN_NET_P
  check (VENIT_NET > 0);

create table contracte_clienti
(
    id_contract number(6) not null,
    tip_credit varchar2(30),
    data_semnare date,
    data_scadenta date,
    valoare_credit number(8),
    nr_rate number(3),
    rata_dobanzii number(3),
    id_client number(6),
    id_angajat number(3) 
);

create index CO_DATA_SE_IX on CONTRACTE_CLIENTI (DATA_SEMNARE);
create index CO_DATA_SC_IX on CONTRACTE_CLIENTI (DATA_SCADENTA);
create index CO_ID_ANGAJAT_IX on CONTRACTE_CLIENTI (ID_ANGAJAT);
create index CO_ID_CLIENT_IX on CONTRACTE_CLIENTI (ID_CLIENT);
alter table CONTRACTE_CLIENTI
  add constraint CO_ID_CONTRACT_PK primary key (ID_CONTRACT);
alter table CONTRACTE_CLIENTI
  add constraint CO_TIP_NN
  check ("TIP_CREDIT" IS NOT NULL);
alter table CONTRACTE_CLIENTI
  add constraint CO_VAL_P
  check (VALOARE_CREDIT >0);
alter table CONTRACTE_CLIENTI
  add constraint CO_RATE_P
  check (NR_RATE >0);
alter table CONTRACTE_CLIENTI
  add constraint CO_DOB_P
  check (RATA_DOBANZII >0);
alter table CONTRACTE_CLIENTI
  add constraint CO_CL_FK foreign key (ID_CLIENT)
  references CLIENTI_BANCA (ID_CLIENT);
alter table CONTRACTE_CLIENTI
  add constraint CO_ANG_FK foreign key (ID_ANGAJAT)
  references ANGAJATI_BANCA (ID_ANGAJAT);

alter table contracte_clienti modify constraint CO_CL_FK enable;
alter table contracte_clienti modify constraint CO_ANG_FK enable;

create table card_de_credit
(
    id_card number(16),
    CVV number(3),
    PIN number(4),
    id_client number(6)
);

create index C_PIN_IX ON CARD_DE_CREDIT (PIN);
alter table CARD_DE_CREDIT
  add constraint C_ID_CARD_PK primary key (ID_CARD);
alter table CARD_DE_CREDIT
  add constraint C_CVV_UK unique (CVV);
alter table CARD_DE_CREDIT
  add constraint C_PIN_P
  check (PIN >0);
alter table CARD_DE_CREDIT
  add constraint C_CL_FK foreign key (ID_CLIENT)
  references CLIENTI_BANCA (ID_CLIENT);

alter table card_de_credit modify constraint C_CL_FK enable;

create table operatiuni_card
(
    id_operatiune number(8),
    tip_operatiune varchar2(25),
    suma number(7),
    id_card number(16)
);

create index OP_ID_CARD_IX on OPERATIUNI_CARD (ID_CARD);
alter table OPERATIUNI_CARD
  add constraint OP_TIP_P
  check ("TIP_OPERATIUNE" IS NOT NULL);
alter table OPERATIUNI_CARD
  add constraint OP_SUM_P
  check (SUMA >0);
alter table OPERATIUNI_CARD
  add constraint OP_C_FK foreign key (ID_CARD)
  references CARD_DE_CREDIT (ID_CARD); 

alter table operatiuni_card modify constraint OP_C_FK enable;

drop table angajati_banca;
flashback table angajati_banca to before drop;
drop table angajati_banca cascade constraints;
flashback table angajati_banca to before drop;
truncate table angajati_banca;

alter table angajati_banca modify email varchar2(50);
alter table clienti_banca modify email_client varchar2(50);
alter table functii_angajati modify denumire_functie varchar(35);
alter table functii_angajati add id_departament number(4);
alter table functii_angajati drop column id_departament;
alter table departamente_banca add nume_manager varchar2(30);
alter table departamente_banca drop column nume_manager;
alter table sucursale_banca add locatie varchar(30);
alter table sucursale_banca drop column locatie;
alter table operatiuni_card modify constraint OP_SUM_P disable;
alter table operatiuni_card modify constraint OP_SUM_P enable;
alter table card_de_credit drop constraint C_PIN_P;
alter table contracte_clienti drop constraint CO_TIP_NN;
alter table contracte_clienti rename constraint CO_ID_CONTRACT_PK to CO_ID_CONTR_PK;

insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1000, 'Bulevardul Eroilor, nr3', '123456', 'Targoviste');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1100, 'Strada Alunis, nr7', '123457', 'Targoviste');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1200, 'Strada Aurorei, nr12', '123458', 'Targoviste');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1300, 'Aleea Trivale, nr12', '223456', 'Pitesti');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1400, 'Aleea Traian, nr23', '223457', 'Pitesti');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1500, 'Aleea Parcului, nr15', '223458', 'Pitesti');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1600, 'Aleea Prislop, nr1', '323456', 'Ploiesti');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1700, 'Aleea Scolii, nr5', '323457', 'Ploiesti');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1800, 'Cartierul Triaj, nr9', '323458', 'Ploiesti');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (1900, 'Piata Cluj, nr41', '123456', 'Sibiu');
insert into LOCATII_SUCURSALE (id_locatie, adresa, cod_postal, oras)
values (2000, 'Piata Huet, nr18', '123456', 'Sibiu');

select * from locatii_sucursale;

insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (01, 'Sucursala BT A', 1000);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (02, 'Sucursala BT B', 1100);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (03, 'Sucursala BT C', 1200);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (04, 'Sucursala BT D', 1300);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (05, 'Sucursala BT E', 1400);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (06, 'Sucursala BT F', 1500);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (07, 'Sucursala BT G', 1600);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (08, 'Sucursala BT H', 1700);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (09, 'Sucursala BT I', 1800);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (10, 'Sucursala BT J', 1900);
insert into sucursale_banca (id_sucursala, denumire_sucursala, id_locatie)
values (11, 'Sucursala BT K', 2000);

select * from sucursale_banca;

insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (10, 'Relatii cu clientii', 001, 01);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (20, 'IT Support', 002, 01);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (30, 'Economic', 003, 04);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (40, 'Trezorerie', 004, 07);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (50, 'Financiar', 005, 04);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (60, 'Resurse umane', null, 08);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (70, 'Recrutare', null, 08);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (80, 'Marketing', null, 02);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (90, 'Operatiuni', null, 05);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (100, 'Risc', null, 03);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (110, 'Retail', null, 06);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (120, 'Achizitii', null, 09);
insert into DEPARTAMENTE_BANCA (id_departament, denumire_departament, id_manager, id_sucursala)
values (130, 'IMM', null, 09);

select * from departamente_banca;

insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('MAN_RC', 'Manager Relatii Clienti', 5000, 6500);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('MAN_IT', 'Manager IT Support', 5000, 6500);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('MAN_EC', 'Manager Economic', 5000, 6500);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('MAN_TZ', 'Manager Trezorerie', 5000, 6500);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('MAN_FN', 'Manager Financiar', 5000, 6500);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('F_RC', 'Functionar', 3500, 4500);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('E_EC', 'Economist', 3500, 4500);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('C_EC', 'Contabil', 3000, 5000);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('O_TZ', 'Ofiter Bancar Trezorerie', 3000, 5000);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('A_FN', 'Analist financiar', 4000, 5000);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('E_MK', 'Expert Marketing', 3000, 4000);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('A_RS', 'Analist risc', 4000, 5000);
insert into FUNCTII_ANGAJATI (id_functie, denumire_functie, salariu_minim, salariu_maxim)
values ('P_IT', 'Programator', 3800, 6000);

select * from functii_angajati;

insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (001, 'Iordache', 'Denisa', '0745324853', 'iordachedenisa@gmail.com', 6200, to_date('23-11-2019', 'dd-mm-yyyy'), 'MAN_RC', null, 10);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (002, 'Tudor', 'Alexandru', '0734642342', 'tudoralex@gmail.com', 6000, to_date('21-09-2017', 'dd-mm-yyyy'), 'MAN_IT', null, 20);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (003, 'Ionescu', 'Andrei', '0725657326', 'ionescuandrei@gmail.com', 6100, to_date('03-04-2016', 'dd-mm-yyyy'), 'MAN_EC', null, 30);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (004, 'Grigore', 'Silviu', '0753682642', 'grigoresilviu@gmail.com', 5860, to_date('07-08-2018', 'dd-mm-yyyy'), 'MAN_TZ', null, 40);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (005, 'Topolica', 'Radu', '0775830510', 'topolicaradu@gmail.com', 6300, to_date('12-02-2014', 'dd-mm-yyyy'), 'MAN_FN', null, 50);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (006, 'Popescu', 'Andreea', '0784745256', 'popescuandreea@gmail.com', 4200, to_date('21-11-2020', 'dd-mm-yyyy'), 'F_RC', 001, 10);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (007, 'Nicolae', 'Maria', '0787520173', 'nicolaemaria@gmail.com', 4300, to_date('19-05-2020', 'dd-mm-yyyy'), 'E_EC', 003, 30);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (008, 'Mihaila', 'Ciprian', '0778734934', 'mihailaciprian@gmail.com', 3200, to_date('28-07-2017', 'dd-mm-yyyy'), 'C_EC', 003, 30);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (009, 'Neagu', 'Vlad', '075677317', 'neaguvlad@gmail.com', 3800, to_date('11-11-2011', 'dd-mm-yyyy'), 'P_IT', 002, 20);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (010, 'Rada', 'Danut', '0756392076', 'radadanut@gmail.com', 4500, to_date('23-10-2017', 'dd-mm-yyyy'), 'A_FN', 005, 50);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (011, 'Anghel', 'Roberta', '0753658946', 'anghelroberta@gmail.com', 4300, to_date('20-05-2015', 'dd-mm-yyyy'), 'O_TZ', 004, 40);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (012, 'Micu', 'Cristina', '0712345678', 'micucristina@gmail.com', 4200, to_date('29-09-2019', 'dd-mm-yyyy'), 'F_RC', 001, 10);
insert into ANGAJATI_BANCA (id_angajat, nume, prenume, telefon, email, salariu, data_angajarii, id_functie, id_manager, id_departament)
values (013, 'Iancu', 'Ion', '0712355678', 'iancuion@gmail.com', 4100, to_date('23-06-2020', 'dd-mm-yyyy'), 'A_RS', null, 100);

select * from angajati_banca;

insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (100, 'Safta', 'Elena', '6000274240856', '0712789165', 'saftae@gmail.com', 29, 4575);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (200, 'Stancu', 'Bianca', '6000274240876', '0712789110', 'stancub@gmail.com', 35, 3816);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (300, 'Popescu', 'Georgel', '5000274240856', '0712789156', 'popescug@gmail.com', 41, 5800);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (400, 'Gheorghe', 'Mihai', '5000274240852', '0712798165', 'gheorghem@gmail.com', 27, 2900);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (500, 'Ivan', 'Petru', '5000274240956', '0713789165', 'ivanp@gmail.com', 55, 6344);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (600, 'Iordache', 'Ioana', '6000724240856', '0717789165', 'iordachei@gmail.com', 43, 4200);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (700, 'Andreescu', 'Alina', '6000574340856', '0712752165', 'andreescua@gmail.com', 27, 2300);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (800, 'Ion', 'George', '5001274240856', '0712743265', 'iong@gmail.com', 35, 3650);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (900, 'Vasile', 'Rebecca', '6000290240856', '0712389165', 'vasiler@gmail.com', 23, 2800);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (1000, 'Ionescu', 'Laura', '6000286740856', '0712107165', 'ionescul@gmail.com', 39, 4100);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (1100, 'Georgel', 'Adelin', '5007574240856', '0712789749', 'georgela@gmail.com', 41, 3976);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (1200, 'Oprea', 'Rares', '5030274240856', '0712069165', 'oprear@gmail.com', 24, 3000);
insert into CLIENTI_BANCA (id_client, nume_client, prenume_client, CNP, telefon_client, email_client, varsta, venit_net)
values (1300, 'Andrei', 'Lucian', '5035274240856', '0710089165', 'andreil@gmail.com', 34, 3876);

select * from clienti_banca;

insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1000, 'Credit de nevoi personale', to_date('01-06-2015', 'dd-mm-yyyy'),  to_date('01-06-2020', 'dd-mm-yyyy'), 12000, 60, 9, 100, 006);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1001, 'Credit imobiliar', to_date('10-03-2020', 'dd-mm-yyyy'),  to_date('10-03-2030', 'dd-mm-yyyy'), 200000, 120, 12, 200, 006);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1002, 'Credit leasing', to_date('07-08-2017', 'dd-mm-yyyy'),  to_date('07-08-2027', 'dd-mm-yyyy'), 90000, 120, 10, 300, 006);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1003, 'Credit de nevoi personale', to_date('01-06-2018', 'dd-mm-yyyy'),  to_date('01-06-2021', 'dd-mm-yyyy'), 6000, 36, 9, 400, 006);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1004, 'Credit imobiliar', to_date('11-03-2019', 'dd-mm-yyyy'),  to_date('11-03-2029', 'dd-mm-yyyy'), 150000, 120, 12, 500, 006);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1005, 'Credit leasing', to_date('07-07-2018', 'dd-mm-yyyy'),  to_date('07-07-2028', 'dd-mm-yyyy'), 60000, 120, 10, 600, 006);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1006, 'Credit de nevoi personale', to_date('20-06-2015', 'dd-mm-yyyy'),  to_date('20-06-2020', 'dd-mm-yyyy'), 8000, 60, 9, 700, 012);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1007, 'Credit imobiliar', to_date('11-04-2019', 'dd-mm-yyyy'),  to_date('11-04-2029', 'dd-mm-yyyy'), 120000, 120, 12, 800, 012);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1008, 'Credit leasing', to_date('07-10-2018', 'dd-mm-yyyy'),  to_date('07-10-2028', 'dd-mm-yyyy'), 50000, 120, 10, 900, 012);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1009, 'Credit de nevoi personale', to_date('01-06-2016', 'dd-mm-yyyy'),  to_date('01-06-2021', 'dd-mm-yyyy'), 9000, 60, 9, 1000, 012);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1010, 'Credit imobiliar', to_date('02-03-2017', 'dd-mm-yyyy'),  to_date('02-03-2027', 'dd-mm-yyyy'), 130000, 120, 12, 1100, 012);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1011, 'Credit leasing', to_date('07-07-2016', 'dd-mm-yyyy'),  to_date('07-07-2026', 'dd-mm-yyyy'), 80000, 120, 10, 1200, 012);
insert into contracte_clienti (id_contract, tip_credit, data_semnare, data_scadenta, valoare_credit, nr_rate, rata_dobanzii, id_client, id_angajat)
values (1013, 'Credit de nevoi personale', to_date('01-06-2019', 'dd-mm-yyyy'),  to_date('01-06-2022', 'dd-mm-yyyy'), 7500, 60, 9, 1300, 012);

select * from contracte_clienti;

insert into card_de_credit (id_card, CVV, PIN, id_client)
values (1234567890123456, 123, 1234, 100);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (2234567890123456, 124, 2234, 200);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (1234567890123457, 125, 3234, 300);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (3234567890123456, 126, 4234, 400);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (1234567890123458, 127, 5234, 500);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (4234567890123456, 128, 6234, 600);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (1234567890123459, 129, 7234, 700);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (5234567890123456, 130, 8234, 800);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (1234567890123451, 131, 9234, 900);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (6234567890123456, 132, 1334, 1000);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (1234567890123452, 133, 1434, 1100);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (7234567890123456, 134, 1534, 1200);
insert into card_de_credit (id_card, CVV, PIN, id_client)
values (1234567890123453, 135, 1634, 1300);

select * from card_de_credit;

insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (001, 'Interogare sold', 5000, 1234567890123456);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (002, 'Retragere numerar', 300, 2234567890123456);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (003, 'Depunere numerar', 800, 1234567890123457);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (004, 'Interogare sold', 1000, 3234567890123456);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (005, 'Retragere numerar', 600, 1234567890123458);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (006, 'Depunere numerar', 50, 4234567890123456);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (007, 'Interogare sold', 2000, 1234567890123459);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (008, 'Retragere numerar', 900, 5234567890123456);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (009, 'Depunere numerar', 700, 1234567890123451);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (010, 'Interogare sold', 880, 6234567890123456);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (011, 'Retragere numerar', 400, 1234567890123452);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (012, 'Depunere numerar', 300, 7234567890123456);
insert into operatiuni_card (id_operatiune, tip_operatiune, suma, id_card)
values (013, 'Interogare sold', 7000, 1234567890123453);

select * from operatiuni_card;