SELECT * FROM HOUSE_SALES; -- basic aggregations below

SELECT COUNT(zpid) as number_of_positions,STATE
FROM HOUSE_SALES
GROUP BY 2
ORDER BY 1 DESC;

CREATE MATERIALIZED VIEW avg_price_per_state AS
SELECT ROUND(AVG(price),0) as avg_house_price,state
FROM HOUSE_SALES
GROUP BY 2
HAVING COUNT(zpid) >= 10
order by 1 DESC;

SELECT MAX(price) as max_house_price,state
FROM HOUSE_SALES
GROUP BY 2
HAVING COUNT(zpid) >= 10
order by 1 DESC; 

CREATE MATERIALIZED VIEW avg_rental_price_per_state AS
SELECT ROUND(AVG(rentzestimate),0) as avg_house_rental_price,state
FROM HOUSE_SALES
WHERE rentzestimate > 0
GROUP BY 2
HAVING COUNT(zpid) >= 10
order by 1 DESC; -- TOP 3 are FL, NY and NJ

SELECT ROUND(AVG(living_area_in_m2),0) as avg_living_area_m2,state
FROM HOUSE_SALES
WHERE rentzestimate > 0
GROUP BY 2
HAVING COUNT(zpid) >= 10
order by 1 DESC; -- CA has the lowest average living area 


SELECT 
    STATE,
    ROUND(AVG(CASE WHEN ISSHOWCASELISTING = TRUE THEN DAYS_ON_SITE END), 0) AS showcased_days_on_site,    
    ROUND(AVG(CASE WHEN ISSHOWCASELISTING = FALSE THEN DAYS_ON_SITE END), 0) AS not_showcased_dats_on_site
FROM HOUSE_SALES
GROUP BY STATE
HAVING COUNT(zpid) >= 10
ORDER BY 2 DESC, 3 DESC;

SELECT ROUND(AVG(price-zestimate),0) as avg_estimate_vs_real_diff, ROUND(AVG(days_on_site),1) as avg_days_on_site ,state
FROM HOUSE_SALES
WHERE ZESTIMATE <> 0
GROUP BY 3
ORDER BY 2 DESC;