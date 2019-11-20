
/********************************************************************************************
DATA GENERATION FOR NAMES, ADDRESSES, PHONES, AND EMAILS, RUNS IN 37 S
********************************************************************************************/

	drop table zharbor.fullName;
	drop table zharbor.addr;
	drop table zharbor.phone;
	drop table zharbor.email;
--make some info tables
	create table zharbor.fullName (fn varchar (50));
	create table zharbor.addr (addr varchar (50));
	create table zharbor.phone (number varchar(12));
	create table zharbor.email (email varchar(50));

--fill info tables
--name
insert into zharbor.fullName
select top 20000 list.fullName
from
(
	(select m.name + ' ' + s.name fullName
	from Fall2018.RandomNames.baseMaleName m
		cross join Fall2018.RandomNames.baseSurname s) 
			union
	(select f.name + ' ' + s.name fullName
	from Fall2018.RandomNames.baseFemaleName f
		cross join Fall2018.RandomNames.baseSurname s)
) list
order by NEWID();


--addr
delete from zharbor.addr;
insert into zharbor.addr
select top 60000 
	cast(a.number as varchar) + ' ' + b.direction + ' ' + c.street + ' ' + d.city 
from 
	Fall2018.Lab3.addressA a,
	Fall2018.Lab3.addressB b,
	Fall2018.Lab3.addressC c,
	Fall2018.Lab3.addressD d
order by NEWID();
select * from zharbor.addr;


--phone
insert into zharbor.phone
select cast(num.number as varchar(12)) 
from
(	select 
		abs((checksum(newid()) % 10000000000)) number
	from 
		zharbor.addr) num
where num.number > 1000000000


--email
delete from zharbor.email;
insert into zharbor.email
select top 900000 m.name + s.name + cast(s.id%100 as varchar) + '@gmail.com'
from Fall2018.RandomNames.baseSurname s,
	Fall2018.RandomNames.baseMaleName m
order by NEWID();