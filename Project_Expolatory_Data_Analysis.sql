-- Expplatory Data Analysis

select*from layoff_staging2;

select max(total_laid_off),max(percentage_laid_off)			-- max(percentage_laid_off) = 1 represents 100% of the company
from layoff_staging2;

select*from layoff_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

select company,sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc
;

select min(date),max(date)
from layoff_staging2;

select stage,sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc;

select company,sum(percentage_laid_off)
from layoff_staging2
group by company
order by 2 desc;

-- Rolling Total Layoffs based on Month --

select substring(`date`,1,7) as `Month` ,sum(total_laid_off)
from layoff_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
;

with Rolling_total as(
select substring(`date`,1,7) as `Month` ,sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`,total_off,sum(total_off)over(order by `month`) as Rolling_total
from Rolling_total;

select company , sum(total_laid_off) 
from layoff_staging2
group by company
order by 2 desc;

select company ,year(date), sum(total_laid_off) 
from layoff_staging2
group by company,year(date)
order by 3 desc
;


-- CTE for Rank --

with Company_year (Company , Year , Total_layoffs)as (
select company ,year(date), sum(total_laid_off) 
from layoff_staging2
group by company,year(date)
) , Company_year_rank as(
select*,dense_rank()over(partition by Year order by total_layoffs desc) as ranking
from company_year
where year is not null )
select * from company_year_rank
where ranking <=5
;


-- End --
