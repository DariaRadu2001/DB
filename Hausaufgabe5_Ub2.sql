--2a)
--CREATE UNIQUE INDEX idTa ON Ta(idA)
--DROP INDEX Ta.idTa
--DROP INDEX Ta.a2
--create unique nonclustered index a2 on Ta(a2)
--Existenz der Indexe mit System Tabellen und Sichte

SELECT * 
FROM sys.indexes
WHERE object_id = OBJECT_ID('Ta')

--Clustered Index Scan
SELECT *
FROM Ta
WHERE idA%5 = 0
--Clustered Index Seek
SELECT *
FROM Ta
WHERE idA = 100 
--Nonclustered Index Scan
SELECT a2
FROM Ta
WHERE a2%2 = 0
--Nonclustered Index Seek
SELECT *
FROM Ta
WHERE a2 = 10

SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc

--2b)Operator Key Lookup
--CREATE NONCLUSTERED INDEX a3 ON Ta(a3)
--DROP INDEX Ta.a3
--SELECT a2 FROM Ta WHERE a3 = 100

SELECT a2
FROM Ta
WHERE a3 = 100 AND a2 = 100

--2c)
SELECT b3
FROM Tb
WHERE b2 = 100

create nonclustered index b2 on Tb(b2)

SELECT b3
FROM Tb
WHERE b2 = 100

DROP INDEX Tb.b2

--2d)//idA apare o data in Ta dar de 3 ori in Tc
SELECT c2
FROM Tc
INNER JOIN Ta
ON Ta.idA = Tc.idA
WHERE Ta.idA = 100

SELECT c2
FROM Tc
INNER JOIN Tb
ON Tb.idB = Tc.idB
WHERE Tb.idB = 5

CREATE NONCLUSTERED INDEX idA ON Tc(idA) INCLUDE (c2)
CREATE NONCLUSTERED INDEX idB ON Tc(idB) INCLUDE (c2)

SELECT c2
FROM Tc
INNER JOIN Ta
ON Ta.idA = Tc.idA
WHERE Ta.idA = 100

SELECT c2
FROM Tc
INNER JOIN Tb
ON Tb.idB = Tc.idB
WHERE Tb.idB = 5

DROP INDEX Tc.idA
DROP INDEX Tc.idB