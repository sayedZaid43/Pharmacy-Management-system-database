--------------------------------Part1:-------------------------
---------------Use Company_SD

--Index?? 
--1.	Create an index on column (Hiredate) that allow u to cluster the data in the table Department.
--What will happen?
create nonclustered index ind1
	on departments([MGRStart Date])             ------No but it allow non clusterd 

	------------
--2.	Create an index that allows you to enter unique ages in the student table. What will happen?? 
create unique index ind2  
on student(st_age)     --it won't work bc there is duplicates in the column 

--3.	create a non-clustered index on column(Dept_Manager) 
--that allows you to enter a unique instructor id in the table Department.?
create unique index ind3  
on departments(mgrssn)     ---it will work
-------------------------------------------------------------------------


--Part 2: XML in SQL Server
--Consider the following XML data representing sales:

--xml
--Copy code
<sales>
    <sale>
        <saleID>1</saleID>
        <saleDate>2023-01-01</saleDate>
        <region>North</region>
        <product>ProductA</product>
        <amount>100.00</amount>
    </sale>
    <sale>
        <saleID>2</saleID>
        <saleDate>2023-01-02</saleDate>
        <region>South</region>
        <product>ProductB</product>
        <amount>200.00</amount>
    </sale>
    <!-- More sales -->
</sales>
--Write a query to extract and display all sales from the above XML.

declare @docs xml =
'<sales>
    <sale>
        <saleID>1</saleID>
        <saleDate>2023-01-01</saleDate>
        <region>North</region>
        <product>ProductA</product>
        <amount>100.00</amount>
    </sale>
    <sale>
        <saleID>2</saleID>
        <saleDate>2023-01-02</saleDate>
        <region>South</region>
        <product>ProductB</product>
        <amount>200.00</amount>
    </sale>
    <!-- More sales -->
</sales>'

declare @hdocs INT

Exec sp_xml_preparedocument @hdocs output, @docs

select * 
FROM OPENXML (@hdocs, '//sales')  
WITH (saleID int 'sale/saleID',
	  saledate date 'sale/saleDate', 
	  region varchar(20) 'sale/region',
	  product varchar(20) 'sale/product',
	  amount float 'sale/amount'
	  )

Exec sp_xml_removedocument @hdocs


				

--Write a query to extract the total sales amount from the above XML


declare @docs xml =
'<sales>
    <sale>
        <saleID>1</saleID>
        <saleDate>2023-01-01</saleDate>
        <region>North</region>
        <product>ProductA</product>
        <amount>100.00</amount>
    </sale>
    <sale>
        <saleID>2</saleID>
        <saleDate>2023-01-02</saleDate>
        <region>South</region>
        <product>ProductB</product>
        <amount>200.00</amount>
    </sale>
    <!-- More sales -->
</sales>'

declare @hdocs INT

Exec sp_xml_preparedocument @hdocs output, @docs

select * 
FROM OPENXML (@hdocs, '//sales')  
WITH (
	  amount float 'sale/amount'
	  )

Exec sp_xml_removedocument @hdocs

--Part 3: JSON in SQL Server
--Consider the following JSON data representing sales:

json
Copy code
{
    "sales": [
        {
            "saleID": 1,
            "saleDate": "2023-01-01",
            "region": "North",
            "product": "ProductA",
            "amount": 100.00
        },
        {
            "saleID": 2,
            "saleDate": "2023-01-02",
            "region": "South",
            "product": "ProductB",
            "amount": 200.00
        }
    ]
}
--Write a query to extract and display all sales from the above JSON.

ALTER DATABASE iti_New  
SET COMPATIBILITY_LEVEL = 150;


DECLARE @json VarChar(2048) = '
		{
    "sales": [
        {
            "saleID": 1,
            "saleDate": "2023-01-01",
            "region": "North",
            "product": "ProductA",
            "amount": 100.00
        },
        {
            "saleID": 2,
            "saleDate": "2023-01-02",
            "region": "South",
            "product": "ProductB",
            "amount": 200.00
        }
    ]
}'

SELECT * FROM OpenJson(@json, '$.sales')
WITH (sale_id int '$.saleID',
date date '$.saleDate',
region varchar(20) '$.region',
product VARCHAR(20) '$.product',
amount float '$.amount'
);



--Write a query to extract the total sales amount from the above JSON.
DECLARE @json VarChar(2048) = '
		{
    "sales": [
        {
            "saleID": 1,
            "saleDate": "2023-01-01",
            "region": "North",
            "product": "ProductA",
            "amount": 100.00
        },
        {
            "saleID": 2,
            "saleDate": "2023-01-02",
            "region": "South",
            "product": "ProductB",
            "amount": 200.00
        }
    ]
}'

SELECT sum(amount) as total_amount FROM OpenJson(@json, '$.sales')
WITH (
amount float '$.amount'
);