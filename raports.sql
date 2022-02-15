--1
USE VaccineRedistribution
SELECT COUNT(*) AS Nearest_vaccinations FROM Commissions c WHERE convert(date,GETDATE()) <= c.Date
AND DATEADD(WEEK,1,convert(date,GETDATE())) >= c.Date AND c.State='Planned';

--2
--AllExpiredDoses
WITH tmp1 AS
(
SELECT vc.VaccinationCenterID, sum(p.DosesQuantity) AS DosesSum FROM Portions p
JOIN Orders o ON p.OrderID=o.OrderID
JOIN VaccinationCenters vc ON vc.VaccinationCenterID=o.VaccinationCenterID
WHERE p.ExpirationDate < convert(date, GETDATE())
GROUP BY vc.VaccinationCenterID
),
-- UsedExpiredDoses
tmp2 as
(
SELECT vc.VaccinationCenterID, count(*) AS UsedDoses FROM Commissions c
JOIN Portions p ON c.PortionID=p.PortionID
JOIN Orders o ON o.OrderID=p.OrderID
JOIN VaccinationCenters vc ON vc.VaccinationCenterID=o.VaccinationCenterID
WHERE p.ExpirationDate < convert(date, GETDATE())
group by vc.VaccinationCenterID
)

SELECT TOP 1 tmp1.VaccinationCenterID, 
(convert(float,tmp1.DosesSum) - convert(float,tmp2.UsedDoses)) / convert(float,tmp1.DosesSum) 
AS UnusedDosesPercent FROM tmp1
JOIN tmp2 ON tmp1.VaccinationCenterID=tmp2.VaccinationCenterID
ORDER BY (convert(float,tmp1.DosesSum) - convert(float,tmp2.UsedDoses)) / convert(float,tmp1.DosesSum)
desc

--3
SELECT p.VaccineID, v.VaccineName, SUM(p.DosesQuantity) AS Number_of_doses
FROM Portions p JOIN Vaccines v ON p.VaccineID=v.VaccineID
GROUP BY p.VaccineID, v.VaccineName;

--4

SELECT p.* FROM Patients p JOIN Commissions c1 ON p.FirstDoseCommissionID=c1.CommissionID
LEFT JOIN Commissions c2 ON p.SecondDoseCommissionID=c2.CommissionID
WHERE c1.State='Realised'  AND (p.SecondDoseCommissionID is null OR c2.State!='Realised')
AND p.VaccinationDelayEnd is not null 
ORDER BY p.Category

--5
SELECT f.FactoryName, COUNT(c.CommissionID) AS VaccinesUsed FROM Portions p 
JOIN Commissions c ON c.PortionID=p.PortionID
JOIN Factories f ON p.FactoryID=f.FactoryID
WHERE c.State='Realised' 
GROUP BY p.FactoryID, f.FactoryName
ORDER BY COUNT(c.CommissionID);