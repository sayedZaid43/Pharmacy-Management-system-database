--SELECT SQLText.text
--FROM sys.dm_exec_cached_plans plans
--OUTER APPLY sys.dm_exec_sql_text(plans.plan_handle) SQLText        
--WHERE SQLText.text LIKE '%Catalogue.Logins%'

--SELECT SQLText.text
--FROM sys.dm_exec_cached_plans plans
--OUTER APPLY sys.dm_exec_sql_text(plans.plan_handle) SQLText        
--WHERE SQLText.text LIKE '%<some text that we know was in the script>%'


--Use <ITI_new>
--SELECT execquery.last_execution_time AS [Date Time], execsql.text AS [Script] FROM sys.dm_exec_query_stats AS execquery
--CROSS APPLY sys.dm_exec_sql_text(execquery.sql_handle) AS execsql
--ORDER BY execquery.last_execution_time DESC
--------------------------------------------------------------------------------------------------------------------------------
--Problem 1: Calculate Total Salary for Each Department
--Description: Calculate the total salary for each department and display the department name along with 
--the total salary
declare c1 cursor 
for
select sum(salary) total_sal, dname
from Employee e inner join Departments d
on e.Dno=d.Dnum
group by Dname
for read only

declare @sal int, @dname varchar(10)
open c1
fetch c1 into @sal , @dname

while @@FETCH_STATUS=0
begin
select @sal total_sal, @dname
fetch c1 into @sal, @dname

end 
close c1
deallocate c1 

--Problem 2: Update Employee Salaries Based on Department
--Description: Update employee salaries by increasing them by a certain percentage for a specific department.
declare c2 cursor
for
select salary , Dno
from Employee
for update

declare @salary int, @dno int
open c2
fetch c2 into @salary, @dno
while @@FETCH_STATUS=0
	begin 
	if @dno = 10
	  begin
		update Employee set Salary = Salary*1.1
		WHERE Current of c2
	  end
	fetch c2 into @salary, @dno
	end
close c2
deallocate c2

--Problem 3: Calculate Average Project Hours per Employee
--Description: Calculate the average number of hours each employee has worked on projects, 
--and display their names along with the calculated average hours
declare c3 cursor
for
select AVG(hours) as avg_hrs, fname
from Employee e inner join Works_for w
on e.SSN=w.ESSn
group by Fname
for read only 

declare @avg int, @fname varchar(30)
open c3
fetch c3 into @avg , @fname 
while @@FETCH_STATUS=0
begin
	select @avg as avg_hours, @fname as emp_name
	fetch c3 into @avg, @fname
end
close c3
deallocate c3


--Problem 4:  in employee table Check if Gender='M' add 'Mr Befor Employee name    
--else if Gender='F' add Mrs Befor Employee name  then display all names  
--use cursor for update

declare c4 cursor 
for 
select fname, Sex
from Employee
for update

declare @name varchar(30), @sex varchar(10)
open c4
fetch c4 into @name, @sex
while @@FETCH_STATUS=0
begin
	if @sex = 'M'
		update Employee set Fname = 'MR '+ Fname
		WHERE Current of c4
	else if @sex = 'F'
		update Employee set Fname = 'Mrs '+ Fname
		where current of c4
	--else
--		update Employee set Fname = Fname           --- is it possible to not add else
	--	where current of c4

	fetch c4 into @name, @sex
end
select @name         ---why its just disply the first value?
close c4
deallocate c4
		
		
	


--Problem 5: Solve student task at day8 demo

-----------------------------Students Task----------------------------
--Count times that amr apper after ahmed in student table 
--ahmed then amr

declare cd cursor
for
 select St_Fname
 from Student 

 for read only 

 declare @fnam varchar(10), @counter0 int, @counter1 int
 set @counter1=0
 open cd
 fetch cd into @fnam 
 while @@FETCH_STATUS=0
 begin
 set @counter0= 0
 if @fnam= 'Ahmed'
	set @counter0 = 0
 else if @fnam= 'Amr'
	set @counter0= @counter0 + 1
	set @counter1= @counter1 + @counter0
	fetch cd into @fnam 
 end
 select @counter1
 close cd
 deallocate cd              ---***

 select * from Student

--Window Function
--1.	Identifying the Top Topics by the Number of Courses:
with st
as 
(
select Top_Id, count(Crs_Id) as topics --over (partition by top_id order by top_id) as top_to
from Course
group by Top_Id) 

select *, ROW_NUMBER() over (order by topics desc) as rank_topic from st
--•	Use the "Topic" and "Course" tables to count the number of courses available for each topic.
--•	Rank the topics based on the count of courses and identify the most popular topics with the highest number of courses.

 
--2.	Finding Students with the Highest Overall Grades:
--•	Use the "Stud_Course" table to calculate the total grades for each student across all courses.
--•	Rank the students based on their total grades and identify the students with the highest overall grades.
with cs
as
(
select St_Id, sum(grade) as totsl_grade --over (order by st_id)
from Stud_Course 
group by St_Id)
select * , ROW_NUMBER() over (order by totsl_grade desc)
from cs















