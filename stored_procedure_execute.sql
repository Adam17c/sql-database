USE VaccineRedistribution
SELECT * FROM Patients

EXEC AddSecondDoseCommission '21340300323', 'Pfizer', 1, '2021-06-12';
EXEC AddSecondDoseCommission '72199011221', 'Sputnik V', 1, '2021-06-18';

SELECT * FROM Commissions
SELECT * FROM Patients