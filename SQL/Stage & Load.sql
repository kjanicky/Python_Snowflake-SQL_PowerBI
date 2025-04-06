STORAGE_AWS_ROLE_ARN = 'yours-account-id'


CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
   TYPE = EXTERNAL_STAGE
   STORAGE_PROVIDER = 'S3'
   ENABLED = TRUE
   STORAGE_AWS_ROLE_ARN = STORAGE_AWS_ROLE_ARN
   STORAGE_ALLOWED_LOCATIONS = ('s3://housesaleskj/'); -- getting my data from my S3 bucket
   
CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = 'CSV'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1
NULL_IF = ('NULL', ''); -- creating a file format

CREATE OR REPLACE STAGE house_sales_stage
  URL = 's3://housesaleskj/'
  STORAGE_INTEGRATION = my_s3_integration
  FILE_FORMAT = my_csv_format;


LIST @house_sales_stage;

COPY INTO HOUSE_SALES
FROM @house_sales_stage
FILE_FORMAT = (FORMAT_NAME = my_csv_format)
PATTERN = '.*house_sales.*.csv'
ON_ERROR = 'CONTINUE'
VALIDATION_MODE = 'RETURN_ERRORS';