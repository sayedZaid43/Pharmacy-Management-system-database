--1.     Create a stored procedure to show the number of students per department.[use ITI DB]
create or alter proc numofstud @dept int
as
select count(*), Dept_Id
from Student
where Dept_Id = @dept
group by Dept_Id


numofstud 20

--2.	Create a stored procedure that will check for the number of employees in the project 100 
--if they are more than 3 print a message to the user 
--“'The number of employees in the project 100 is 3 or more'” 
--if they are less display a message to the user “'The following employees work for the project 100'” 
--in addition to the first name and last name of each one. [Company DB] 

create or alter proc checknumberemp @pno int
as 
begin
	declare @count int
	select  @count = count(*) 
	from  Works_for 
	where Pno = @pno
	group by Pno
	if (@count >= 3)

		begin
			select 'The number of employees in the project 100 is 3 or more'
		end
	else
		begin

			select 'The following employees work for the project' + cast(@pno as varchar(20)) as text, fname, lname
			from Employee E inner join Works_for W
			on E.SSN=W.ESSn
			where Pno = @pno
		end
end

execute checknumberemp  100

-- 3.Create a stored procedure that will be used in case there is an old employee has left the project 
--and a new one become instead of him. The procedure should take 3 parameters 
--(old Emp. number, new Emp. number and the project number) and it will be used to update works_for table. 
--[Company DB]
create or alter proc oldempleft (@old int, @new int, @pnum int)
as
update Works_for
set ESSn=@new
where ESSn=@old and Pno=@pnum
select 'the old emp is'+' ' +CAST(@old as varchar(10))+' '+'and then new emp '+ CAST(@new as varchar(10))

execute oldempleft 112233, 102672, 100

--4.This table will be used to audit the update trials on the Hours column (works_for table, Company DB)
--Example:
--If a user updated the Hours column then the project number, the user name that made that update, 
--the date of the modification and the value of the old and the new Hours will be inserted into the Audit table

create table Audit
(
ProjectNo int,
UserName varchar(50),
ModifiedDate date,
Hours_Old int,
Hours_new int
)


create TRIGGER t1
on works_for
after update
as
if UPDATE (hours)
insert into Audit (ProjectNo , UserName , ModifiedDate , Hours_Old , Hours_new )
select d.pno , USER_NAME(), GETDATE(), d.hours, i.hours
from deleted d inner join inserted i
on d.ESSn=i.ESSn

update Works_for
set Hours += 1
where Pno=100

--5.Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--Print a message for the user to tell him that he ‘can’t insert a new record in that table’
create trigger t2
on department 
instead of insert
as
select 'cant insert a new record in that table'

	insert into Department(Dept_Id, Dept_Name)
	values (12, 'sa')

--6.   Create a trigger that prevents the insertion Process for the Employee table in May and test it 
--[Company DB].

create or alter trigger t3   -- note 
on employee
after insert 
as
if format(GETDATE(), 'MMMM') = 'june'
begin
	delete E from Employee E inner join inserted I
	on E.ssn=I.ssn
end

insert into Employee (SSN, Fname, Lname)
values (50,'say', 'ahm')
	
	select * from Employee
--7.   Create a trigger that prevents users from altering any table in Company DB.

create trigger t4
on database
for alter_table 
as
select 'you can not alter tables here'

create table ttt
(
id int primary key,
name varchar(20)
)

alter table ttt 
add lname varchar(20)


--8.  Create a trigger on student table after insert to add Row in a Student Audit table 
--(Server User Name, Date, Note) where the note will be 
--“[username] Insert New Row with ID =[Key Value] in table [table name]”

create  table stud_audit
(Server_User_name varchar(50),
Date date,
note varchar(50)
)



create or alter trigger t5
on student
after insert 
as
	begin
		insert into stud_audit (Server_User_name , Date , note)
		select USER_NAME(),
		GETDATE(),
		(user_name() + 'Insert New Row with ID ='+' '+ cast(st_id as varchar(10)) + 'in table student') as text
		from inserted
	end

insert into Student (St_Id, St_Fname, St_Lname)
values(70, 'ahned', 'esam')

-------------------------------------the end----------------------------------