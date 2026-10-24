# rice_price_data_analysis_project
data analysis with MySQL and excel

I worked on a dirty dataset about Rice pricing. 
I started by importing the dataset in MySQL, once there I checked the columns and t tried to understand the dataset. After taking time to make a brief analysis of the dataset, I created a staging table.
When the staging table was done, I started cleaning the dataset by removing duplicates with row_num and CTS and dropped duplicates after creating a staging table2 where I have inserted the row_num column and used the where close to remove duplicates. I standardized the rice type, region, export_import columns, and turned the date column into date format, and I checked the null and I replaced the empty rows by null.
At the end of the data cleaning, I have applied window such as count, sum, avg, min, max….to make the analysis inside the SQL Database. 
I imported the cleaned data into csv, then I moved it on  excel to make the analysis and built dashboard to present the key insight

*Key Insight*
**Total demand (Tons):  468 613.49**
**Total Supply (Tons):  428 061.81**
**Total Shipment: 898**
*Price per kg average by region*
**East	$55.21**
**North	$56.07**
**South	$58.38**
**West	$54.40**
**Unknow $59.43**
*Total demand by rice type*
**Basmati	: 158757.69**
**Brown: 85002.64**
**Jasmine	: 78430.11**
**White: 64579.49**
**Unknow: 87799.89**	





