Create Table Tester
(
	ID_Tester Int identity(1,1),
	Namen Varchar(50),
	Vornamen Varchar(50),
	Geburtsdatum Date,
	Erfahrung INT,
	Primary KEY(ID_Tester)
)


Create Table Technologie 
(
	ID_Technologie Int identity(1,1),
	Namen Varchar(50),
	Popularitat INT,
	Constraint PopularitatInt
	Check (Popularitat >= 1 And Popularitat <=10),
	Primary KEY(ID_Technologie)
)

Create Table Tester_Technologie 
(
	ID_Tester Int,
	ID_Technologie Int,
	Primary KEY(ID_Tester,ID_Technologie),
	Constraint FK_Tester_Technologie Foreign Key(ID_Tester) references Tester,
				Foreign Key(ID_Technologie) references Technologie
)

Create Table Task 
(
	ID_Task Int identity(1,1),
	Namen Varchar(50),
	Beschreibung Varchar(150),
	Primary KEY(ID_Task)
)

Create Table Tester_Task 
(
	ID_Tester_Task int identity(1,1),
	ID_Tester Int,
	ID_Task Int,
	Primary KEY(ID_Tester_Task),
	UNIQUE(ID_Tester,ID_Task),
	Constraint FK_Tester_Task Foreign Key(ID_Tester) references Tester,
				Foreign Key(ID_Task) references Task
)

Create Table Bug 
(
	ID_Bug Int identity(1,1),
	Beschreibung Varchar(150),
	Severity int,
	Primary KEY(ID_Bug)
)

Create Table Tester_Bug 
(
	ID_Tester_Task int,
	ID_Bug Int,
	Primary KEY(ID_Tester_Task,ID_Bug),
	Constraint FK_Tester_Bug Foreign Key(ID_Tester_Task) references Tester_Task,
				Foreign Key(ID_Bug) references Bug
)

