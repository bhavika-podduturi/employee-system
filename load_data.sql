DROP TABLE IF EXISTS employee_data;
GO

CREATE TABLE employee_data (
    Employee_ID     VARCHAR(20),
    First_Name      VARCHAR(100),
    Last_Name       VARCHAR(100),
    Age             FLOAT,
    Department_Region VARCHAR(100),
    Current_Status          VARCHAR(50),
    Join_Date       DATE,       
    Salary          VARCHAR(50),       -- VARCHAR since values appear non-numeric/malformed
    Email           VARCHAR(255),
    Phone           VARCHAR(20),       -- VARCHAR since values appear negative/malformed
    Performance_Score VARCHAR(50),
    Remote_Work     VARCHAR(10)        -- VARCHAR since it's TRUE/FALSE strings
);

BULK INSERT employee_data
FROM '/tmp/Messy_Employee_dataset.csv'
WITH (
    FIRSTROW = 2,           -- Skip the header row
    FIELDTERMINATOR = ',',  -- CSV comma delimiter
    ROWTERMINATOR = '\n',   -- Newline row terminator
    TABLOCK
);