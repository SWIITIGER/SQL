-- 1 tund

-- kommentaar
-- teeme andmebaasi e db
create database TARpe22_4

-- db kustutamine
drop database TARpe22_4

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

---- andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values (1, 'Female')
insert into Gender (Id, Gender)
values (3, 'Unknown')

--- sama Id v''rtusega rida ei saa sisestada
select * from Gender

--- teeme uue tabeli
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

---vaatame Person tabeli sisu
select * from Person

---andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (2, 'wonderwoman', 'w@w.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (3, 'Batman', 'b@b.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (4, 'Aquaman', 'a@a.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (5, 'Catwoman', 'c@c.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (6, 'Antman', 'ant"ant.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (8, NULL, NULL, 2)

select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

---kui sisestad uue rea andmeid ja ei ole sisestanud GenderId all v''rtust, siis
---see automaatselt sisetab tabelisse v''rtuse 3 ja selleks on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email)
values (9, 'Ironman', 'i@i.com')

select * from Person

-- piirangu maha v]tmine
alter table Person
drop constraint DF_Persons_GenderId

---lisame uue veeru
alter table Person
add Age nvarchar(10)

--- lisame vanuse piirangu sisestamisel
--- ei saa lisada suuremat v''rtust kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

-- rea kustutamine
-- kui paned vale id, siis ei muuda midagi
delete from Person where Id = 9

select * from Person

-- kuidas uuendada andmeid tabelis
update Person
set Age = 50
where Id = 1

-- lisame juurde uue veeru
alter table Person
add City nvarchar(50)

-- k]ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k]ik, kes ei ela Gothami linnas
select * from Person where City != 'Gotham'
-- teine variant
select * from Person where not City = 'Gotham'
-- kolmas variant
select * from Person where City <> 'Gotham'

-- n'itab teatud vanusega inimesi
select * from Person where Age = 800 or Age = 35 or Age = 27
select * from Person where Age in (800, 35, 27)

-- n'itab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 20 and 35

-- wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
--n'itab, k]ik emailid, milles on @ märk
select * from Person where Email like '%@%'

--- näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

--- n'itab, kellel on emailis ees ja peale @-märki
-- ainult üks täht
select * from Person where Email like '_@_.com'

-- k]ik, kellel ei ole nimes esimene t'ht W, A, C
select * from Person where Name like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

