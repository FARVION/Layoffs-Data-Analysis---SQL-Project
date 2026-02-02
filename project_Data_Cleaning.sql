-- Data Cleaning

SELECT 
    *
FROM
    layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. NUll / BLank values (based on instances we could populate it or do nothing)
-- 4. Remove any Columns (based on instances " " , might cause problem if you remove columns from RAW Dataset)

-- Create a Copy of the Raw file/data/table

Create table layoff_Staging like layoffs;
insert layoff_staging select * from layoffs;
select * from layoff_staging;

-- we are going to use duplicated table to make changes while OG left unchanged
-- identify duplicates

select *, row_number()
over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoff_staging;

-- add CTE

with duplicate_cte as(
select *, row_number()
over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) row_num
from layoff_staging
)
select * from duplicate_cte
where row_num>1;

select * from layoff_staging where company='casper';

-- try creating another table/data and delete duplicate rows (og=1  dup=2)

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert  into layoff_staging2 
select *, row_number()
over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) row_num
from layoff_staging;

delete from layoff_staging2 where row_num >1;

select * from layoff_staging2 where row_num=1;

select * from layoff_staging2;

-- Standardizing Data

select company, (trim(company)) -- Company
from layoff_staging2;

update layoff_staging2
set company=trim(company);

select *                        -- Industry
from layoff_staging2
where industry like '%crypto%';       

update layoff_staging2
set industry ='Crypto'
where industry like '%crypto%';

select DISTINCT industry from layoff_staging2; 

select distinct country          -- Country
from layoff_staging2
order by 1;

select distinct country , trim(trailing '.' from country)
from layoff_staging2
order by 1; 

update layoff_staging2
set country=trim(trailing '.' from country)
where country like'%united states%';


select `date`,str_to_date(`date`,'%m/%d/%Y')      -- Date ( string (text )to Date)
from layoff_staging2;

update layoff_staging2
set `date`=str_to_date(`date`,'%m/%d/%Y');

select `date`from layoff_staging2;

alter table layoff_staging2 
modify column `date` date;

select * from layoff_staging2;

-- NUll / Blanks

select * from layoff_staging2
where total_laid_off is null and percentage_laid_off is null;

update layoff_staging2
set industry=null
where industry='';

select * from layoff_staging2
where industry is null or industry='';

select * from layoff_staging2
where company like 'bally%';

-- Joins

select t1.industry,t2.industry from layoff_staging2 t1
join layoff_staging2 t2
on t1.company=t2.company
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

update layoff_staging2 t1
join layoff_staging2 t2
on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;

select*from layoff_staging2;

select*from layoff_staging2
where total_laid_off is null and 
percentage_laid_off is null;

-- Delete

delete
from layoff_staging2
where total_laid_off is null and 
percentage_laid_off is null;

select*from layoff_staging2;

alter table layoff_staging2
drop column row_num;

select*from layoff_staging2;

-- End --