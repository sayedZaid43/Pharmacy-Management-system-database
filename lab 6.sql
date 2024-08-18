--1- Create Scalar function name GetEmployeeSupervisor Type: Scalar Description: 
--Returns the name of an employee's supervisor based on their SSN.
create function GetEmployeeSupervisor(@id int)
returns varchar(20)
  begin 
     declare @name varchar(20)
	 select @name = St_Fname
	 from Student
	 where St_Id = @id 

	 RETURN @name
  end 

 select dbo.GetEmployeeSupervisor (2)

 --2-	Create Inline Table-Valued Function GetHighSalaryEmployees
--Description: Returns a table of employees with salaries higher than a specified amount.

create function GetHighSalaryEmployees( @sal int )
returns table 
as 
return 
(
select Fname , Salary as big_salary
from Employee
where salary > @sal
)

select * from GetHighSalaryEmployees (1000)


--3-	Multi-Statement Table-Valued Function - GetProjectAverageHours Type: 
--Multi-Statement Description: Returns the average hours worked by employees on a specific project as a table.
create function GetStudents(@pno int)
returns table 
as
return
(select AVG(hours) as avg
		 from Employee E inner join Works_for W
		 on E.SSN=W.ESSn
		 where Pno= @pno
		 )


select * from GetStudents(100)

--4-	Create function with name GetTotalSalary Type: 
--Scalar Function Description: Calculates and returns the total salary 
--of all employees in the specified department.
create function GetTotalSalary(@Dno int)
returns int
	begin
	declare @total int
	select @total = sum(salary)
	from Employee
	where Dno= @Dno
	return @total
	end


select dbo.GetTotalSalary(20)


--5-	Create function with GetDepartmentManager Type: 
--Inline Table-Valued Function Description: Returns the manager's name and details for a specific department.
create function GetDepartmentManager(@deptno int)
returns table 
as
return
(
select fname, Dname
from Employee E inner join Departments D
on E.Dno=D.Dnum
where SSN = MGRSSN and Dno = @deptno
)


select * from GetDepartmentManager(10)

-------------------------------------------iti------------------------------------------------------------------

--1.	Table-Valued Function - Get Instructors with Null Evaluation: 
--This function returns a table containing the details of instructors who have null evaluations for any course




create function GetInstructorswithNull(@eva varchar(10))
returns @t table (id int , ename varchar(30), degree varchar(30), salary int,dept int)
as
 begin 
     if (@eva = 'null')
	 begin
		 insert into @t
		 select distinct I.Ins_Id, ins_name, ins_degree, salary, dept_id
	     from Instructor I inner join Ins_Course IC
	     on I.Ins_Id=IC.Ins_Id
		 where IC.Evaluation is null
	 end
	 else
	 begin
	 insert into @t
		 select distinct I.Ins_Id, ins_name, ins_degree, salary, dept_id
	     from Instructor I inner join Ins_Course IC
	     on I.Ins_Id=IC.Ins_Id
		 where IC.Evaluation is null
	 end

	 return
  end
  
  select * from GetInstructorswithNull('null')
--2.	Table-Valued Function - Get Top Students: 
--This function returns a table containing the top students based on their average grades. not****

create function Gettopstudent (@tops int)
returns table
as
return
(
select top (5) avg(grade) as avg_grade, st_fname, sc.st_id
from Student s inner join Stud_Course sc
on s.St_Id=sc.St_Id
group by sc.St_Id, St_Fname
order by avg_grade desc
)
select * from Gettopstudent(5)
--create function Gettopstudent (@tops varchar(20))
--returns @t2 table ( id int, fname varchar(30))
--as 
-- begin
--	if (@tops = 'top_student')
--		begin
--			insert into @t2
--			select SC.St_Id, st_fname
--			from Stud_Course SC inner join Student S
--			on SC.St_Id=S.St_Id
--			group by SC.St_Id, St_Fname
--			order by AVG(Grade)
--		end
--		else
--		begin
--			insert into @t2
--			select SC.St_Id, st_fname
--			from Stud_Course SC inner join Student S
--			on SC.St_Id=S.St_Id
--			group by SC.St_Id, St_Fname
--			order by AVG(Grade)
--		end

--		return
--	end

--	select * from  Gettopstudent('top_student')
--	select * from  Gettopstudent(5)

--3.	Table-Valued Function - Get Students without Courses: 
--This function returns a table containing details of students who are not registered for any course.
create function Getloserstudent()
returns table 
as
return
(
select s.*
from Student s left join Stud_Course sc
on s.St_Id=sc.St_Id
where sc.St_Id is null 
)

select * from Getloserstudent()




--create function Getloserstudent (@nocourse varchar(30))
--returns @t3 table (id int, fname varchar(30), lname varchar(30), address varchar(30), dept int, supr int)
--as 
--	begin
--		if (@nocourse = 'stud woth no course')
--		begin
--			insert into @t3
--			select S.St_Id, St_Fname, St_Lname, St_Address, Dept_Id, St_super
--			from Student S full join Stud_Course SC
--			on S.St_Id=SC.St_Id
--			where SC.St_Id is null
--		end
--		else
--		begin
--		insert into @t3
--			select S.St_Id, St_Fname, St_Lname, St_Address, Dept_Id, St_super
--			from Student S full join Stud_Course SC
--			on S.St_Id=SC.St_Id
--			where SC.St_Id is null
--		end
--		return
--	end

--	select * from Getloserstudent ('stud woth no course')