-- k]ik, kes elavad Gothamis ja New Yorkis ning
-- üle 30 eluaasta
select * from Person where
(City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab t'hestikulises järjekorras inimesi
--- ja võtab aluseks nime

select * from Person order by Name
-- kuvab vastupidises järjekorras
select * from Person order by Name desc

-- võtab kolm esimest rida
select top 3 * from Person

--- 2 tund
--- muudab Age muutuja int-ks ja näitab vanuselises järjestuses
select * from Person order by CAST(Age as int)

--- kõikide isikute koondvanus
select SUM(CAST(Age as int)) from Person

--- näitab, kõige nooremat isikut
select MIN(CAST(Age as int)) from Person

--- näitab, kõige nooremat isikut
select Max(CAST(Age as int)) from Person

-- näeme konkreetsetes linnades olevate isikute koondvanust
-- enne oli Age string, aga päringu ajal muutsime selle int-ks
select City, SUM(cast(Age as int)) as TotalAge from Person group by City

--kuidas saab koodiga muuta tabeli andmetüüpi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

alter table Person
alter column Age int

-- kuvab esimeses reas välja toodud järjestuses ja muudab Age-i TotalAge-ks
-- teeb järjestuse vaatesse: City, GenderId ja järjestab omakorda City veeru järgi
select City, GenderId, SUM(Age) as TotalAge from Person
group by City, GenderId order by City

--- näitab, et mitu rida on selles tabelis
select COUNT(*) from Person

--- veergude lugemine
SELECT count(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Person'

--- näitab tulemust, et mitu inimest on genderId
--- väärtusega 2 konkreetses linnas
--- arvutab kokku vanuse
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

--- n'itab, et mitu inimest on vanemad, kui 41 ja kui palju igas linnas
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
group by GenderId, City having SUM(Age) > 41

-- loome uue tabelid
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
[Location] nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (2, 'Pam', 'Female', 3000, 3)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (3, 'John', 'Male', 3500, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (4, 'Sam', 'Male', 4500, 2)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (5, 'Todd', 'Male', 2800, 2)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (6, 'Ben', 'Male', 7000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (7, 'Sara', 'Female', 4800, 3)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (8, 'Valarie', 'Female', 5500, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (9, 'James', 'Male', 6500, NULL)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (10, 'Russell', 'Male', 8800, NULL)


insert into Department(Id, DepartmentName, Location, DepartmentHead)
values
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')


select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

---arvutame [he kuu palgafondi
select SUM(CAST(Salary as int)) from Employees
--- min palga saaja ja kui tahame max palga saajat,
--- siis min asemele max
select min(CAST(Salary as int)) from Employees

---lisame veeru nimega City
alter table Employees
add City nvarchar(30)

select * from Employees

-- [he kuu palgafond linnade l]ikes
select City, SUM(CAST(Salary as int)) as TotalSalary
from Employees
group by City

--linnad on t'hestikulises j'rjestuses
select City, SUM(CAST(Salary as int)) as TotalSalary
from Employees
group by City, Gender
order by City

---  loeb 'ra, mitu inimest on nimekirjas
select COUNT(*) from Employees

--- vaatame, et mitu t;;tajat on soo ja linna kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employees(s)]
from Employees
group by Gender, City

--n'itada k]iki mehi linnade kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employee(s)]
from Employees
where Gender = 'Male'
group by Gender, City

--- n'itab ainult k]ik naised linnade kaupa
select Gender, City, SUM(CAST(Salary as int)) as TotalSalary,
COUNT (Id) as [Total Employee(s)]
from Employees
group by Gender, City
having Gender = 'Female'

--- vigane p'ring
select * from Employees where SUM(CAST(Salary as int)) > 4000

-- t;;tav variant
select Gender, City, SUM(CAST(Salary as int)) as [Total Salary],
COUNT (Id) as [Total Employee(s)]
from Employees group by Gender, City
having SUM(CAST(Salary as int)) > 4000

--- loome tabeli, milles kahatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')

select * from Test1

---inner join
-- kuvab neid, kellel on DepartmentName all olemas v''rtus
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--- left join
--- kuidas saada k]ik andmed Employees-st k'tte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department  --v]ib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- n'itab k]ik t;;tajad Employee tabelist ja Department tabelist
--- osakonna, kuhu ei ole kedagi m''ratud
select Name, Gender, Salary, DepartmentName
from Employees
right join Department  --v]ib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--- kuidas saada k]ikide tabelite v''rtused ]hte p'ringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department  
on Employees.DepartmentId = Department.Id

--- v]tab kaks allpool olevat tabelit kokku ja
--- korrutab need omavahel l'bi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--- kuidas kuvada ainult need isikud, kellel on Department NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--- teine variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

-- kuidas saame deparmtent tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

-- full join
-- m]lema tabeli mitte-kattuvate v''rtustega read kuvab v'lja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

--- 3 tun 28,03,2023


-- tabeli muutmine koodiga, alguses vana tabeli nimi ja
-- siis uussoovitud nimi
sp_rename 'Department', 'Department123'

--kasutame Employees tabeli asemel lühendeid E ja M
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id


alter table Employees
add VeeruNimi int

--- inner join
--- näitab ainult managerId all olevate isikute väärtusi
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--- k[]ik saavad k]ikide [lemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select ISNULL('Asdasdasd', 'No Manager') as Manager

--- null asemel kuvab no manager
select coalesce(NULL, 'No Manager') as Manager

--- neil kellel ei ole [lemust, siis paneb neile No Manager tekst
select E.Name as Employee, ISNULL(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.Manager.Id = M.Id


-- lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30)

--- uuendame koodiga v''rtuseid
update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3

update Employees
set FirstName = 'Sam', MiddleName = NULL, LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

select * from Employees

--igast reast v]tab esimeses t'idetud lahtri ja kuvab ainult seda
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

--- sisetae tabelisse andmeidõ
insert into IndianCustamers(Name, Gmail)values
('Raj', 'R@R.com')
('Sam',  'S@S.com')

insert into UKCustomers(Name, Gmail)values
('Ben', 'B@B.com')
('Sam',  'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--- kasutame union all, mis n'itab k]iki ridu
select Id, Name, Email, from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--- kasutame union all, mis n'itab k]iki ridu
select Id, Name, Email, from IndianCustomers
union
select Id, Name, Email from UKCustomers
order by Name

--- stored procedure
create procedure spGetEmployees
as begin
select FistName, Gender from Employees
end

spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
--muutujaid defineeritakse @ m'rgiga
@Gender nvarchar(20),
@Department int
as begin
select FirstName, Gender, DepartmentId, from Employees
where Gender = @gender
and DepartmentId = @DepartmentId
    end
end
---saab vaadata sp sisu
sp_helptext spGetEmployeesByGenderAndDepartment


select PersonType, NameStyle, FirstName, MiddleName, LastName
from Person.Person
cross join Person.PersonPhone

select SalesQuota,Bonus, Name
from Sales.SalesPerson
RIGHT JOIN Sales.SalesTerritory
on Sales.SalesPerson.TerritoryID = Sales.SalesTerritory.TerritoryID


-

create spGetEmployeesAndDepartment
@Gender nvarchar(20)
@DepartmentId int
with encryption -- paneb v]tme peale
as begin
select Name, Gender, DepartmentId from Employees where Gender = @Gender
and DepartmentId = @DepartmentId
end


-- sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20)
@EmployeeCount int output
as begin
select @EmployeeCount = COUNT(Id) from Employees where Gender = @Gender
end

declare @TotalCount int
execute spGetEmployeeCountByGender 'asd', @TotalCount out
if(@TotalCount = 0)
print '@TotalCount is null'
else
print '@Total is not null'
print @Totalcount

---
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--- tabeli info
sp_help Employees
-- Kui soovid sp teksti n'ha
sp_helptext spGetEmployeeCountByGender


-- vaatame, millest s]ltub see sp
sp_depends spGetEmployeeCountByGender
--- saame teada, mitu asja s]ltub sellest tabelist
sp_depends Employees


create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
select @Name = Id, @Name = Name from Employees
end

spGetNameById 1, 'Tom'

create proc spTotalCount2
@TotalCount int output
as begin
select @TotalCount = COUNT(Id) from Employees
end


--- saame teada, et mitu rida andmeid on tabelis
Declare @TotalEmployees int
execute spTotalCount2 @TotalEmployees output
select @TotalEmployees


--- mis id all on keegi nime j'rgi
create proc spGetNameById1
@Id int,
@Name nvarchar(50) output
as begin
select @Name = Name from Employees where Id = @Id
end

--- annab tulemuse, kus id 1 real on keegi koos nimega
declare @Name nvarchar(50)
execute spGetNameById 1, @Name output
print 'Name of the employee = ' + @Name


declare
@Name nvarchar(20)
execite spGetNamebyId 1,@Name out
print 'Name = ' + @Name


create proc sp GetNameById2
@Id int
as begin
return (select Name from Employees where Id = @Id)
end

