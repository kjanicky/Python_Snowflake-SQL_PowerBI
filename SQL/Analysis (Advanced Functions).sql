SELECT * FROM HOUSE_SALES;

WITH ranked_houses AS ( 
 SELECT 
    STATE,
    CITY,
    STREETADDRESS,
    PRICE,
    LIVING_AREA_IN_M2,
    RANK() OVER (PARTITION BY STATE  ORDER BY PRICE DESC) as price_rank
    
FROM HOUSE_SALES)

SELECT * FROM ranked_houses 
WHERE price_rank <= 3; -- top 3 houses in each state with details


SELECT 
    STATE,
    CITY,
    STREETADDRESS,
    PRICE,
    MEDIAN(PRICE) OVER (PARTITION BY STATE) AS median_price,
    CASE 
        WHEN PRICE > MEDIAN(PRICE) OVER (PARTITION BY STATE) THEN 'Above Median'
        WHEN PRICE < MEDIAN(PRICE) OVER (PARTITION BY STATE) THEN 'Below Median'
        ELSE 'Median'
    END AS price_category
FROM HOUSE_SALES; --query the check whether our real estate is above the median in it's state

SELECT 
    STATE,
    CITY,
    STREETADDRESS,
    PRICE,
    NTILE(3) OVER (PARTITION BY STATE ORDER BY PRICE DESC) AS price_category
FROM HOUSE_SALES; -- dividing price into 3 categories (quantiles to be exact) -> (expensive,affordable,cheap for real estate of course :) for each state and mapping it to a given position 

WITH properties_in_city_ranked AS ( 
SELECT 
    STATE,
    CITY,
    STREETADDRESS,
    PRICE,
    LIVING_AREA_IN_M2,
    RANK() OVER(PARTITION BY CITY ORDER BY PRICE DESC) as price_rank,
    COUNT(*) OVER(PARTITION BY CITY) AS total_properties
    
    FROM HOUSE_SALES)
SELECT STATE,CITY,STREETADDRESS,PRICE,LIVING_AREA_IN_M2,price_rank FROM properties_in_city_ranked
WHERE price_rank <= 3 AND total_properties >=3; -- ranking of most expensive properties in a city that have atleast 3 instances in our data

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
ORDER BY STATE, CITY, PRICE DESC; -- query for properties that have higher price that the avg in the city