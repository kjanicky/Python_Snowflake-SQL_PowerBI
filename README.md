# Python+Snowflake(SQL)+PowerBI
This project integrates Python, Snowflake, SQL, and Power BI to analyze real estate data from the unofficial Zillow® API (via RapidAPI). It provides insights into property prices, rental estimates, and trends. Disclaimer: Data sourced from the unofficial Zillow® API. This project is for educational purposes only.

🛠️ Tools & Technologies
**Python** – Data Collection from API, JSON parsing, and CSV creation, setting up a Snowflake connector

**Python - Pandas** – Data cleaning, flattening JSON, Setting correct data types

**AWS S3** – Cloud Storage for the CSV file

**Snowflake** – Stage & Load,Data Warehousing, Cleaning, and Analysis

**SQL** – Basic Aggregations,CTEs, Joins, Window Functions

**Power BI**  – interactive visualization, DAX, PowerQuery

# 🏠 Real Estate Data Pipeline & Analysis

This project demonstrates a full data pipeline for real estate data — from data collection to analysis and dashboard visualization.

## 📌 Project Overview

1. **Data Collection**  
   I started by retrieving real estate listings from the Zillow API and saving them as JSON files locally.
   - I also prepared a Snowflake Python connector as a backup option in case I faced any issues uploading to S3.
     **file:** API_to_json.py,Snowflake_Connector.py

3. **Data Conversion**  
   Next, I wrote a Python script that parsed the individual JSON files and combined them into a single CSV file for easier handling.
   **file:** JSON_to_CSV.py

5. **Data Cleaning with Pandas**  
   Before loading the data into Snowflake, I used **Pandas** to clean and preprocess the CSV:
   - Parsed nested JSON structures (e.g. address, pricing, and property details) using dictionaries and flattened them into tabular format.
   - Converted columns to appropriate data types (e.g. prices as floats, dates as datetime objects).
   - Removed missing or inconsistent entries and handled duplicates.
   - **file:** cleaning_data.ipynb

6. **AWS & Snowflake Integration**  
   - I uploaded the cleaned CSV to an Amazon S3 bucket.
   - I created a Snowflake **storage integration** and **external stage** to access the data from the S3 bucket securely. **file:** Stage & Load.sql
   
7. **Data Loading & Cleaning in Snowflake**  
   I used SQL commands to load the CSV file into a Snowflake table(also Created using SQL) using the previously configured stage. After loading the data, I performed basic normalization and data cleaning to prepare it for analysis. **file:** Creating DB & Table.sql,Cleaning & Normalization.sql

8. **Data Analysis**  
   I first ran some simple aggregations to get a general overview of the dataset. Then, I used **Common Table Expressions (CTEs)** and **window functions** to conduct deeper analysis.
**file:** Analysis (Advanced Functions).sql
   Example advanced query to find properties priced above the city average:
   ```sql
   WITH city_avg_price AS ( 
       SELECT 
           STATE, 
           CITY, 
           ROUND(AVG(PRICE), 0) AS avg_price_in_city
       FROM HOUSE_SALES
       GROUP BY STATE, CITY
   ),
   houses_above_avg AS (
       SELECT 
           h.STATE,
           h.CITY,
           h.STREETADDRESS,
           h.PRICE,
           c.avg_price_in_city
       FROM HOUSE_SALES h
       JOIN city_avg_price c 
           ON h.STATE = c.STATE AND h.CITY = c.CITY
       WHERE h.PRICE > c.avg_price_in_city
   )
   SELECT * 
   FROM houses_above_avg
   ORDER BY STATE, CITY, PRICE DESC;
9. **Dashboard Visualization**
     Finally, I connected the cleaned and transformed dataset to Power BI to create an interactive dashboard that serves as a tool for monitoring and analyzing real estate offers across the U.S. The dashboard provides both a high-level market overview and detailed property-level insights.

The dashboard consists of two main pages:

🗺️ **Map View**
  This page offers a geographical overview of property prices across different cities and states in the U.S. It includes:
  
  An interactive map visual
  
  Summary cards displaying key metrics
  
  A dynamic tooltip that links to a separate insights page within the report
  It's designed for quick, comparative analysis of regional price trends.

🏡 **Property Details View**
  This page dives deeper into individual listings. It features:
  
  A detailed table of properties with metrics such as price, rent, and comparison to state averages
  
  An interactive map showing the exact location of each property
  
  A dynamic tooltip revealing key information about the state the property belongs to

  ## ✅ Outcome
An end-to-end real estate data pipeline that pulls data from Zillow, processes and loads it into a Snowflake warehouse, and enables rich, interactive analytics through a dashboard. The project can support real estate analysts or buyers in identifying great property deals quickly and efficiently.
