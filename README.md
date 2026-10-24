# 🍚 Rice Price Data Analysis Project

## 📌 Project Overview
An end-to-end data analysis project exploring global/regional rice pricing, supply-demand dynamics, and shipment volumes. The dataset underwent rigorous cleaning and transformation using MySQL before being visualized through an interactive Excel dashboard.

## 🛠️ Tech Stack & Tools
* **Database & ETL:** MySQL (Staging tables, CTEs, Window Functions)
* **Visualization & Reporting:** Microsoft Excel (Pivot Tables, Interactive Dashboards)

## 🧹 Data Cleaning & Transformation (SQL Pipeline)
1. **Data Staging:** Imported the raw dataset into a staging table for initial exploratory data analysis.
2. **Duplicate Removal:** Utilized Common Table Expressions (CTEs) and `ROW_NUMBER()` window functions, pushing clean records into a secondary staging table.
3. **Data Standardization:** Standardized string columns (`rice_type`, `region`, `export_import`) and formatted date fields.
4. **Null Handling:** Identified empty rows and replaced them with explicit `NULL` values.
5. **Aggregations:** Applied SQL window functions (`SUM`, `AVG`, `MIN`, `MAX`) to extract core metrics directly in the database.

## 📈 Key Insights

1. **Total demand (Tons):  468 613.49**
2. **Total Supply (Tons):  428 061.81**
3. **Total Shipment: 898**
# Price per kg average by region
1. **East	$55.21**
2. **North	$56.07**
3. **South	$58.38**
4. **West	$54.40**
5. **Unknow $59.43**
# Total demand by rice type
1. **Basmati	: 158757.69**
2. **Brown: 85002.64**
3. **Jasmine	: 78430.11**
4. **White: 64579.49**
5. **Unknow: 87799.89**










