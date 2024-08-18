--1.	Create a view that shows 
--the project number and name along with the total number of hours worked on each project.

create view vhpro 
as 
select pname, pnumber, count(hours) as total_number
from Project P inner join Works_for W
on P.Pnumber=W.Pno
group by Pname, Pnumber

select *
from vhpro

--2.	Create a view that displays 
--the project number and name along with the name of the department managing the project.
create view vdpro
as
select pname, pnumber, dname
from Project P inner join Departments D
on P.Dnum=D.Dnum

select * from vdpro

--3.	Create a view that displays 
--the names and salaries of employees who earn more than their managers.
create view vsemp
as
select fname, salary
from Employee E
where Salary > (select E2.salary from Employee E2 where E2.SSN=E.Superssn)

select * from vsemp

--4.	Create a view that displays 
--the department number, name, and the number of employees in each department.
create view vedept
as
select Dnum, Dname, count(SSN) as No_of_emp
from Employee E inner join Departments D
on E.Dno=D.Dnum
group by Dnum, Dname

select * from vedept

--5.Create a view that lists the project name, location, 
--and the name of the department managing the project, but exclude projects without a department.
create view vpdept
as 
select pname, pnumber, plocation, dname
from Project P inner join Departments D
on P.Dnum=D.Dnum
where P.Dnum is not null

select * from vpdept

--6.	Create a view that displays 
--the average salary of employees in each department, along with the department name.
create view vsdept
as 
select AVG(salary) as AVG_salary , dname
from Employee E inner join Departments D
on E.Dno=D.Dnum
group by  Dname

select * from vsdept

--7.	Create a view that displays 
--the names of employees who have dependents, along with the number of dependents each employee has.
create view vrelated
as
select fname, count(*) as No_of_depen
from Employee E inner join Dependent N
on E.SSN=N.ESSN
group by Fname

select * from vrelated

--8.	Create a view that shows the project name and location 
--along with the name of the department managing the project, ordered by project number.

create view vpdept2
as 
select  pname, plocation, dname     -----why? is there any other way??
from Project P inner join Departments D
on P.Dnum=D.Dnum
order by P.Pnumber


select * from vpdept2


--9.Create a view that displays the full name (first name and last name), salary, and 
--the name of the department for employees working in the department with the highest average salary.
create view view9
as
select  CONCAT(fname,' ', lname) as full_name, salary, dname
from Employee E inner join Departments D
on E.Dno=D.Dnum
where d.Dnum = (select top 1 D.Dnum from Employee E inner join Departments D
on E.Dno=D.Dnum group by d.Dnum order by AVG(salary) desc)

select * from view9

--10.	Create a view that lists the names and ages of employees and 
--their dependents (if any) in a single result set. The age should be calculated based on the current date.
create view view10
as 
select fname, datediff(YEAR, E.Bdate, GETDATE()) as employee_age, Dependent_name, datediff(year, N.Bdate, getdate()) as dependent_age
from Employee E inner join Dependent N
on E.SSN=N.ESSN

select * from view10


--11.	Create a view that shows the project number, name, location, and 
--the number of employees working on each project, but exclude projects with no employees.
create view view11
as 
select pnumber, pname, plocation, count(ESSn) as No_of_emp
from Project P inner join Works_for W
on P.Pnumber=W.Pno
where W.ESSn is not null
group by P.Pnumber, P.Pname, P.Plocation

select * from view11

--12.	Create a view that displays the names and salaries of employees who 
--earn more than the average salary of their department.
create view view12
as
select fname, salary
from Employee E
where Salary > (select AVG(salary) from Employee E2 where E2.Dno = e.Dno )

select * from view12


--13.	Create a view that displays the names and salaries of employees 
--who have dependents, along with the number of dependents each employee has.
create view view13
as
select fname, salary, count(*) as No_of_family_mem
from Employee E inner join Dependent N
on E.SSN=N.ESSN
group by Fname, Salary

select * from view13

--------------------------------------------Part2-----------------------------------------------------------
--1.	Make a rule that makes sure the value is 
--less than 1000 then bind it on the Salary in Employee table.
CREATE rule r1 as @y<1000

sp_bindrule r1 , 'employee.salary'


--2.	Create a new user data type named loc with the following Criteria:
--•	nchar(2)
--•	default: NY 
--•	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the location column
create type loc  from nchar(2)
create default def1 as 'NY'
sp_bindefault def1 , loc 

create rule r2 as @x in ('NY','DS','KW')
sp_bindrule r2 , loc

--3.	Create a New table Named newStudent, and 
--use the new UDD on it you just have made and ID column and don’t make it identity.

create table newStudent
(
id int primary key,
new_column loc
)

insert into newStudent
values(1, 'ny')

insert into newStudent  -- does not work 
values(1, 'voo')

--4.	Create a new sequence for the ID values of the previous table.
CREATE SEQUENCE sequence1
start with 3
increment by 1
--a.	Insert 3 records in the table using the sequence.
insert into newStudent
values (next value for sequence1 , 'ny'),
	   (next value for sequence1 , 'ds'),
	   (next value for sequence1 , 'kw')
--b.	Delete the second row of the table.
delete from newStudent
where id= 3

--c.	Insert 2 other records using the sequence.
insert into newStudent
values (next value for sequence1 , 'ds'),
	   (next value for sequence1 , 'kw')
--d.	Can you insert another record without using the sequence? Try it!
insert into newStudent
values (10 , 'ds')            --Yes
--Can you do the same if it was an identity column?
create table test1 
( id int primary key identity,
tName varchar (50),
tAge int)

insert into test1              --No
values (1, 'sayed', 25) 

insert into test1              --Yes
values ('sayed', 25)
--e.	Can you edit the value if the ID column in any of the inserted records? Try it!
update newStudent          --Yes
set id +=1 
--Can you do the same if it was an identity column?
update test1          --No
set id +=1 
--f.	Can you use the same sequence to insert in another table?

--Yes

--g.	If yes, do you think that the sequence will start from its initial value in the new table and insert the same IDs that were inserted in the old table?

???????????????????????????????????????????

s

--CREATE TYPE OverTimeValue FROM int NOT NULL

--create rule greater_than1000 as @s >1000
--go
--create default def3 as 5000
--go
--sp_bindrule greater_than1000 , OverTimeValue
--go
--sp_bindefault def3 , OverTimeValue


