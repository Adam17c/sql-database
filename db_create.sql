IF DB_ID ( N'VaccineRedistribution' ) IS NOT NULL
DROP DATABASE VaccineRedistribution;
GO
CREATE DATABASE VaccineRedistribution;  
GO
USE VaccineRedistribution
CREATE TABLE Vaccines
(
"VaccineID" int not null primary key,
"VaccineName" varchar(40) not null,
"ExpirationTime" int not null,
"MinTemperature" int not null,
"MaxTemperature" int not null,
"MinTimeBetweenDoses" int null,
"MaxTimeBetweenDoses" int null
)

CREATE TABLE Portions
(
"PortionID" int not null primary key,
"VaccineID" int not null,
"OrderID" int null,
"DosesQuantity" int not null,
"FactoryID" int not null,
"ProductionDate" date not null,
"ExpirationDate" date not null
)

CREATE TABLE Factories
(
"FactoryID" int not null primary key,
"FactoryName" varchar(40) not null
)

CREATE TABLE Orders
(
"OrderID" int not null primary key,
"ShipmentDate" date not null,
"VaccinationCenterID" int not null,
)

CREATE TABLE VaccinationCenters
(
VaccinationCenterID int not null primary key,
VaccinationCenterName varchar(40)
)

CREATE TABLE Patients
(
"PESEL" nchar(11) not null primary key,
"Name" varchar(40) not null,
"Surname" varchar(40) not null,
"BirthDate" date not null,
"BirthPlace" varchar(40) not null,
"VaccinationContradictions" text null,
"VaccinationDelayEnd" date null,
"Category" int not null check("Category" in (0,1,2,3,4)),
"FirstDoseCommissionID" int null,
"SecondDoseCommissionID" int null
)

CREATE TABLE Commissions
(
"CommissionID" int not null primary key,
"PortionID" int not null,
"State" nchar(10) not null check("State" in ('Realised','Planned','Failed')),
"Date" date not null
)

ALTER TABLE Portions
	ADD CONSTRAINT FK_Portions_Vaccines FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID);
ALTER TABLE Portions
	ADD CONSTRAINT FK_Portions_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);
ALTER TABLE Portions
	ADD CONSTRAINT FK_Portions_Facotries FOREIGN KEY (FactoryID) REFERENCES Factories(FactoryID);
ALTER TABLE Orders
	ADD CONSTRAINT FK_Orders_VaccinationCenters FOREIGN KEY (VaccinationCenterID) REFERENCES VaccinationCenters(VaccinationCenterID);
ALTER TABLE Patients
	ADD CONSTRAINT FK_Patients_Commissions_1 FOREIGN KEY (FirstDoseCommissionID) REFERENCES Commissions(CommissionID);
ALTER TABLE Patients
	ADD CONSTRAINT FK_Patients_Commissions_2 FOREIGN KEY (SecondDoseCommissionID) REFERENCES Commissions(CommissionID);
ALTER TABLE Commissions
	ADD CONSTRAINT FK_Commissions_Portions FOREIGN KEY (PortionID) REFERENCES Portions(PortionID);