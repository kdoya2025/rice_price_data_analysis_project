select*
from rice_price_dataset_dirty
limit 10;
-- creating staging table

create table staging_table like rice_price_dataset_dirty;
select *
from staging_table;

-- insert data to the satging table
insert into staging_table 
select*
from rice_price_dataset_dirty;

select *
from staging_table
limit 5;

-- 1- removing duplicates
select *,row_number() over(partition by Rice_ID,Region,Rice_Type,
Price_per_kg,Demand_Tons,Supply_Tons,Rainfall_mm,Temperature_C,Import_Export,Date) as row_num
from staging_table;

-- create cts

with cts_table as
(select *,row_number() over(partition by Rice_ID,Region,Rice_Type,
Price_per_kg,Demand_Tons,Supply_Tons,Rainfall_mm,Temperature_C,Import_Export,Date) as row_num
from staging_table)
select *
from cts_table
where row_num>1;

-- create staging_table2 and insert row num

CREATE TABLE staging_table2 (
  `Rice_ID` int DEFAULT NULL,
  `Region` text,
  `Rice_Type` text,
  `Price_per_kg` double DEFAULT NULL,
  `Demand_Tons` double DEFAULT NULL,
  `Supply_Tons` double DEFAULT NULL,
  `Rainfall_mm` double DEFAULT NULL,
  `Temperature_C` double DEFAULT NULL,
  `Import_Export` text,
  `Date` text,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- insert data into the scond staging table
insert into staging_table2 
select *,row_number() over(partition by Rice_ID,Region,Rice_Type,
Price_per_kg,Demand_Tons,Supply_Tons,Rainfall_mm,Temperature_C,Import_Export,Date) as row_num
from staging_table;
select *
from staging_table2
where row_num>1;
-- delete duplicates rows
delete 
from staging_table2
where row_num>1;

-- 2-standardize teh dataset
select *
from staging_table2
limit 10;

-- standardizing Import export col

 select distinct Import_Export
 from staging_table2;
 -- replacing empty value value by null
 update staging_table2
 set Import_Export =Null 
 where Import_Export="";
 
 -- replacing EXPORT by Export
 
 update staging_table2
 set Import_Export ="Export"
 where Import_Export="EXPORT" ;
 
update staging_table2
set Import_Export=trim(Import_Export);

select distinct Region
from staging_table2;

update staging_table2 set
Region=Null 
where Region="";

update staging_table2 set
Region='South'
where Region='south ';


update staging_table2 set
Region='North'
where Region='NORTH';
-- standardizing the Rice_Type cols
update staging_table2 set
Region=trim(Region);

select distinct Rice_Type
from staging_table2;

update staging_table2 
set Rice_Type=Null
where Rice_Type="";

update staging_table2
set Rice_Type=trim(Rice_Type);

select *
from staging_table2
;
-- standardize the date cols
update staging_table2 
set Date=Null
where Date="";
update staging_table2 
set Date=str_to_date(Date,"%d-%m-%Y");

-- round numeric value by 2
update staging_table2 set
Price_per_kg=round(Price_per_kg,2);

update staging_table2 set
Demand_Tons=round(Demand_Tons,2);

update staging_table2 set
Supply_Tons=round(Supply_Tons,2);

update staging_table2 set
Rainfall_mm=round(Rainfall_mm,2);

update staging_table2 set
Temperature_C=round(Temperature_C,2);

-- 3-handling null values

-- checking null or empty values

select Price_per_kg
from staging_table2
where Price_per_kg="" or Price_per_kg=null;

select Demand_Tons
from staging_table2
where Demand_Tons="" or Demand_Tons is null;

select Supply_Tons
from staging_table2
where Supply_Tons="" or Supply_Tons=null;

select Rainfall_mm
from staging_table2
where Rainfall_mm="" or Rainfall_mm is null;

select Temperature_C
from staging_table2
where Temperature_C="" or Temperature_C is null;



-- the numeric cols doesn't contain null or empty value
-- null value count

select count(*)
from staging_table2
where Region is NULL
;

select count(*)
from staging_table2
where Rice_Type is NULL
;
select count(*)
from staging_table2
where Import_Export is NULL;

select count(*)
from staging_table2
where Date is NULL;

-- droping unnecessary clos


alter table staging_table2
drop column row_num;

select *
from staging_table2;

-- 4 data analysis

-- numeric value overview
select round(min(Price_per_kg),2) as min_pice_per_kg, 
round(max(Price_per_kg),2) as max_pice_per_kg,
round(avg(Price_per_kg),2) as AVG_pice_per_kg,
round(Sum(Price_per_kg),2) as total_price_per_kg,
round(min(Demand_Tons),2) as min_Demand_Tons,
round(max(Demand_Tons),2) as max_Demand_Tons,
round(avg(Demand_Tons),2) as AVG_Demand_Tons,
round(sum(Demand_Tons),2) as total_Demons_Tons,
round(min(Supply_Tons),2) as min_Supply_Tons,
round(max(Supply_Tons),2) as max_Supply_Tons,
round(avg(Supply_Tons),2) as AVG_Supply_Tons,
round(sum(Supply_Tons),2)as total_Supply_Tons,
round(min(Rainfall_mm),2) as min_Rainfall_mm,
round(max(Rainfall_mm),2) as max_Rainfall_mm,
round(avg(Rainfall_mm),2) as AVG_Rainfall_mm,
sum(Rainfall_mm) as total_Rainfall_mm,
round(min(Temperature_C),2) as min_Temperature_C,
round(max(Temperature_C),2) as max_Temperature_C,
round(avg(Temperature_C),2) as AVG_Temperature_C
from staging_table2;
-- create a procedure for  descriptive statistics
delimiter $$
create procedure descriptive_statistics()
begin
select min(Price_per_kg) as min_pice_per_kg, max(Price_per_kg) as max_pice_per_kg,round(avg(Price_per_kg),2) as AVG_pice_per_kg,
min(Demand_Tons) as min_Demand_Tons,max(Demand_Tons) as max_Demand_Tons,round(avg(Demand_Tons),2) as AVG_Demand_Tons,
min(Supply_Tons) as min_Supply_Tons,max(Supply_Tons) as max_Supply_Tons,round(avg(Supply_Tons),2) as Supply_Tons,
min(Rainfall_mm) as min_Rainfall_mm,max(Rainfall_mm) as max_Rainfall_mm,round(avg(Rainfall_mm),2) as AVG_Rainfall_mm,
min(Temperature_C) as min_Temperature_C,max(Temperature_C) as max_Temperature_C,round(avg(Temperature_C),2) as AVG_Temperature_C
from staging_table2
;end $$
delimiter ;

call descriptive_statistics;
--  import export anlysis

select Import_Export,count(*) as Total,count(*)*100/sum(count(*)) over() as percentage
from staging_table2
where Import_Export is not null
group by Import_Export;


select Import_Export,round(sum(Price_per_kg),2) as total_price_kg ,
round(Sum(Demand_Tons),2) as total_demand_tons,
round(sum(Supply_Tons),2) as total_supply_tons,
round(sum(Rainfall_mm),2) as total_rainfall_mm,
round(sum(Temperature_C),2) as total_temperature_c
from staging_table2
where Import_Export is not null
group by Import_Export;


select Rice_Type,min(Price_per_kg) as min_pice_per_kg, max(Price_per_kg) as max_pice_per_kg,round(avg(Price_per_kg),2) as AVG_pice_per_kg,
min(Demand_Tons) as min_Demand_Tons,max(Demand_Tons) as max_Demand_Tons,round(avg(Demand_Tons),2) as AVG_Demand_Tons,
min(Supply_Tons) as min_Supply_Tons,max(Supply_Tons) as max_Supply_Tons,round(avg(Supply_Tons),2) as Supply_Tons,
min(Rainfall_mm) as min_Rainfall_mm,max(Rainfall_mm) as max_Rainfall_mm,round(avg(Rainfall_mm),2) as AVG_Rainfall_mm,
min(Temperature_C) as min_Temperature_C,max(Temperature_C) as max_Temperature_C,round(avg(Temperature_C),2) as AVG_Temperature_C
from staging_table2
where  Rice_Type is not null
group by Rice_Type
;




select *
from staging_table2;

select  Rice_Type,round(sum(Price_per_kg),2) as total_price_kg ,
round(Sum(Demand_Tons),2) as total_demand_tons,
round(sum(Supply_Tons),2) as total_supply_tons,
round(sum(Supply_Tons)-Sum(Demand_Tons),2) as netsuplus_deficit,
round(sum(Rainfall_mm),2) as total_rainfall_mm,
round(sum(Temperature_C),2) as total_temperature_c
from staging_table2
where  Rice_Type is not null
group by Rice_Type
;
-- region impact on price,demand,rainfall and temperature
select  Region,round(sum(Price_per_kg),2) as total_price_kg ,
round(Sum(Demand_Tons),2) as total_demand_tons,
round(sum(Supply_Tons),2) as total_supply_tons,
round(sum(Rainfall_mm),2) as total_rainfall_mm,
round(sum(Temperature_C),2) as total_temperature_c
from staging_table2
where  Region is not null
group by Region
;

-- weather impact  on supply and price
select
CASE 
When Rainfall_mm<100 then "low rainfall (<100mm"
when Rainfall_mm  between 100 and 300 then "moderate rainfall "
else "high rainfall (>300)"
end as rain_category,
ROUND(AVG(Supply_Tons), 2) AS avg_supply,
ROUND(AVG(Price_per_kg), 2) AS avg_price
from staging_table2
WHERE Rainfall_mm IS NOT NULL
GROUP BY rain_category;

-- price and demand trends

SELECT DATE_FORMAT(Date, '%Y-%m') AS year_month2, 
       ROUND(AVG(Price_per_kg), 2) AS avg_price,
       ROUND(SUM(Demand_Tons), 2) AS total_demand
FROM staging_table2
WHERE Date IS NOT NULL
GROUP BY year_month2
ORDER BY year_month2;