    --DQL

--1 For each project, list the project name and the total hours per week (for all employees) spent on that project.
select pname, sum(hours) as 'total hours'
from Project P inner join Works_for W
on P.Pnumber = W.Pno
group by Pname 


--2 Display the data of the department which has the smallest employee ID over all employees' ID.
select * 
from Employee
where ssn = (select min(ssn) from Employee)


--3 For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select max(salary), min(salary), avg(salary), dname
from departments D inner join employee E
on D.dnum = E.dno
group by dname


--4 List the last name of all managers who have no dependents.
select lname
from Departments D inner join Employee E
on D.Dnum = E.Dno 
left join Dependent N
on N.ESSN = E.SSN 
where MGRSSN = SSN and ESSN is null 


--5 For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select count(ssn) as 'No. of Employe', dname, dnum
from Departments D inner join Employee E
on D.Dnum = E.Dno
group by Dnum , Dname
having AVG(Salary) < (select AVG(salary) from Employee)


--6.	Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.
select fname, pname
from Departments D inner join Employee E
on D.Dnum = E.Dno
inner join Project P
on D.Dnum = P.Dnum
order by Pname, Lname,Fname

--7.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 
update Employee
set Salary = 1.3*Salary
from Departments D inner join Employee E
on D.Dnum = E.Dno
inner join Project P
on D.Dnum = P.Dnum
where Pname = 'Al Rabwah'


--8.	 Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select SSN, Fname
from Employee
where exists (select ESSN from Dependent 
			where ESSN = SSN)


--------------Lab5--------------------------

--1.	 Simple Subquery: Write a query to find 
--all courses with a duration longer than the average course duration.
select Crs_Name
from Course
where Crs_Duration > (select AVG(Crs_Duration) from Course)


--2.	 Correlated Subquery: Find the names of students who are 
--older than the average age of students in their department.
SELECT St_Fname, St_Lname 
FROM Student S
WHERE St_Age > (
    SELECT AVG(St_Age)
    FROM Student S2
    WHERE S2.Dept_Id = S.Dept_Id)


--3.	 Subquery in FROM Clause: Create a list of departments and the number of instructors in each,
-- using a subquery.
select Dept_Name, no_of_ins
from Department
join (select Dept_Id , count(Ins_Id) as no_of_ins
	  from Instructor  where  Dept_Id is not null
	  group by Dept_Id) as ins
	  on  ins.Dept_Id = Department.Dept_Id 
	  
	  
-------------Easier Solution ------------------------------
select Dept_name, count(ins_id) as 'No. of instructors'
from Department D inner join Instructor I
on D.Dept_Id = I.Dept_Id
group by Dept_Name

--4.	Subquery in SELECT Clause: For each student, 
--display their name and the number of courses they are enrolled in.
select st_fname,
(select count(Stud_Course.crs_id) from Stud_Course where  Stud_Course.st_Id = student.st_Id ) 
from Student inner join Stud_Course
on Stud_Course.St_Id = Student.St_Id

--------------------------------another answer-----------------------------------
select st_fname, COUNT(stud_course.Crs_Id)
from Student inner join Stud_Course
on Student.St_Id=Stud_Course.St_Id
inner join Course
on Stud_Course.Crs_Id=Course.Crs_Id
group by student.St_Id, St_Fname


--5.	Multiple Subqueries: Find the name and salary of the instructor
--who earns more than the average salary of their department.
select ins_name, salary
from Instructor I 
where Salary > (select AVG(salary) from Instructor I2 where I.Dept_Id = I2.Dept_Id)

--select AVG(salary),Dept_Id
--from Instructor
--group by Dept_Id 


--6.	UNION: Combine the names of all students and instructors into a single list.
select st_fname
from Student
union all
select ins_name
from Instructor


--7.	UNION with Condition: Create a list of courses that 
--either have a duration longer than 50 hours or are taught by an instructor named 'Ahmed'.
select crs_name
from Course
where Crs_Duration > 50
union all
select Crs_Name
from Course inner join Ins_Course
on ins_course.Crs_Id=Course.Crs_Id
inner join Instructor
on Ins_Course.Ins_Id=Instructor.Ins_Id
where Ins_Name= 'Ahmed'


--8.	Subquery with EXISTS: 
--List all departments that have at least one course with a duration over 60 hours.	
select distinct dept_name
from Department inner join Student           --which way is the best way from the diagram?
on Department.Dept_Id=Student.Dept_Id
inner join Stud_Course
on Student.St_Id=Stud_Course.St_Id
inner join Course
on Course.Crs_Id=Stud_Course.Crs_Id
where exists ( select Crs_Id from Course where Crs_Id is not null and Crs_Duration > 60)


--9.	Subquery with EXISTS: 
--List all departments that have at least one course with a duration over 60 hours.


--10.	TOP Clause: Select the top 5 highest-graded students in the 'SQL Server' course.
select top 5 st_fname
from student inner join stud_course
on stud_course.St_Id=student.St_Id
order by Grade desc


--11.	TOP with Ties: Show the top 3 departments with the most courses .
select top 3 with ties Dept_Name 
from Department 
join (select dept_id, count(crs_id) as no_of_course
	  from stud_course inner join Student 
      on stud_course.st_id=student.st_id
	  group by dept_id) as S
on Department.Dept_Id = S.dept_id
order by no_of_course


--12.	Subquery with IN: Find all students who are enrolled in 'C Programming' or 'Java'.
select st_fname
from Student inner join Stud_Course
on Student.St_Id=Stud_Course.St_Id
inner join Course
on Stud_Course.Crs_Id=Course.Crs_Id
where crs_name in ('C Progamming' , 'Java')

--select Crs_Name from Course where Crs_Name in ('C Progamming' , 'Java')

--13.	Complex UNION: Create a list of 
--all courses and instructors, showing course names and instructor names in separate columns.
select *
from (select
	  st_fname from Student where St_Fname is not null
			union
	  select
	  ins_name from Instructor where Ins_Name is not null) as sub

	  -----------------------------------
with dat
as(
select
	  st_fname from Student where St_Fname is not null
			union
	  select
	  ins_name from Instructor where Ins_Name is not null
)

select 
case when St_Fname is not null then St_Fname end as A
case when ins_name is not null then ins_named end as B
from dat


--14.	Subquery in WHERE Clause: Identify students 
--who are taking courses that are longer than the average duration of all courses.
select distinct st_fname
from Student inner join Stud_Course
on Student.St_Id=Stud_Course.St_Id
inner join Course
on Course.Crs_Id=Stud_Course.Crs_Id
where Crs_Duration > (select AVG(crs_duration) from Course)


--15.	Combining TOP and Subquery: 
--Display the top 10% of courses based on the number of students enrolled.
select * 
from (
where rowno <= floor(countrows*0.1+0.9)
order by ID, rowno
