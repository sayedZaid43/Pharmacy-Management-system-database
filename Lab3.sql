--1	Display all the employees Data.
select *
from Employee

--2 Display the employee First name, last name, Salary and Department number.
select fname, lname, salary, dno
from Employee

--3	Display all the projects names, locations and the department which is responsible about it.
select pname, plocation, dnum
from Project
--4 If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
SELECT fname+ ' ' + lname as 'full name', salary*12*0.1 as annaul_comm
from Employee

--5	Display the employees Id, name who earns more than 1000 LE monthly.
select ssn, fname as big_salary
from Employee
where Salary > 1000

--6 Display the employees Id, name who earns more than 10000 LE annually.
select ssn, fname as 'big salary annaul'
from Employee
where salary*12 > 10000

--7 Display the names and salaries of the female employees 
select fname, salary
from Employee
where sex = 'F'

--8 Display each department id, name which managed by a manager with id equals 968574
select dnum, dname
from Departments
where MGRSSN = 968574

--9 Dispaly the ids, names and locations of  the pojects which controled with department 10
select pnumber, pname, plocation
from Project
where dnum = 10

--10 Display the Department id, name and id and the name of its manager
select dnum, dname, ssn, fname
from Departments inner join Employee
on MGRSSN = SSN

--11 Display the name of the departments and the name of the projects under its control.

select dname, pname
from Departments inner join Employee
on Dnum = Dno
inner join Works_for
on SSN = ESSn
inner join Project
on Pno = Pnumber
-------------------------------- 
select dname, pname
from Departments D inner join Project P
on D.Dnum = P.Dnum


--12 Display the full data about all the dependence associated with the name of the employee they depend on him/her
select D.*, E.fname
from Employee E inner join Dependent D
on E.SSN = D.ESSN


--13 Display the Id, name and location of the projects in Cairo or Alex city.
select pnumber, pname, plocation
from Project
where City in ('Cairo', 'Alex')

--14 Display the Projects full data of the projects with a name starts with "a" letter.
select *
from Project
where Pname like 'a%'

--15 display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select *
from Employee
where Salary between 1000 and 2000

--16 Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project
select fname
from Works_for inner join Employee
on ESSn = SSN
inner join Project
on Pno = Pnumber
where Hours >= 10 and Pname = 'Al Rabwah' and Dno = 10  -------why just one ?


--17 Find the names of the employees who directly supervised with Kamel Mohamed.
select E.fname
from Employee E inner join Employee S
on E.Superssn = S.SSN
where S.fname = 'kamel'

--18 Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name
select E.fname, P.pname
from Employee E inner join Departments D
on E.Dno = D.Dnum
inner join Project P
on D.Dnum = P.Dnum
order by 2 

--19 For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select *from Employee
select *from Project
select *from Departments

select P.Pnumber, D.dname, lname as 'manager last name', address, Bdate
from Project P  inner join Departments D
on P.Dnum = D.Dnum
inner join Employee 
on SSN = D.MGRSSN
where P.city = 'Cairo'

--20 Display All Data of the mangers
select E.*
from Departments D inner join Employee E
on D.MGRSSN = E.SSN

--21 Display All Employees data and the data of their dependents even if they have no dependents
select E.*, N.*
from Employee E left join Dependent N
on E.SSN = N.ESSN


--DML

--Data Manipulating Language:
--1.Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee
values('Sayed', 'Abozaid', 102672, 1999-4-17, 'sohage', 'M', 3000, 112233, 30)

--2.Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or manager number to him.
insert into Employee (fname, lname, SSN, Bdate, Address, Sex, Dno)
values('ali', 'Mohamed', 102673, 1999-7-17, 'sohage', 'M', 20)


--3.Upgrade your salary by 20 % of its last value
update Employee
set Salary = Salary*1.2
where Fname = 'Sayed'