--- tuleb veateade kuna kutsusime v'lja int'i, agag Tom on string andmet[[p
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

---

--- sisseehitattud string funktsioon
--- see konberteerub ASCII tähe väärtuse numbriks
select ASCII('A')
--- näitab A-tähte
select CHAR (65)

--prindime kogu tähestiku välja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
select CHAR (@Start)
set @Start = @Start+1
end


--- eemaldame tühjad kohad sulgudes
select LTRIM('      Hello')
select RTRIM('        Hello')

--- tühikute eemaldamineveus
select * from dbo.Employees

select LTRIM(FirstName) as [First Name], MiddleName, LastName from Employees

--paremalt poolt tühjad stringid lõikan ära
select RTRIM('      Hello')
---keerab kooloni sees olevad andmed vastupidiseks 
---vastavalt upper ja lower-ga saan muuta märkide suurust
---reverse funktsioon pöörab kõik ymber
select REVERSE(UPPER(ltrim(FirstName)))as FirstName, MiddleName, LOWER(LastName),
RTRIM(LTRIM(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--näeb ära mitu tähemärki on nimes ja loeb tühikud sisse
select FirstName, LEN(FirstName) as [Total Characters] from Employees

--näeb ära mitu tähte on sõnal ja ei loe tyhikuid sisse
select FirstName, LEN(ltrim(FirstName)) as [Total Characters] from Employees


---left, right, substring
---vassakuult poolt neli esimest tähteheyhjh
select LEFT('ABCDEF', 4)

---paremalt poolt 3 tähte
select Right('ABCDEF', 3)

---kuvab @-tähemärgi asetust
select CHARINDEX('@', 'sara@aaa.com')

---esimene nr peale komakohta näitab et mitmendast alustab
---ja siis mitu nr peale seda kuvada
select SUBSTRING('pam@abc.com', 5, 4)

--@märgist kuvab kolm tähemärki. Viimase nr-ga saab määrata piikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)


---peale tähemärki reguleerin tähemärkide pikkuse näitamist
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 2,
LEN('pam@bbb.com') - charindex('@', 'pam@bbb.com'))

--saame teada domeeninimed emailides
select SUBSTRING (Email, CHARINDEX('@', Email) + 1,
LEN (Email) - charindex('@', Email)) as EmailDomain
from Employees

alter table Employees
add Email nvarchar(20)

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valari@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

select * from Employees



---lisame *-märgi teatud kohast
select FirstName, LastName,
    SUBSTRING(Email, 1, 2) + REPLICATE('*', 5) + ----peale teist tähemärki paneb viis tärni
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - charindex('@', Email)+1
from Employees

---kolm korda näitab stringis olevat väärtust
select REPLICATE('asd', 3)

---kuidas sisestada tyhikut kahe nime vahele
select SPACE(5)

---tühikute arv kahe nime vahel
select FirstName + SPACE(25) + LastName as FullName
from Emplyees
---PATINDEX
---sama mis CHARINDEX aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0 ---leiab kõik selle domeeni esindajad
---ja alates mitmendast märgist algab @


---kõik .com-id asendatakse .net-ga
select Email, Replace(Email, '.com', '.net') as Converted Email
from Employees

---sooovivn asendada peale esimest märki kolm tähte viiie tärniga
select FirstName, LastName, Email,
    STUFF(Email, 2, 3, '*****') as StuffedEmail
from Employees

---teeme tabeli
create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime
----konkreetsete masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values (GETDATE(), (GETDATE(), (GETDATE(), (GETDATE(), (GETDATE(), GETDATE())

select * from DateTime
update DateTime set c_datetimeoffset = '2023-04-11 11:50:34.9100000+03:00'
where c_datetimeoffset = '2023-04-11 11:50:34.9100000+03:00'

select CURRENT_TIMESTAMP, 'CURENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME' -- veel täpsem aja päring
select SYSDATETIMEOFFSET() --- UTC aeg


select ISDATE('asd') -- tagasstab 0 kuna string ei ole date 
select ISDATE(GETDATE()) ---tagastab 1 kuna on kp
select ISDATE('2023-04-11 11:50:34.9100000'--tagastab 0 kuna max kolm komakohta
select ISDATE('2023-04-11 11:50:34.910')-- tagastab 1
select DAY(GETDATE())-- annab tänase päeva nr
select DAY('03/31/2020')-- annab stringist oleva kp ja järjestus peab olema õige
select month(Getdate())-- annab jooksva kuu nr
select month('03/31/2020')--annab sringis olea kuu nr
select year(Getdate())-- annab jooksva aasta nr
select year('03/31/2020')--annab sringis olea aasta nr

--- 5 tund

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
    declare @tempdate datetime, @years int, @months int, @days int
    select @tempdate = @DOB

    select @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - case when (MONTH(@DOB) > (MONTH(GETDATE())) or (MONTH(@DOB)
    = month(GETDATE())) and DAY(@DOB) > DAY(GETDATE())) then 1 else 0 end
    select @tempdate = DATEADD(YEAR, @years, @tempdate)

    select @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - case when DAY(@DOB) > DAY(GETDATE()) - case when DAY(@DOB) > DAY(GETDATE()) then 1 else 0 end
    select @tempdate = DATEADD(MONTH, @months, @tempdate)

    select @days = DATEDIFF(DAY, @tempdate, GETDATE())

    declare @Age nvarchar(50)
    set @Age = CAST(@years as nvarchar(4)) + ' Years ' + CAST(@months as nvarchar(4)) ' Months ' CAST(@days as nvarchar(4)) + ' Days old '
    return @Age
end

alter table Employees
add DateOfBirth datetime

-- saame vaadata kasutajate vanust
select Id, FirstName, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as age from Employees

-- kui kasutame seda funktsiooni, siis saame teada tänase päeva vahe
--stringis välja toodud kuupäevaga
selectdbo.fnComputeAge('11/11/2010')

--nr peale DateOfBirth muutujat näitab, et mismoodi kuvada DOB
select Id, FirstName, DateOfBirth,
CONVERT(nvachar, DateOfBirth, 126) as ConvertedDDOB
from Employees

select Id, FirstName, LastName + ' - ' + CAST(Id as nvarchar)
as [Name-Id] from Employees


select CAST(GETDATE() as date) -- tänane kp
select CONVERT(date, GETDATE()) -- tänane kuupäev

--matemaatilised funktsioonid
select ABS(-101.5) --- ABS on absoluutne väärduse saamiseks
select CEILING(15.2)-- tagastab 16 ja suurendab suurema täisarvu suunas
select CEILING(-15.2) -- tagastab ja suurendab suurema positiivse täisarvu suunas
select FLOOR(15.2) -- ümardab negatiivsema nr poole
select FLOOR(-15.2) -- ümardab negatiivsema nr poole
select POWER(2, 4) -- hakkab korrutama 2*2*2*2, esimene nr on siis korrutatav nr
select SQUARE(9) -- antud juhul 9 ruudus
select SQRT(81) -- annab vastuse 9, ruutjuur

select RAND()
select FLOOR(RAND() * 100) -- korrutab sajaga iga suvalise numbri


--- 6 tund

---iga kord n'itab 10 suvalist nr-t
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
print floor(rand() * 1000)
set @counter = @counter + 1
end

select ROUND(850.556, 2)-- ümardab kaks kohta peale komat 850.560
select ROUND(850.556, 2, 1) --ümardab allapoole
select ROUND(850.556, 1) --ümardab ülespoole ja ainult esimene nr peale koma 850.600
select ROUND(850.556, 1, 1) --ümardab allapoole
select ROUND(850.556, -2) --ümardab esimese täisnr ülesse
select ROUND(850.556, -1) --ümardab esimese täisnr alla


---
create function dbo.CalculateAge (@DOB date)
returns int
as begin
declare @Age int
set @Age = DATEDIFF(YEAR, @DOB, GETDATE()) -
case
when (MONTH(@DOB) > MONTH(GETDATE())) or
(MONTH(@DOB) > MONTH(GETDATE()) and DAY(@DOB) > DAY(GETDATE()))
then 1
else 0
end
return @Age
end

execute CalculateAge '10/08/2020'

select * from Employees
-- arvutab välja, kui vana on isik ja võtab arvesse kuud ning päevad
--antud juhul näitab kõike, kes on üle 36 a vanad
select Id, FirstName, dbo.CalculateAge(DateOfBirth) as Age
from Employees
where dbo.CalculateAge(DateOfBirth) > 36

---lisame veeru juurde
alter table Employees
add DepartmentId int

-- scalar function annab mingis vahemikus olevaid andmeid,
-- aga inline table values ei kasuta begin ja end funktsioone
-- scalar annab väärtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, FirstName, DateOfBirth, DepartmentId, Gender
from Employees
where Gender = @Gender)

--- kõik female töötajad
select * from fn_EmployeesByGender('Female')


select * from fn_EmployeesByGender('Female')
where FirstName = 'Pam' --where abil saab otsingut täpsustada






---kahest erinevast tabelist andmete võtmine ja koos kuvamine
---esimene on funktsioon ja teine tabel
select FirstName, Gender, DepartmentName
from fn_EmplyeesByGender('Female')
E join Department D on D.Id = Employees.DepartmentId

---multi-table statement

---inline funktsioon
create function fn_GerEmployees()
returns table as 
return (select Id, FirstName, CAST(DateOfBirth as date)
        as DOB
		from Employees)

select * from fn_GetEmployees()
returns @Table Table(Id int, FirstName nvarchar(20), DOB date)
as begin
    insert into @Table
	select Id, FirstName, CAST(DateOfBirth as date) from Employees

	return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini töötamas kuna käsitletakse vaatena
--multi puhul on pm tegemist stored produceriga ja kulutab rohkem ressurssi

--saab andmeid muuta
update fn_GetEmployees() set FirstName = 'Sam1' where Id = 1
--ei saa andmeid muuta
update fn_MS_GetEmployees() set FirstName = 'Sam2' where Id = 1

select * from Employees


--ette määratud ja mitte-ettemääratud

select COUNT(*) from EMployees
select SQUARE(3) -- kõik tehtemärgid on ette määratud
--ja sinna kuuluvad veel sum, avg ja square

--mitte ettemääratud
select GETDATE()
select CURRENT_TIMESTAMP
select RAND()---see funktsioon saab olla mõlemas kategoorias
--kõik oleneb sellest kas sulgudes on 1 või ei ole


--loome funktsiooni

create function fn_GetNameById(@id int)
returns nvarchar(30)
as begin
    return (select FirstName from Employees where Id = @id)
end

select dbo.fn_GetNameById(7)

select * from Employees
sp_helptext fn_GetNameById

---loome funktsiooni mille sisu krüpteerime ära
create function fn_GetEmployeeNameById(@id int)
returns nvarchar(30)
as begin
    return (select FirstName from Employees where Id = @id)
end

---muudame funktsiooni sisu ja krüpteerime ära
create function fn_GetEmployeeNameById(@id int)
returns nvarchar(30)
with encryption
as begin
    return (select FirstName from Employees where Id = @id)
end

--tahame krüpteeritud funktsiooni sisu näha, aga ei saa
sp_helptext fn_GetEmployeeNameById

alter function fn_GetEmployeeNameById(@id int)
returns nvarchar(30)
with schemabinding
as begin
    return (select FirstName from Employees where Id = @id)
end

--temporary tables
--#-märgi ette panemisel saame aru, et tegemist on temp tabeliga
--seda tabelit saab ainult selles päringus avada
create table #PersonDetails(Id int,FirstName nvarchar(20))

insert into #PersonDetails values(1 'Mike')
insert into #PersonDetails values(2 'John')
insert into #PersonDetails values(3 'Todd')
--ül on otsida temporary tabel

select * from #PersonDetails

select Name from sysobjects
where FirstName like '#PersonDetails%'

---kustutame temp table
drop table #PersonDetails

--teeme stored prodedure
create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, FirstName nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
end

exec spCreateLocalTempTable

---globaalse temp tabeli tegemise
create table ##PersonDetails(Id int, FirstName nvarchar(20))

select * from Employees

select * from Employees
where Salary > 5000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse järjestusse
create index IX_Employee_Salary
on Employee (Salary asc)

--saame teada,et mis on selle tabeli primaarvõti ja inex
exec sys.sp_helpindex @objname = 'Employees'

---indexi kustutamine 
drop index Emplyees.IX_Employees_Salary

---indexi tüübid
--1. klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Verrgude indeksid
--10. Välja arvatud veergude indeksid

create table EmplyeeCity
(
Id int primary key,
Name nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(20)
)

exec sp_helpindex EmployeeCity
---andmete õige järjestuse loovad klastris olevad indeksid ja kasutab selleks Id nr-t
--põhjus, miks antud juhul kasutab Id-d, tuleneb primaarvõtmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')
 
  select * from EmployeeCity
  
  --klastris olevad indexiddikteerivad säilitadud andmete järjestuse tabelis
  --ja seda saab klastrite puhul olla inult üks

  create clustered index IX_EmployeeCity_Name
  on EmplyeeCity(Name)
  ---annab veateade et tabelis saab olla ainult üks klastris olev index
  --kui soovid indeksit luua siis pidid kustutama olemasoleva

  -- saame luua ainult ühe klastris oleva indeksitabeli peale
  --klastris olev indeks on analoogne telefoni suunakoodile

  --loome composite(Ühend) index-i
  --enne tuleb kõik teised klastris olevad indeksid ära kustutada

  create clustered index IX_Employee_Gender_Salary
  on EmployeeCity(Gender desc, Salary asc)

  drop index EmployeeCity.PK_Employee_3214EC07A2F8A69D
  --koodiga ei saa kustuda id aga käsitsi saab

  select * from EmployeeCity

  --erinevused indeksi vahel
  --1.ainult üks klastris olev indeks saab olla tabeli peale, 
  ---mitte klastris olevaid indekseid saab olla mitu 
 --2.klastris olevad indeksid on kiiremad kuna indeks peab tagasi viimatama tabeli 
 ---juhul kui selekteeritud veerg ei ole olemas indeksis
 ---3. klastris olev indeks määratleb ära tabeli ridade salvestusjärjestuse
 ---ja ei nõua kettal lisa ruumi. samas mitte klastris olevad indeksid on
 ---salvestatud tabelist eraldi ja nõuab lisa ruumi


 create table EmployeeFirstName
 (
 Id int primary key, 
 FirstName nvarchar(50),
 LastName nvarchar(50),
 Salary int,
 Gender nvarchar(10),
 City nvarchar(25)
 )

 exec sp_helpindex EmployeeFirstName

 insert into EmployeeFirstName values(1, 'Mike', 'Sandoz',  4500, 'Male', 'New York')
 insert into EmployeeFirstName values(1, 'John', 'Mendoz',  2500, 'Male', 'London ')

 drop index EmployeeFirstName.PK_Employee_3214EC07A2F8A69D
 --sql server kasutab UNIQUE indeksit jõustamiseks väärysue unikaalsus ja primaarvõtit
 --unikaalsed indekseid kasutatakse kindlustamaks väärtuste unikaalsust (sh primaarvõtme oma)

 create unique nonclustered index UIX_Employee_FirstName_LastName
 on EmployeeFirstName(FirstName, LastName)

 insert into EmployeeFirstName values(1, 'Mike', 'Sandoz',  4500, 'Male', 'New York')
 insert into EmployeeFirstName values(1, 'John', 'Mendoz',  2500, 'Male', 'London ')

 truncate table EmployeeFirstName

 --lisame uue unikaalse piirangu
 alter table EmployeeFirstName
 add constraint UQ_EmployeeFirstname_City
 unique ninclustered(City)

 --ei luba tabelisse väärtusega uut John Menoz-t lisada kuna see on juba
 insert into EmployeeFirstName values(3, 'John', 'Mendoz', 3500, 'Male', 'London')

 ---saab vaadata indeksite nimekirja 
 exec sp_helpconstraint EmployeeFirstName


 --1.Vaikimisi primaarvõti loob unikaalse klaastris oleva indeksi, samas
 --unikaalne piirang loob unikaalse mitte-klastris oleva indeksi
 --2. Unikaalset indeksit või piirangut ei saa luua  olemasolevasse tabelise, 
 ---kui tabel juba sisaldab väärtusi võtmeveerus
 --3. Vaiksimisi korduvaid väärtusied ei ole veerus lubatud,
 --kui peaks olema unikaalne indeks või piirang . NT, kui tahad sisestada 
 --10 rida andmeid millest 5 sisaldavad korduvaid andmeid siis kõik 10
 --lükatakse tagasi. Kui soovin ainutl 5 rea tagasi lükkamist ja ülejäänud 
 --5 rea sisetamist siis selleks kasutatakse IGNORE_DUP_KEY

 --koodnäide 
 create unique index IX_EmployeeFirstName
 on EmployeeFirstName(City)
 with ignore_dub_key

 --enne koodi sisestamist kustuta indeksi kaustas UQ_EmployeeFirstName_City ära
  insert into EmployeeFirstName values(3, 'John', 'Mendoz', 3512, 'Male', 'London')
  insert into EmployeeFirstName values(4, 'John', 'Mendoz', 3123, 'Male', 'London1')
  insert into EmployeeFirstName values(3, 'John', 'Mendoz', 3520, 'Male', 'London1')
  --enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne
  --nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne

  ---view

  ---view on salvestatud Sql-i päring . Saab käsitleda ka virtuaalse tabelina

  select FirstName, Salary, Gender, DepartmentNamefrom Employees
  from Employees
  join Department
  on Employees.DepartmentId = Department.Id

  ---loome viewõ
  create view vEmployeesByDepartment
  as
      select FirstName, Salary, Gender, DepartmentName
	  from Employees
	  join Department
on Employees DepartmentId = Department.Id

select * from vEmployeesByDepartment

--view ei salvesta andmeid vaikimisi
--seda tasub võtta, kui salvestatud virtuaalse tabelina

--milleks vaja:
--saab kasutada andmebaasi skeemi keerukuse lihtsustamiseks,
--mitte It-inimestele
--piiratud ligipääs andmetele, ei näe kõiki veerge

---teeme veeru, kus näeb ainult IT-töötajaid
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where Department.DepartmentName = 'IT'
--seda päringut saab liigitada reatasema turvalisuse alla 
--tahan ainult IT inimesi näidata
select * from vITEmployeesInDepartment

--saab kasutada esitlemiseks koondandmeid ja üksikasjalike andemid
--view mis tagastab summeertiud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, COUNT(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group * from vEmployeescountByDepartment

---
