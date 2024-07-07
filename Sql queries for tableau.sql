select cast(total_deaths as signed) from coviddeathscsv;

select continent, max(cast(total_deaths as signed)) as TotalDeathCount 
 from coviddeathscsv
 where continent is not null
 group by continent 
 order by TotalDeathCount desc; 
 
 
 --- 1. Total cases, deaths and deathpercentage 

select sum(new_cases) as total_cases, 
sum(cast(new_deaths as signed)) as total_deaths,
sum(cast(new_deaths as signed)) / sum(new_cases)*100 as 
DeathPercentage 
from coviddeathscsv
where continent is not null 
order by 1,2;

--- 2. Total Deaths per Continent


select location, Sum(cast(new_deaths as signed)) as TotalDeathCount
from coviddeathscsv
where continent is null
and location not in ('World', 'European Union', 'International')
group by location
order by TotalDeathCount desc;

--- 3 Percent Population Infected Per Country

 select location, population, max(total_cases) as 
 HighestInfectionCount, Max((total_cases/population))*100
 as PercentPopulationInfected 
 from coviddeathscsv
 group by location, population
 order by PercentPopulationInfected desc;
 
 --- 4 Percent Popolation Infected
 
  select location, population, date, max(total_cases) as 
 HighestInfectionCount, Max((total_cases/population))*100
 as PercentPopulationInfected 
 from coviddeathscsv
 group by location, population, date
 order by PercentPopulationInfected desc;
