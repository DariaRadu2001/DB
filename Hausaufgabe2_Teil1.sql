--Fremdschlüsselintegritätsregel
INSERT INTO Mat_Dist(M_ID, D_ID)
VALUES ('1','7D')

INSERT INTO Mat_Dist(M_ID, D_ID)
VALUES (100,'1D')

INSERT INTO Mat_Dist(M_ID, D_ID)
VALUES (1,10)

--Einfugen
INSERT INTO Mat_Dist(M_ID, D_ID)
VALUES (1,1),(2,2),(4,3),(5,4),(5,5)

INSERT INTO Distribuitori(D_ID, Ad_ID, Name)
VALUES(1,1,'MataseSRL'),(2,2,'DantelaSRL'),(3,1,'DenimSRL'),(4,4,'CottonSRL'),(5,3,'BumbacSRL')

INSERT INTO Angajati(A_ID, Name, Geb_datum, C_Id, Ad_ID)
VALUES(1,'Luigi Francesco','1999-12-19',1,1),(2,'Pier Loranz','1978-3-10',4,3),(3,'Harry Tomlinson','2000-6-20',2,4)

INSERT INTO Prezentari(Prez_ID, Ad_ID, Nume)
VALUES(1,1,'Fashion Week Milano'),(2,4,'Fashion Week London'),(3,3,'Fashion Week Paris')

INSERT INTO Adresa(Ad_ID, Strada, Nr, Oras, Tara)
VALUES(1,'Via Malaga',123,'Milano','Italia'),(2,'Via Kyoto',34,'Florenta','Italia'),(3,'Rue du Verrou',67,'Paris','Franta'),(4,'Staple St',43,'Londra','Anglia'),(5,'Rue Perronet',12,'Paris','Franta')


-- WHERE INSTRUCTIONS
DELETE FROM Runway

SELECT *
FROM Runway
ORDER BY An

INSERT INTO Runway(M_ID, Prez_ID, An)
VALUES(1,1,2018),(2,1,2019),(6,1,2018),(4,3,2018),
(4,1,2017),(5,3,2018),(7,1,2018),(3,1,2017),
(1,3,2018),(5,3,2016),(4,2,2015),(2,1,2014)

--nu e bun
DELETE FROM Runway
WHERE Prez_ID IN (SELECT Prez_ID 
					FROM Prezentari
					WHERE Prez_ID = 1)
					AND An = 2018


SELECT *
FROM Modele

DELETE FROM Modele

INSERT INTO Modele (M_ID, Vor_Name, Nach_Name)
VALUES(1,'Gigi','Hadid'),(2,'Adriana', 'Lima'),(3,'Miranda', 'Kerr'),(4,'Barbara', 'Palvin'),
(5,'Behati', 'Prisloo'),(6,'Bella','Hadid'),(7,'Anwar','Hadid'),(8,'Alessandra','Ambrosio'),
(9,'Yolanda','Hadid'),(10,NULL,'Barbados'),(11,NULL,NULL)

DELETE FROM Modele
WHERE Nach_Name IS NULL OR Vor_Name IS NULL

DELETE FROM Modele
WHERE Nach_Name LIKE 'E_%' AND Vor_Name IS NOT NULL

DELETE FROM Modele
WHERE Nach_Name = 'Hadid' AND Vor_Name LIKE 'G_%'

DELETE FROM Modele
WHERE Vor_Name LIKE 'B_%'

DELETE FROM Modele
WHERE Nach_Name IN ('Hadid','Kerr') 

UPDATE Modele
SET Nach_Name = 'E' + Nach_Name
WHERE Nach_Name = 'Hadid' OR Nach_Name = 'Lima'

UPDATE Modele
SET Vor_Name = 'Cara' , Nach_Name = 'Delevigne'
WHERE Nach_Name IS NULL AND Nach_Name IS NULL

UPDATE Modele
SET Vor_Name = 'Elsa', Nach_Name = 'Hosk' 
WHERE Nach_Name IS NOT NULL AND Vor_Name IS NULL

SELECT *
FROM Produse

UPDATE Produse 
SET Cantitate = Cantitate + 1000
WHERE Nume LIKE 'R_%'

UPDATE Produse 
SET Cantitate = Cantitate - 1000
WHERE Marime IN ('xs', 's')


SELECT *
FROM Materiale

UPDATE Materiale 
SET Cantitate = Cantitate + 100
WHERE M_ID IN (SELECT F.M_ID
				FROM Fabricatie F
				WHERE F.Cantitate < 200)

UPDATE Materiale
SET Cantitate = Cantitate + 100
WHERE M_ID IN (1,2,3)

UPDATE Materiale
SET Cantitate = Cantitate - 100
WHERE Cantitate BETWEEN 300 AND 400

SELECT *
FROM Show

DELETE FROM Show

INSERT INTO Show(C_ID, Prez_ID, An)
VALUES(1,1,2018),(2,1,2019),(3,1,2018),(2,3,2018),
(4,1,2015),(5,3,2014),(1,1,2013),(3,1,2017),
(1,3,2018),(5,3,2016),(4,2,2015),(2,1,2014)

DELETE FROM Show
WHERE An BETWEEN 2013 AND 2016

SELECT * 
FROM Show
ORDER BY An



--Part2
SELECT *
FROM Materiale M
WHERE M.Costuri > ANY(SELECT M2.Costuri
						FROM Materiale M2
						WHERE  M2.Nume = 'Matase')
ORDER BY Costuri

