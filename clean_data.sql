-- 1. Remove duplicates
    -- a. Check for duplicates
    SELECT Employee_ID, COUNT(*) as Count
    FROM employee_data
    GROUP BY Employee_ID
    HAVING COUNT(*) > 1;

    -- There are no duplicates but if there were any:
    -- b. Delete duplicates, keeping the first occurence of the repeated Employee_ID
    WITH CTE AS (
        SELECT *,
            ROW_NUMBER() OVER (
                PARTITION BY Employee_ID
                ORDER BY Employee_ID
            ) AS row_num
        FROM Employees
    )
    DELETE FROM CTE WHERE row_num > 1;

    -- c. Verify duplicates are gone
    SELECT Employee_ID, COUNT(*) as Count
    FROM employee_data
    GROUP BY Employee_ID
    HAVING COUNT(*) > 1;


-- 2. Some salary values are N/A, which needs to be set to NULL and then we can form it into a proper float/numeric value
    -- a. Set salary values that are N/A to NULL
    UPDATE employee_data
    SET Salary = NULL
    WHERE TRY_CAST(Salary AS DECIMAL(10,2)) IS NULL
    AND Salary IS NOT NULL

    GO

    -- b. 
    ALTER TABLE employee_data
    ALTER COLUMN Salary DECIMAL(10,2);

    GO

-- 3. Separate department and region into two separate columns
    -- a. Add two new columns for department and region
    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_NAME = 'employee_data' AND COLUMN_NAME = 'Department')
    BEGIN
        ALTER TABLE employee_data
        ADD Department VARCHAR(100);
    END;

    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_NAME = 'employee_data' AND COLUMN_NAME = 'Region')
    BEGIN
        ALTER TABLE employee_data
        ADD Region VARCHAR(100);
    END;
    
    GO

    -- b. Populate the two columns by splitting on the '-'
    UPDATE employee_data
    SET Department = LEFT(Department_Region, CHARINDEX('-', Department_Region)-1),
        Region = RIGHT(Department_Region, LEN(Department_Region) - CHARINDEX('-', Department_Region))
    WHERE Department IS NULL or REGION IS NULL;

-- 4. Change phone number format to a consistent one (e.g., (123) 456-7890)
    -- a. Update incomplete phone numbers to NULL
    UPDATE employee_data
    SET Phone = NULL
    WHERE LEN(Phone) < 11;

    -- b. Remove dash in front of the phone number
    UPDATE employee_data
    SET Phone = STUFF(Phone, 1, 1, '')
    WHERE Phone LIKE '-%';

    -- c. Change phone number format 
    UPDATE employee_data
    SET Phone = SUBSTRING(Phone, 0, 0) + '(' +
                SUBSTRING(Phone, 1, 3) + ')-' +
                SUBSTRING(Phone, 4, 3) + '-' +
                SUBSTRING(Phone, 7, 4)
    WHERE Phone NOT LIKE '(___)-___-____';

-- 5. Add tenure column based off of join date
    -- a. Add tenure column
    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_NAME = 'employee_data' AND COLUMN_NAME = 'Tenure')
    BEGIN
        ALTER TABLE employee_data
        ADD Tenure FLOAT;
    END;
    GO

    -- b. Populate tenure column based on 1/1/2026 - Join Date
    UPDATE employee_data
    SET Tenure = ROUND(DATEDIFF(DAY, Join_Date, '2026-01-01')/365.25,1)
    WHERE Tenure IS NULL;

-- 5. Check dataset
    SELECT * FROM employee_data