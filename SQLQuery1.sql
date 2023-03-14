-- komm
-- teeb andmebaasi ehk db
create database TARpe22

-- kustutamine db
drop database TARpe22

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--- andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'male')
insert into Gender (Id, Gender)
values (1, 'female')
insert into Gender (Id, Gender)
values (3, 'unknown')

-- sama Id v"rtusega rida ei saa sisestada
select * from Gender

--- teeme uue tabeli
create table Person
(
    Id int not null primary key,
    name nvarchar(30),
    Email nvarchar(30),
    GenderId int
    )

---vaatame Person tabeli sisu
select * from person

---andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (2, 'wonderwoman', 'w@w.com.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (3, 'Batman', 'b@b.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (4, 'Aquaman', 'a@a.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (5, 'Catwoman', 'c@c.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (6, 'Antman', 'ant@ant.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (8, NULL, NULL, 2)

select * from person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(id)

---kui sisestad uue rea andmeid ja ei ole sisestanud GenderId all v''rtuse
---see automaatselt sisestab tabelisse v''rtuse 3 ja selleks on unknwon
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
add age nvarchar(10)

--- lisame vanus piirangu sisestamisel
--- ei saa lisada suuremat v''rtust kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

-- rea kustutamine
-- kui paned vale id, siis ei muuda midagi
delete from Person where Id = 10

select * from Person

--kuidas uuendada andmeid tabelis
update Person
set Age = 50
where Id = 1

-- lisame juurde uue veeru
alter table Person
add City nvarchar(50)

-- k]ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k]ik, kes ei ela Gothami linnas
select * from Person where City !='Gotham'
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
-- n'itab, k]ik emailid, milles on @ märk
select * from Person where Email like '%@%'

--- näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

--- n'itab, kellel on Emailis ees ja peale @-märki
-- ainult üks täht
select * from Person where Email like '_@_.com'

-- k]ik, kellel ei ole nimes esimene t'ht W, A, C
select * from Person where Name like '[^WAC]%'

--- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

-- k]ik, kes elavad Gothamis ja New Yorkis ning
-- alla 30 eluaastat
select * from Person where
(City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab t'hestikulises järjekorras inimesi
--- ja võtab aluseks nime

select * from Person order by Name
-- kuvab vastupidises järjekorras
select * from Person order by name desc

-- võtab kolm esimest rida
select top 3 * from Person

--- muudab age muutuja int-ks ja näitab vanuselises järiestuses
select * from Person order by cast(Age as int)

--- kõikide isikute koondvanus
select SUM(CAST(Age as int))from Person

--- näitab, kõige nooremat isikut
select MIN(CAST(Age as int)) from Person

--- näitab, kõige nooremat isikut
select MIN(CAST(Age as int)) from Person

-- näeme konkreetsetes linnades olevate isikute koondvanust
-- enne oli age string, aga päringu ajal muutsime selle int-ks
select City, SUM(CAST(Age as int)) as TotalAge from Person groub by City

--kuidas saab koodiga muuta tabeli andmetüüpi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

alter table Person
alter column Age int


--kuvab esimeses reas välja toodud järjestused ja muudab Age-i TotalAge-ks
--teeb järjestuse vaatesse: City, GenderId ja järjestab omakorda City veeru
select City, GenderId, SUM(Age) as TotalAge from Person
group by City, GenderId order by City

--näitab, et mitu rida on selles tabelis
select COUNT(*) from Person


---veergude lugemine
SELECT count(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Person'

---näitab tulemust, et miu inimest on genderId 
---väärtusega 2 konkreetses linnas
---arvutab kokku vanuse
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

---näitab, et mitu inimest on vanemad, kui 41 ja kui palju igas linnas
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
group by GenderId, City having SUM(Age) > 41

--loome uue tabeli
create table Department
(
Id int primary key, key
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

insert into Employs (id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', '4000', 'IT')
