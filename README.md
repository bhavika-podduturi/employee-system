# Employee Bonus Determination & Workforce Dashboard System

## Project Intro / Objective

This project cleans a messy employee database, builds a formulaic system to determine each employee's annual bonus, and visualizes workforce data through a Tableau dashboard to support office vs. remote location decisions.

The salary data was found to be illogical when paired with the tenure and department of an employee. Due to the salary data's unreliability, the bonus system is designed to be fully independent of salary. The bonus is instead calculated based on department, tenure, location, and performance.

The Tableau dashboard extends the project by giving HR and finance teams a visual tool to evaluate which office locations are justified to maintain in-person offices based on active headcount, in-person attendance rates, and the geographic cost premium being paid per region.

## Bonus Methodology

Bonuses are calculated in two steps:

**Target Bonus (% of salary) = Corporate Factor × Modifier**
- Corporate Factor: based on the employee's department and tenure
- Modifier: based on the employee's region and remote work status

**Actual Bonus (% of salary) = Target Bonus × Performance Factor**
- Performance Factor: based on the employee's performance score

## Tableau Dashboard

The interactive workforce dashboard is built on the cleaned employee dataset and is designed to answer one core question: which office locations are worth maintaining, and which populations can go fully remote?

**View the live dashboard:** [Office Location Analytics Dashboard](https://public.tableau.com/views/OfficeAnalyticsDashboard/Dashboard1?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link)

### Dashboard Charts

**Office vs. Remote Decision Charts**
- Employee status by region (Active / Pending / Inactive headcount per location)
- Remote vs. in-person breakdown by region (% of workforce working remotely vs in-person)
- Active & in-person rate by region (single metric combining both conditions)
- Geographic differential by region (cost of labor per location vs. baseline)

**Supporting Workforce Charts**
- Department headcount by region (heat map)
- Average employee age by region
- Salary distribution by remote status (box plot)

## Technologies Used

- SQL Server (Docker)
- Visual Studio Code
- Tableau Public

## Data Source and Cleaning

The data was sourced from Kaggle, containing 1,020 records and 12 columns. The cleaning process included:

- Checking for and deleting duplicate records
- Standardizing formats
- Handling missing and invalid values (e.g. `N/A` → `NULL`)
- Splitting combined columns for clarity
- Calculating employee tenure in a new column
- Applying cost of labor differentials by region in a new column

The final bonus results can be viewed in `Final_Employee_Bonus.csv`. The cleaned dataset used for the Tableau dashboard can be viewed in `Cleaned_Dataset.csv`.

## Needs of This Project

- **HRIS Analysts** — managing messy employee databases 
- **Compensation Analysts** — needing to formulaically calculate annual bonus amounts for employees across varying regions, departments, and tenures
- **HR Business Partners & Workforce Planning Teams** — evaluating which physical office locations are justified based on active headcount, in-person rates, and geographic cost premiums
