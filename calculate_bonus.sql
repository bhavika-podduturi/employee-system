-- 1. Determine target bonus as a % of salary 
    -- a. Add column to be populated with target bonus numbers
    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_NAME = 'employee_data' AND COLUMN_NAME = 'Target_Bonus')
    BEGIN
        ALTER TABLE employee_data
        ADD Target_Bonus FLOAT;
    END;

    GO

    -- b. Determine target bonus as a % of salary based on each employee's tenure and the department they are in
    UPDATE employee_data
    SET Target_Bonus = CASE
        WHEN Department = 'Admin' THEN 1.05
        WHEN Department = 'HR' AND Tenure < 2 THEN 1.06
        WHEN Department = 'HR' AND Tenure BETWEEN 2 AND 3 THEN 1.07
        WHEN Department = 'HR' AND Tenure BETWEEN 3 AND 4 THEN 1.08
        WHEN Department = 'HR' AND Tenure BETWEEN 4 AND 5 THEN 1.09
        WHEN Department = 'HR' AND Tenure BETWEEN 5 and 6 THEN 1.10
        WHEN Department = 'Finance' AND Tenure < 2 THEN 1.08
        WHEN Department = 'Finance' AND Tenure BETWEEN 2 and 4 THEN 1.10
        WHEN Department = 'Finance' AND Tenure BETWEEN 4 and 5 THEN 1.12
        WHEN Department = 'Finance' AND Tenure BETWEEN 5 and 6 THEN 1.15
        WHEN Department = 'Sales' AND Tenure < 2 THEN 1.08
        WHEN Department = 'Sales' AND Tenure BETWEEN 2 and 4 THEN 1.10
        WHEN Department = 'Sales' AND Tenure BETWEEN 4 and 5 THEN 1.12
        WHEN Department = 'Sales' AND Tenure BETWEEN 5 and 6 THEN 1.15
        WHEN Department = 'Cloud Tech' AND Tenure < 3 THEN 1.10
        WHEN Department = 'Cloud Tech' AND Tenure BETWEEN 2 and 4 THEN 1.13
        WHEN Department = 'Cloud Tech' AND Tenure BETWEEN 4 and 5 THEN 1.15
        WHEN Department = 'Cloud Tech' AND Tenure BETWEEN 5 and 6 THEN 1.18
        WHEN Department = 'DevOps' AND Tenure < 3 THEN 1.10
        WHEN Department = 'DevOps' AND Tenure BETWEEN 2 and 4 THEN 1.13
        WHEN Department = 'DevOps' AND Tenure BETWEEN 4 and 5 THEN 1.15
        WHEN Department = 'DevOps' AND Tenure BETWEEN 5 and 6 THEN 1.18
    END
    WHERE Target_Bonus IS NULL

-- 2. Determine bonus modifier based on location
    -- a. Add column to be populated with geographic differentials 
    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_NAME = 'employee_data' AND COLUMN_NAME = 'Geographic_Differential')
    BEGIN
        ALTER TABLE employee_data
        ADD Geographic_Differential FLOAT;
    END;
    
    GO

    -- b. Populate column with differentials based on location
        -- Differentials are based on the cost of labor for each location compared to the US Avg 
        -- Remote workers get 1.00 meaning they are the US average with no adjustment
        -- This is because their pay isn't tied to a physical office location, so local cost of labor shouldn't apply

    UPDATE employee_data
    SET Geographic_Differential = CASE
        WHEN Remote_Work = 'TRUE' THEN 1.00
        WHEN Region = 'New York' THEN 1.126
        WHEN Region = 'California' THEN 1.149
        WHEN Region = 'Illinois' THEN 1.039
        WHEN Region = 'Texas' THEN 0.982
        WHEN Region = 'Nevada' THEN 1.016
        WHEN Region = 'Florida' THEN 0.954
        ELSE NULL
    END
    WHERE Geographic_Differential IS NULL;

-- 3. Determine actual bonus payout based on performance
    -- Poor = 50% of tgt payout; Average = 100% of tgt payout; Good = 150% of tgt payout; Excellent = 200% of tgt payout
    -- Multiplied by location-based modifier 
    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_NAME = 'employee_data' AND COLUMN_NAME = 'Actual_Bonus')
    BEGIN
        ALTER TABLE employee_data
        ADD Actual_Bonus FLOAT;
    END;
    
    GO  

    UPDATE employee_data
    SET Actual_Bonus = CASE
        WHEN Performance_Score = 'Poor' THEN ROUND(Geographic_Differential * Target_Bonus * 0.5,2)
        WHEN Performance_Score = 'Average' THEN ROUND(Geographic_Differential * Target_Bonus * 1,2)
        WHEN Performance_Score = 'Good' THEN ROUND(Geographic_Differential * Target_Bonus * 1.5,2)
        WHEN Performance_Score = 'Excellent' THEN ROUND(Geographic_Differential * Target_Bonus * 2,2)
        ELSE NULL
    END
    WHERE Actual_Bonus IS NULL;


-- 4. Check dataset
    SELECT * FROM employee_data

-- 5. Show a condensed final output
    SELECT Employee_ID, Department_Region, Salary, Target_Bonus, Actual_Bonus
    FROM employee_data