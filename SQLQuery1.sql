--- 1 tund

create database TARpe22

-- db kustutamine
drop database TARpe22

-- tabeli loomine









id int not null primary key
Gender nvarchar(10) not null
)

---andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male')
insert into Gender (Id, Gender)
values (1, 'Female')
insert into Gender (id, Gender)
values (3, 'Unknown')

---sama Id väärtustega rida ei saa sisestada 
select * from Gender

---teeme uue tabeli
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
values (2, 'Wonderwoman', 'w@w.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (3, 'Batman', 'b@b.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (4, 'Aquaman', 'a@a.com', 2)
insert into Person (Id, Name, Email, GenderId)
values (5, 'Catwoman', 'c@c.com', 1)
insert into Person (Id, Name, Email, GenderId)
values (6, 'Superman', 'ant"ant.com', 2)

values (8, NULL, NULL, 2)

select * from Person

---võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

---kui sisestad uue rea andmeid ja ei ole sisetanud GenderId väärtust,
---see automaatselt sisestab tabelisse väärtuse 3 ja selleks on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id,Name, Email, GenderId)
values (9'Ironman' ,'i@i.com', NULL)

select * from Person

---piirangu maha võtmine
alter table Person
drop constrait DF_Persons_GenderId

--lisame uue veeru
alter table Person
add Age nvarchar(10)

---lisame vanuse piirangu sisetamisel
---ei saa lisada suuremat väärtust kui 801
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 801)

-- rea kustutamine
-- kui paned vale Id, siis ei muutu midagi
delete from Person where Id = 9

select * from Person

-- kuidas uuendada andmeid tabelis
update Person
set Age = 50
where Id = 1

-- lisame juurde uue veeru
alter table Person
add City nvarchar(50)

-- kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- kõik, kes ei ela Gothami linnas
select * from Person where City != 'Gotham'
-- teine variant
select * from person where not City = 'Gotham'
-- kolmas variant
select * from person where City <> 'Gotham'

--näitab teatud vanusega inimesi
select * from Person where Age = 800 or Age = 35 or Age = 27
select * from Person where Age in (800, 35, 27)

--näitab teatud vanusevahemikus olevaid inimesi
select * from, Person where Age between 20 and 35

--wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
-- näitab kõik emailid, milles on @ märk
select * from Person where Email like '%@%'

--- näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%"%'

 --- näitab, kellel on emailis ees ja peale @-märki 
 ---ainuly üks täht
 select * from Person where Email like '_@_.com'

 -- kõik, kellel ei ole nimes esimene täht W,A,C
 select * from Person where name lke '[^WAC]%'

 --- kes elavad Gothamis ja New Yorkis 
 select * from Person where (City = 'Gotham' or City = 'New York')

 -- kõik, kes elavad Gothamis ja New Yorkis ning
 -- alla 30 eluaastat
 select * from Person where (City = 'New York')
 and Age >= 30

 --- kuvab tähestikulises järjekorras inimesi
 --- ja võtab  aluseks nime

 select * from Person order by Name
 -- kuvab vastupidises järjekorras
 select * from Person order by Name desc


 -- võtab kolm esimest rida 
 select top 3 * from Person

 --- 2 tund