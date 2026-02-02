# Layoffs Data Analysis - SQL Project

A comprehensive SQL data analysis project examining global company layoffs, featuring data cleaning, exploratory analysis, and key insights extraction.

## 📊 Project Overview

This project analyzes layoff data from various companies worldwide, providing insights into:
- Companies with the highest layoffs
- Industry-wide trends
- Geographic patterns
- Temporal analysis and rolling totals
- Year-over-year comparisons

## 🗂️ Dataset

The dataset includes the following fields:
- **Company**: Company name
- **Location**: City location
- **Industry**: Industry sector
- **Total Laid Off**: Number of employees laid off
- **Percentage Laid Off**: Percentage of workforce affected
- **Date**: Layoff date
- **Stage**: Company stage (Post-IPO, Series C, etc.)
- **Country**: Country location
- **Funds Raised (Millions)**: Total funding raised

**Sample Data:**
```
Company: Atlassian
Location: Sydney
Industry: Other
Total Laid Off: 500
Percentage: 5%
Date: 03-06-2023
Stage: Post-IPO
Country: Australia
Funds Raised: $210M
```

## 🛠️ Technologies Used

- **Database**: MySQL
- **SQL Techniques**: 
  - CTEs (Common Table Expressions)
  - Window Functions
  - Joins
  - Aggregate Functions
  - Data Type Conversions
  - String Manipulation

## 📁 Project Structure

```
layoffs-data-analysis-sql/
│
├── data_cleaning.sql              # Data cleaning and preparation script
├── exploratory_analysis.sql       # Exploratory data analysis queries
├── sample_data.csv               # Sample dataset (optional)
├── README.md                     # Project documentation
└── screenshots/                  # Query results and visualizations (optional)
```

## 🧹 Data Cleaning Process

The data cleaning phase (`data_cleaning.sql`) includes:

1. **Duplicate Removal**
   - Created staging table to preserve raw data
   - Used ROW_NUMBER() window function to identify duplicates
   - Removed duplicate records based on all columns

2. **Data Standardization**
   - Trimmed whitespace from company names
   - Standardized industry names (e.g., consolidated crypto variants)
   - Cleaned country names (removed trailing periods)
   - Converted date strings to proper DATE format

3. **Null Value Handling**
   - Identified null and blank values
   - Populated missing industry values using self-joins
   - Removed records with null values in critical fields

4. **Schema Optimization**
   - Removed temporary columns (row_num)
   - Optimized data types

## 📈 Analysis Highlights

### Key Queries in `exploratory_analysis.sql`:

1. **Maximum Layoffs Analysis**
   - Identified companies with 100% workforce reduction
   - Analyzed relationship with funding raised

2. **Company Rankings**
   - Total layoffs by company
   - Year-over-year layoff trends
   - Top 5 companies per year by layoffs

3. **Temporal Analysis**
   - Monthly layoff trends
   - Rolling total calculations
   - Date range analysis (min/max dates)

4. **Industry & Stage Analysis**
   - Layoffs grouped by company stage
   - Industry-wide patterns

## 🔍 Sample Insights

```sql
-- Top 5 Companies by Layoffs per Year
WITH Company_year AS (
    SELECT company, YEAR(date) AS Year, SUM(total_laid_off) AS Total_layoffs
    FROM layoff_staging2
    GROUP BY company, YEAR(date)
), 
Company_year_rank AS (
    SELECT *, 
           DENSE_RANK() OVER(PARTITION BY Year ORDER BY total_layoffs DESC) AS ranking
    FROM company_year
    WHERE year IS NOT NULL
)
SELECT * 
FROM company_year_rank
WHERE ranking <= 5;
```

## 🚀 Getting Started

### Prerequisites
- MySQL Server (version 8.0 or higher recommended)
- MySQL Workbench or any SQL client

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/layoffs-data-analysis-sql.git
   cd layoffs-data-analysis-sql
   ```

2. **Create the database**
   ```sql
   CREATE DATABASE layoffs_analysis;
   USE layoffs_analysis;
   ```

3. **Import the raw data**
   - Load your layoffs dataset into a table named `layoffs`
   - Ensure column names match the schema

4. **Run the cleaning script**
   ```bash
   mysql -u username -p layoffs_analysis < data_cleaning.sql
   ```

5. **Run the analysis script**
   ```bash
   mysql -u username -p layoffs_analysis < exploratory_analysis.sql
   ```

## 📊 Key Findings

- **Companies with 100% layoffs**: Several startups despite significant funding
- **Rolling totals**: Clear visualization of cumulative layoff trends over time
- **Industry patterns**: Certain industries showed higher concentration of layoffs
- **Geographic distribution**: Insights into global vs. regional trends

---

**Note**: This project is for educational and analytical purposes only. The data used represents historical information and should not be used for investment or business decisions without proper verification.
