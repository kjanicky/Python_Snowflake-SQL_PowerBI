SELECT * FROM HOUSE_SALES;

SELECT * FROM HOUSE_SALES
WHERE price IS NULl; -- the most important column when it comes to our analysis -> no blanks

ALTER TABLE HOUSE_SALES 
ADD COLUMN area_in_m2 FLOAT; -- we have to standarize our units

UPDATE HOUSE_SALES
SET area_in_m2  =
    CASE 
    WHEN LOTAREAUNIT = 'sqft' THEN ROUND(LOTAREAVALUE *  0.092903, 0)
    WHEN LOTAREAUNIT = 'acres' THEN ROUND(LOTAREAVALUE * 4046.86,0)
    ELSE NULL
    END;

SELECT area_in_sqft,lotareavalue,lotareaunit,area_in_m2
FROM HOUSE_SALES;


ALTER TABLE HOUSE_SALES 
ADD COLUMN living_area_in_m2 FLOAT;

UPDATE HOUSE_SALES
SET living_area_in_m2 = ROUND(livingarea * 0.092903, 0); -- there are some false values and returns error

SELECT COUNT(*) as number_of_instances
FROM HOUSE_SALES
WHERE livingarea = 'False' OR lotareavalue = 'False'; -- check for the 'False' values 

UPDATE HOUSE_SALES
SET LIVINGAREA = 0
WHERE LIVINGAREA = 'False';

UPDATE HOUSE_SALES
SET LOTAREAVALUE = 0
WHERE LOTAREAVALUE = 'False'; --making sure there are no 'False' values

SELECT living_area_in_m2,livingarea FROM HOUSE_SALES; --check if the calculations are correct

SELECT COUNT(*) as number_of_instances
FROM HOUSE_SALES
WHERE living_area_in_m2 IS NULL OR area_in_m2 IS NULL; --26 instances

SELECT area_in_m2,living_area_in_m2
FROM HOUSE_SALES
WHERE  living_area_in_m2 IS NULL OR living_area_in_m2 = 0; -- 21 instances probably just some construction plot + ranches

SELECT area_in_m2,living_area_in_m2
FROM HOUSE_SALES
WHERE  living_area_in_m2 IS NULL OR living_area_in_m2 = 0;

ALTER TABLE HOUSE_SALES
ADD COLUMN days_on_site FLOAT;

UPDATE HOUSE_SALES
SET days_on_site = ROUND(TIMEONZILLOW/86400000,0); -- i found that this time is given in a milisecond so i converted it to days

SELECT days_on_site,timeonzillow
FROM HOUSE_SALES;

ALTER TABLE HOUSE_SALES
ADD COLUMN SALE_STATUS VARCHAR;

UPDATE HOUSE_SALES
SET SALE_STATUS = 
    CASE 
        WHEN IS_FSBO = TRUE THEN 'For Sale by Owner'
        WHEN IS_FSBA = TRUE THEN 'For Sale by Agent'
        WHEN IS_FORAUCTION = TRUE THEN 'Auction'
        WHEN IS_FORECLOSURE = TRUE THEN 'Foreclosure'
        WHEN IS_BANKOWNED = TRUE THEN 'Bank Owned'
        WHEN IS_NEWHOME = TRUE THEN 'New Home'
        WHEN IS_COMINGSOON = TRUE THEN 'Coming Soon'
        ELSE 'Uknown'
    END;

SELECT COUNT(*)
FROM HOUSE_SALES
WHERE sale_status = 'Uknown';

--ALTER TABLE HOUSE_SALES DROP livingarea
-- DROP lotareavalue
-- DROP IS_FSBO; -- if we want to drop this because we have them in m2