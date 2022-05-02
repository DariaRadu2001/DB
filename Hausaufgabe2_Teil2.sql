--Part2

/*
Materiale care nu au fost niciodata folosite la fabricatia vreunui produs
-de corectat
-matase,dantela,saten,catifea,tul,...
*/
SELECT *
FROM Materiale M
LEFT OUTER JOIN Fabricatie F
ON M.M_ID = F.M_ID
LEFT OUTER JOIN Produse P
ON P.P_ID = F.P_ID
WHERE F.P_ID IS NULL AND F.M_ID IS NULL

/*group by + having
Comenzi cu cel putin 2 produse
*/
SELECT C.F_ID
FROM Cumparaturi C
GROUP BY C.F_ID
HAVING COUNT(*)>=2

/*group by + having
produse cu cel putin 2 materiale
*/
SELECT F.P_ID
FROM Fabricatie F
GROUP BY F.P_ID
HAVING COUNT(*)>=2

/*
Afiseaza toate materialele care sunt mai scumpe decat bumbacul sau catifea in ordine desc.
*/
SELECT M.Nume, M.Costuri
FROM Materiale M
WHERE M.Costuri > ANY(SELECT M2.Costuri
						FROM Materiale M2
						WHERE M2.Nume = 'Bumbac')
UNION
SELECT M.Nume, M.Costuri
FROM Materiale M
WHERE M.Costuri > ANY(SELECT M2.Costuri
						FROM Materiale M2
						WHERE M2.Nume = 'Catifea')
ORDER BY M.Costuri DESC

/*
TOP 2 cel mai cautate produs de la toate firmele in functie de cate ori apare pe bonuri(nu cantitate)
*/
SELECT TOP(2) WITH TIES P.Nume, COUNT(Cum.P_ID) 
FROM Cumparaturi Cum
INNER JOIN Produse P
ON Cum.P_ID = P.P_ID
INNER JOIN Factura F
ON Cum.F_ID = F.F_ID
GROUP BY P.P_ID, P.Nume
ORDER BY COUNT(Cum.P_ID) DESC


/*
Modelele care au participat la Fashion Week Milano
*/
SELECT DISTINCT M.M_ID, M.Vor_Name, M.Nach_Name
FROM Modele M
INNER JOIN Runway R
ON M.M_ID = R.M_ID
INNER JOIN Prezentari P
ON P.Prez_ID = R.Prez_ID
WHERE P.Prez_ID = 1

/*
Casele de moda care au participat la cel putin 3 show.uri la o prezentare care e acceasi si cate au avut
*/
SELECT C.Name, COUNT(*) AS [Anzahl Shows], P.Nume
FROM Casa_de_moda C
INNER JOIN Show S
ON S.C_ID = C.C_ID
INNER JOIN Prezentari P
ON P.Prez_ID = S.Prez_ID
GROUP BY C.Name, P.Nume
HAVING COUNT(*) >= 3

/*
Se da produsul si materialul din care a fost facut daca s-au croit mai mult de 30 de bucati, 
iar numele materialului nu incepe cu D
*/
SELECT P.Nume, M.Nume
FROM Produse P
INNER JOIN Fabricatie F 
ON P.P_ID = F.P_ID
INNER JOIN Materiale M
ON M.M_ID = F.M_ID
WHERE F.Cantitate > 30 
AND M.Nume IN (SELECT M.Nume
					FROM Materiale M
					WHERE NOT M.Nume LIKE 'D%' 
					)

/*
Modelele care au participat si la Fashion Week Milano si la Fashion Week Paris
pt in
*/

SELECT DISTINCT M.M_ID, M.Vor_Name, M.Nach_Name
FROM Modele M
INNER JOIN Runway R
ON M.M_ID = R.M_ID
INNER JOIN Prezentari P
ON P.Prez_ID = R.Prez_ID
WHERE P.Nume = 'Fashion Week Milano'
AND M.M_ID IN (SELECT M.M_ID
				FROM Modele M
				INNER JOIN Runway R
				ON M.M_ID = R.M_ID
				INNER JOIN Prezentari P
				ON P.Prez_ID = R.Prez_ID
				WHERE P.Nume = 'Fashion Week Paris')



SELECT M.M_ID, M.Vor_Name, M.Nach_Name
FROM Modele M
INNER JOIN Runway R
ON M.M_ID = R.M_ID
INNER JOIN Prezentari P
ON P.Prez_ID = R.Prez_ID
WHERE P.Nume = 'Fashion Week Milano'
INTERSECT
SELECT M.M_ID, M.Vor_Name, M.Nach_Name
FROM Modele M
INNER JOIN Runway R
ON M.M_ID = R.M_ID
INNER JOIN Prezentari P
ON P.Prez_ID = R.Prez_ID
WHERE P.Nume = 'Fashion Week Paris'

/*
Prezentari la care a participat Bella Hadid sau Gigi Hadid
*/
SELECT P.Prez_ID, P.Nume
FROM Prezentari P
INNER JOIN Runway R
ON R.Prez_ID = P.Prez_ID
INNER JOIN Modele M
ON M.M_ID = R.M_ID
WHERE M.Nach_Name = 'Hadid' AND
	(M.Vor_Name = 'Gigi' OR M.Vor_Name = 'Bella')



/*
Case de moda care au participat la Fashion Week Milano dar nu si la Fashion Week Paris
*/
SELECT C.Name
FROM Casa_de_moda C
INNER JOIN Show S
ON C.C_ID = S.C_ID
INNER JOIN Prezentari P
ON S.Prez_ID = P.Prez_ID
WHERE P.Nume = 'Fashion Week Milano'
AND C.Name NOT IN (SELECT C.Name
					FROM Casa_de_moda C
					INNER JOIN Show S
					ON C.C_ID = S.C_ID
					INNER JOIN Prezentari P
					ON S.Prez_ID = P.Prez_ID
					WHERE P.Nume = 'Fashion Week Paris')

/*
Ne da toate casele de moda care au vandut ceva in afara de Gucci
*/
SELECT C.Name
FROM Casa_de_moda C, Factura F
WHERE C.C_ID = F.C_ID
EXCEPT
SELECT C.Name
FROM Casa_de_moda C
WHERE C.Name = 'Gucci'

/*
Materialele care sunt mai scumpe decat toate materialele care incep cu D
*/
SELECT *
FROM Materiale M
WHERE M.Costuri > ALL(SELECT M2.Costuri
							FROM Materiale M2
							WHERE M2.Nume LIKE 'D%')
