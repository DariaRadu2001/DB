SELECT W.Name, W.Vorname
From Wissenschaftler W
INNER JOIN EditorialBoard EB
ON W.Id = EB.IdWissenschaftler
Group by EB.IdWissenschaftler, W.Name, W.Vorname
Having count(*) > ANY(SELECT Count(*)
					From EditorialBoard EB1
					INNER JOIN Wissenschaftler W1
					ON W1.Id = EB1.IdWissenschaftler
					Group by W1.Id,W1.Forschungsgebiet
					Having W1.Forschungsgebiet = 'AI')


SELECT W.Name, W.Vorname
From Wissenschaftler W
Where W.Forschungsgebiet = 'AI'

--2

SELECT Z.ISSN, Z.Name
From Zeitschrift Z
INNER JOIN Ausgabe A
ON  Z.ISSN = A.ZeitschriftISSN
INNER JOIN Verlag V
ON V.Id = A.IdVerlag
WHERE V.Name = 'CEUR'
INTERSECT
SELECT Z1.ISSN, Z1.Name
From Zeitschrift Z1
INNER JOIN Ausgabe A1
ON  Z1.ISSN = A1.ZeitschriftISSN
INNER JOIN Verlag V1
ON V1.Id = A1.IdVerlag
WHERE V1.Name = 'Springer'
