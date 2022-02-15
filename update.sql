USE VaccineRedistribution

SELECT* FROM Commissions;

BEGIN TRANSACTION

-- op�niam szczepienia
UPDATE Commissions
SET Date=dateadd(day,1,Date) WHERE Date='2021-06-03';

-- usuwam szczepienia kt�re odby�y si� po wyga�ni�ciu terminu wa�no�ci szczepionki
UPDATE Patients
SET FirstDoseCommissionID=null WHERE FirstDoseCommissionID IN
(SELECT CommissionID FROM Commissions c
JOIN Portions p ON c.PortionID=p.PortionID
WHERE c.Date > p.ExpirationDate)

UPDATE Patients
SET SecondDoseCommissionID=null WHERE SecondDoseCommissionID IN
(SELECT CommissionID FROM Commissions c
JOIN Portions p ON c.PortionID=p.PortionID
WHERE c.Date > p.ExpirationDate)

UPDATE Commissions
SET State='Failed' WHERE CommissionID IN
(SELECT CommissionID FROM Commissions c
JOIN Portions p ON c.PortionID=p.PortionID
WHERE c.Date > p.ExpirationDate)

COMMIT TRANSACTION;

SELECT * FROM Commissions;