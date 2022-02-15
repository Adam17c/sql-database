USE VaccineRedistribution
GO

CREATE PROCEDURE AddSecondDoseCommission
@pesel nchar(11), @vaccineName varchar(20), @vaccinationCenterID int, @date date
AS

IF (SELECT p.FirstDoseCommissionID FROM Patients p WHERE p.PESEL=@pesel) is null
OR (SELECT c.State FROM Commissions c JOIN Patients p ON c.CommissionID=p.FirstDoseCommissionID
WHERE p.PESEL=@pesel)='Failed'
OR (SELECT c.Date FROM Commissions c JOIN Patients p ON c.CommissionID=p.FirstDoseCommissionID
WHERE p.PESEL=@pesel)>=@date
OR (SELECT c.State FROM Commissions c JOIN Patients p ON c.CommissionID=p.SecondDoseCommissionID
WHERE p.PESEL=@pesel)='Realised'
OR (SELECT VaccinationDelayEnd FROM Patients WHERE PESEL=@pesel) >= @date
OR DATEADD(day,(SELECT MinTimeBetweenDoses FROM Vaccines WHERE VaccineName=@vaccineName),
(SELECT c.Date FROM Commissions c JOIN Patients p ON p.FirstDoseCommissionID=c.CommissionID
WHERE p.PESEL=@pesel)) > @date 
	BEGIN
		RETURN
	END

DECLARE @deliveredDoses int
DECLARE @portionID int;

BEGIN
-- pobieramy liczbê potrzebnych szeczpionek
SET @deliveredDoses = (
SELECT sum(p.DosesQuantity) FROM Orders o 
JOIN Portions p ON o.OrderID=p.OrderID
JOIN Vaccines v ON v.VaccineID=p.VaccineID
WHERE o.ShipmentDate<=@date AND p.ExpirationDate >= @date AND v.VaccineName=@vaccineName 
AND o.VaccinationCenterID=@vaccinationCenterID
)

-- jeœli w wybranym centrum sa szukane szczepionki
IF @deliveredDoses > 0
	BEGIN
		DECLARE @avaiableDoses int
		DECLARE @dosesQuantity int
		DECLARE @usedDoses int

		-- pobieramy partie z potrzebnymi szczpinkami
		DECLARE deliveredPortions CURSOR LOCAL FOR SELECT
		PortionID FROM Portions p
		JOIN Orders o ON o.OrderID=p.OrderID
		JOIN Vaccines v ON v.VaccineID=p.VaccineID
		WHERE o.ShipmentDate<=@date AND p.ExpirationDate>=@date AND v.VaccineName=@vaccineName 
		AND o.VaccinationCenterID=@vaccinationCenterID;

		-- dla ka¿dej partii sprawdzamy czy coœ jeszcze w niej zosta³o
		OPEN deliveredPortions
		FETCH NEXT FROM deliveredPortions INTO @portionID
		WHILE @@FETCH_STATUS=0
			BEGIN
				SET @dosesQuantity=
				(
				SELECT p.DosesQuantity FROM Portions p
				WHERE p.PortionID=@portionID
				)

				SET @usedDoses=
				(
				SELECT COUNT(*) FROM Commissions c
				WHERE c.PortionID=@portionID AND c.State!='Failed'
				)

				SET @avaiableDoses = ( @dosesQuantity - @usedDoses);
				IF @avaiableDoses > 0 BREAK

				FETCH NEXT FROM deliveredPortions INTO @portionID
			END
		CLOSE deliveredPortions
		DEALLOCATE deliveredPortions

		-- jeœli w ¿adnej nic nie zosta³o to wychodzimy
		IF @avaiableDoses = 0
		BEGIN
			RETURN
		END
	END

-- jeœli w wybranym centrum brak szukanych szczepionek
IF @deliveredDoses=0 OR @deliveredDoses is null
	BEGIN
	-- przegl¹damy partie z magazynu w poszukiwaniu odpowiednich partii ze szczepionkami
	SET @portionID=
	(
	SELECT TOP 1 PortionID FROM Portions p 
	JOIN Vaccines v ON v.VaccineID=p.VaccineID
	WHERE p.ExpirationDate>=@date AND p.ProductionDate<@date AND v.VaccineName=@vaccineName 
	AND p.OrderID is null
	)

	-- jeœli jak¹œ znaleŸliœmy to centrum j¹ zamawia
	IF @portionID is not null
		BEGIN
			BEGIN TRANSACTION
			
			DECLARE @orderID int
			SET @orderID=
			(SELECT TOP 1 OrderID FROM Orders ORDER BY OrderID desc) + 1;
			
			INSERT Orders
			VALUES (@orderID, @date, @vaccinationCenterID)

			UPDATE Portions
			SET OrderID=@orderID
			WHERE PortionID=@portionID
			COMMIT TRANSACTION
		END
	-- jeœli nie znaleŸliœmy to wychodzimy
	IF @portionID is null
		BEGIN
			RETURN
		END
	END

-- dotarliœmy do miejsca, w którym mamy w danym centrum id partii z szukanymi szczepionkami
-- wiêc rezerwujemy szczepienie

DECLARE @commissionID int
SET @commissionID = (SELECT TOP 1 CommissionID FROM Commissions ORDER BY CommissionID desc) + 1;

BEGIN TRANSACTION

INSERT Commissions
VALUES (@commissionID, @portionID, 'Planned',@date)

UPDATE Patients
SET SecondDoseCommissionID=@commissionID WHERE PESEL=@pesel

COMMIT TRANSACTION

END