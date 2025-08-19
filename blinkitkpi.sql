create database blinkitdb

use blinkitdb


select * from blinkit_data

select count(*) from blinkit_data

update blinkit_data
set Item_Fat_Content = 
case 
when Item_Fat_Content in ('lf','low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end 
 
select  distinct(item_Fat_Content) from blinkit_data
-----kpi 1 totalsales:
select cast(sum(total_sales)/1000000 as decimal(10,2)) as totalsales_Millions from blinkit_data
----kpi 2  avragesales :
select cast(avg(total_sales) as decimal(10,1)) AVG_sales from blinkit_data
----kpi3 number of items 
select count(*) As NO_of_items  from blinkit_data

------kpi 4 avg rating 
select  cast(avg(Rating)as decimal(10,2))as Avg_rating from blinkit_data
---- 1 total sales by item type 
select  Item_Fat_Content,
         CAST(sum(total_Sales)/1000 as decimal(10,2)) as total_sales_thousands,
		 cast(avg(total_sales) as decimal(10,1)) AVG_sales,
		 count(*) As NO_of_items, 
		 cast(avg(Rating)as decimal(10,2))as Avg_rating
from blinkit_data

group by  Item_Fat_Content
order by total_sales_thousands desc

----- 2 Total sales item_type  of the list 
select top 5  Item_Type,
         CAST(sum(total_Sales)/1000 as decimal(10,2)) as total_sales_thousands,
		 cast(avg(total_sales) as decimal(10,1)) AVG_sales,
		 count(*) As NO_of_items, 
		 cast(avg(Rating)as decimal(10,2))as Avg_rating
from blinkit_data

group by  Item_Type
order by total_sales_thousands desc

--3 fat content   by outlet for toatl sales 
select * from blinkit_data
select Outlet_Location_Type,item_fat_content, 
         CAST(sum(total_Sales)/1000 as decimal(10,2)) as total_sales_thousands,
		 cast(avg(total_sales) as decimal(10,1)) AVG_sales,
		 count(*) As NO_of_items, 
		 cast(avg(Rating)as decimal(10,2))as Avg_rating
from blinkit_data
group by Outlet_Location_Type,item_fat_content 
order by total_sales_thousands desc
---
----3 fat content by outlet for total sales
select outlet_location_type,
  isnull([Low fat],0) AS Low_Fat,
  isnull([Regular],0) as Regular
 from 
 ( 
  select outlet_Location_type,Item_fat_content,
         Cast(sum(total_sales) as decimal(10,2)) as total_sales 
		  from blinkit_data 
		  group by  outlet_Location_type,Item_fat_content
) as  Sourcetable 
pivot
( 
   sum(Total_sales)
    for Item_fat_content IN([Low fat],[Regular])
	) as pivottable
	 order by outlet_Location_type
---4-toatl sales  by outlet for total sales 
select Outlet_Establishment_year,
         Cast(sum(total_sales) as decimal(10,2)) as total_sales 
		  from blinkit_data 
		  group by  outlet_Establishment_year
		  order by outlet_Establishment_year asc
select * from blinkit_data
----5 percentage of sales by outlet size 
select 
      outlet_size,
	  cast(sum(total_sales) as decimal(10,2))as total_sales,
	  cast(sum(total_sales)* 100.0/ sum(sum(total_sales)) over() as decimal(10,2)) as sales_percentage 
from blinkit_data 
group by outlet_size
order by total_sales desc;

-----6  outlet_location _type 
select outlet_location_type,
		cast(sum(total_sales) as decimal(10,2))as total_sales,
	  cast(sum(total_sales)* 100.0/ sum(sum(total_sales)) over() as decimal(10,2)) as sales_percentage,
        cast(avg(total_sales) as decimal(10,1)) as AVG_sales,
		 count(*) As NO_of_items, 
		 cast(avg(Rating)as decimal(10,2))as Avg_rating
from blinkit_data
where Outlet_Establishment_Year = 2020
group by outlet_location_type 
order by total_sales desc

select * from blinkit_data
-----7 all metrics by  outlet type 
select outlet_type,
		cast(sum(total_sales) as decimal(10,2))as total_sales,
	  cast(sum(total_sales)* 100.0/ sum(sum(total_sales)) over() as decimal(10,2)) as sales_percentage,
        cast(avg(total_sales) as decimal(10,1)) as AVG_sales,
		 count(*) As NO_of_items, 
		 cast(avg(Rating)as decimal(10,2))as Avg_rating
from blinkit_data
group by outlet_type
order by total_sales desc





