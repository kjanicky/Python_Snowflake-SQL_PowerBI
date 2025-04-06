import snowflake.connector
from dotenv import load_dotenv
import os
import pandas as pd
load_dotenv()

user = os.getenv("SNOWFLAKE_USER")
password = os.getenv("SNOWFLAKE_PASSWORD")
account = os.getenv("SNOWFLAKE_ACCOUNT")
warehouse = os.getenv("SNOWFLAKE_WAREHOUSE")
database = os.getenv("SNOWFLAKE_DATABASE")
schema = os.getenv("SNOWFLAKE_SCHEMA")

conn = snowflake.connector.connect(
    user=user,
    password=password,
    account=account,
    warehouse=warehouse,
    database=database,
    schema=schema
)


cur = conn.cursor()
cur.execute("SELECT current_version()")
version = cur.fetchone()
print(f"Connected to Snowflake version: {version[0]}")

df = pd.read_csv("C:\CODING\Python\Advanced\Projects\Data\CSV_clean")

for index, row in df.iterrows():

    sql = f"""
    INSERT INTO House_Sales (
        bathrooms, bedrooms, city, homeType, imgSrc, latitude, longitude, livingArea, 
        lotAreaUnit, lotAreaValue, price, priceForHDP, rentZestimate, state, streetAddress, 
        taxAssessedValue, timeOnZillow, zestimate, zipcode, zpid, isShowcaseListing, 
        isPremierBuilder, is_FSBA, is_openHouse, is_forAuction, is_newHome, is_bankOwned, 
        is_FSBO, is_foreclosure, is_comingSoon
    ) 
    VALUES (
        {row['bathrooms']}, {row['bedrooms']}, '{row['city']}', '{row['homeType']}', 
        '{row['imgSrc']}', '{row['latitude']}', '{row['longitude']}', '{row['livingArea']}', 
        '{row['lotAreaUnit']}', '{row['lotAreaValue']}', {row['price']}, {row['priceForHDP']}, 
        '{row['rentZestimate']}', '{row['state']}', '{row['streetAddress']}', '{row['taxAssessedValue']}', 
        {row['timeOnZillow']}, '{row['zestimate']}', {row['zipcode']}, {row['zpid']}, 
        {row['isShowcaseListing']}, {row['isPremierBuilder']}, {row['is_FSBA']}, {row['is_openHouse']}, 
        {row['is_forAuction']}, {row['is_newHome']}, {row['is_bankOwned']}, {row['is_FSBO']}, 
        {row['is_foreclosure']}, {row['is_comingSoon']}
    )
    """
    try:
        cur.execute(sql)
    except Exception as e:
        print(f"Error inserting row {index}: {e}")

cur.close()
conn.close()