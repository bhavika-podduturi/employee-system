# Employee Bonus Determination System

## Project Intro/Objective
This project cleans a messy employee database and builds a formulaic system  to determine each employee's annual bonus. The salary data was found to be illogical when paired with the tenure and department of an employee. Due to the salary data's unreliability, the bonus system is designed to be fully independent of salary. The bonus is instead calculated based on department, tenure, location, and performance.

## Bonus Methodology
Bonuses are calculated in two steps:
**Target Bonus** (% of salary) = Corporate Factor × Modifier
**Corporate Factor**: based on the employee's department and tenure
**Modifier**: based on the employee's region and remote work status

**Actual Bonus** (% of salary) = Target Bonus × Performance Factor
**Performance Factor**: based on the employee's performance score

### Technologies
* SQL Server (Docker)
* Visual Studio Code

## Data Source and Cleaning
The data was sourced from Kaggle, containing 1020 records and 12 columns. 

## Needs of this project
* HRIS analysts managing messy employee databases
* Compensation analysts needing to formulaically calculate annual bonus amounts for employees across varying regions, departments, and tenures 
