USE VaccineRedistribution
BEGIN TRANSACTION
INSERT Vaccines VALUES(1,'Pfizer',20,-20,40,10,21);
INSERT Vaccines VALUES(2,'AstraZeneca',10,-10,30,10,21);
INSERT Vaccines VALUES(3,'Moderna',5,-20,30,10,21);
INSERT Vaccines VALUES(4,'Johnson&Johnson',20,-10,30,null,null);
INSERT Vaccines VALUES(5,'Sputnik V',25,-10,30,14,38);

INSERT VaccinationCenters VALUES(1,'FirstVaccinationCenter');
INSERT VaccinationCenters VALUES(2,'SecondVaccinationCenter');
INSERT VaccinationCenters VALUES(3,'ThirdVaccinationCenter');
INSERT VaccinationCenters VALUES(4,'FourthVaccinationCenter');
INSERT VaccinationCenters VALUES(5,'FifthVaccinationCenter');

INSERT Factories VALUES(0,'Serum Insitute');
INSERT Factories VALUES(1,'Thermo Fisher');
INSERT Factories VALUES(2,'Adienne');
INSERT Factories VALUES(3,'Oxford');
INSERT Factories VALUES(4,'Rentschler');

INSERT Orders VALUES(1,'2021-05-05',1);
INSERT Orders VALUES(2,'2021-05-08',2);
INSERT Orders VALUES(3,'2021-05-13',1);
INSERT Orders VALUES(4,'2021-05-20',2);
INSERT Orders VALUES(5,'2021-05-28',2);
INSERT Orders VALUES(6,'2021-05-30',1);
INSERT Orders VALUES(7,'2021-06-03',2);
INSERT Orders VALUES(8,'2021-06-11',1);

INSERT Portions VALUES(1,1,1,10,0,'2021-05-01',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=1),'2021-05-01'));
INSERT Portions VALUES(2,2,2,15,3,'2021-05-06',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=2),'2021-05-06'));
INSERT Portions VALUES(3,4,3,20,1,'2021-05-08',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=4),'2021-05-08'));
INSERT Portions VALUES(4,1,3,10,4,'2021-05-09',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=1),'2021-05-09'));
INSERT Portions VALUES(5,5,4,10,2,'2021-05-10',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=5),'2021-05-15'));
INSERT Portions VALUES(6,3,5,20,1,'2021-06-20',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=3),'2021-06-20'));
INSERT Portions VALUES(7,4,6,50,1,'2021-05-23',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=4),'2021-05-23'));
INSERT Portions VALUES(8,1,7,20,0,'2021-05-29',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=1),'2021-05-29'));
INSERT Portions VALUES(9,1,8,20,0,'2021-06-05',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=1),'2021-06-05'));
INSERT Portions VALUES(10,5,null,40,0,'2021-06-06',dateadd(day,(select ExpirationTime from Vaccines where VaccineID=1),'2021-06-06'));

INSERT Commissions VALUES(1,1,'Realised','2021-05-07');
INSERT Commissions VALUES(2,1,'Realised','2021-05-07');
INSERT Commissions VALUES(3,3,'Failed','2021-05-13');
INSERT Commissions VALUES(4,2,'Realised','2021-05-14');
INSERT Commissions VALUES(5,3,'Failed','2021-05-14');
INSERT Commissions VALUES(6,3,'Realised','2021-05-15');
INSERT Commissions VALUES(7,3,'Realised','2021-05-15');
INSERT Commissions VALUES(8,2,'Failed','2021-05-16');
INSERT Commissions VALUES(9,2,'Failed','2021-05-17');
INSERT Commissions VALUES(10,2,'Realised','2021-05-19');
INSERT Commissions VALUES(11,4,'Realised','2021-05-21');
INSERT Commissions VALUES(12,4,'Realised','2021-05-21');
INSERT Commissions VALUES(13,5,'Realised','2021-05-28');
INSERT Commissions VALUES(14,6,'Planned','2021-05-30');
INSERT Commissions VALUES(15,5,'Planned','2021-05-31');
INSERT Commissions VALUES(16,5,'Planned','2021-06-03');
INSERT Commissions VALUES(17,5,'Planned','2021-06-03');
INSERT Commissions VALUES(18,5,'Planned','2021-06-03');
INSERT Commissions VALUES(19,8,'Planned','2021-06-11');
INSERT Commissions VALUES(20,8,'Planned','2021-06-15');
INSERT Commissions VALUES(21,2,'Planned','2021-05-29');
INSERT Commissions VALUES(22,2,'Planned','2021-05-27');
INSERT Commissions VALUES(23,8,'Planned','2021-06-08');
INSERT Commissions VALUES(24,8,'Planned','2021-06-09');

INSERT Patients VALUES('38010812332','Miros³awa ','Szulc','1938-01-08','Warszawa',null,null,0,1,21);
INSERT Patients VALUES('88120312434','Ludwik ','Szewczyk','1988-12-03','Gdañsk',null,null,2,2,22);
INSERT Patients VALUES('63040421444','Edward ','Szewczyk','1963-04-04','Gdañsk',null,null,3,3,null);
INSERT Patients VALUES('03205182414','Daniel ','Baran','2003-05-18','Wroc³aw',null,'2021-06-10',4,4,23);
INSERT Patients VALUES('89021524144','Kornel ','Jasiñski','1989-02-15','Warszawa',null,null,2,5,null);
INSERT Patients VALUES('45192121015','Jerzy ','Maciejewski','1945-12-12','Warszawa',null,null,0,6,24);
INSERT Patients VALUES('86819104101','Marzanna ','Rutkowska','1968-01-04','Warszawa',null,'2021-06-05',0,7,null);
INSERT Patients VALUES('59021216166','Hortensja ','Szewczyk','1959-02-22','Kraków',null,null,1,8,null);
INSERT Patients VALUES('63021417177','Kamila ','Krawczyk','1963-12-24','Bia³ystok',null,null,1,9,null);
INSERT Patients VALUES('77190141219','Karolina ','Sikora','1977-10-14','Opole',null,null,2,10,null);
INSERT Patients VALUES('99194121321','Roksana ','Makowska','1999-04-12','Poznañ',null,null,3,11,null);
INSERT Patients VALUES('72199011221','Berenika ','W³odarczyk','1972-09-01','Lublin',null,null,2,12,null);
INSERT Patients VALUES('73192181228','Zuzanna ','Zió³kowska','1973-02-18','Szczecin',null,null,2,13,null);
INSERT Patients VALUES('21340300323','Fryderyk ','Szulc','2000-05-13','Warszawa',null,null,4,14,null);
INSERT Patients VALUES('69021811311','Gustaw ','Zieliñski','1969-05-18','Poznañ',null,null,1,15,null);
INSERT Patients VALUES('21931311434','Anastazy ','Zalewski','2000-06-29','Lublin',null,null,3,16,null);
INSERT Patients VALUES('81021223033','Artur ','Wróblewski','1981-07-02','Szczecin',null,null,2,17,null);
INSERT Patients VALUES('79021524044','Anatol ','Witkowski','1979-03-25','Zabrze',null,null,2,18,null);
INSERT Patients VALUES('92021531111','And¿elika ','WoŸniak','1992-11-15','Warszawa',null,null,3,19,null);
INSERT Patients VALUES('97021235155','Jadwiga ','W³odarczyk','1997-07-12','Warszawa',null,null,3,20,null);
INSERT Patients VALUES('99071335142','Jan','Kowalski','1999-07-13','Warszawa',null,null,3,null,null);

COMMIT TRANSACTION