select * from coviddeathscsv where continent is not null;


--- select * from covidvaccinations order by 3,4;

 --- Selecting the data that we use from coviddeaths
 
 select location, date, total_cases, new_cases, 
 total_deaths, population from coviddeathscsv
 where continent is not null 
 order by 1,2;
 
 --- Total cases vs Total deaths
 
 Select location, date, total_cases, total_deaths, 
 (total_deaths/total_cases)*100 as DeathPercentage
 from coviddeathscsv
 where continent is not null
 order by 1,2;
 
  //** The chances of people die who effected with 
        covid in United States **/
  
  select location, date, total_cases, total_deaths,
  (total_deaths/total_cases)*100 as DeathPercentage
  from coviddeathscsv
  where location like '%states%'
  order by 1,2;
  
   --- Total cases vs Population
   --- shows the percentage of people got Covid
   
   select location, date, Population, total_cases,
   (total_cases/population)*100 as PercentPopulationInfected
   from coviddeathscsv
   order by 1,2;
 
 --- The country  with highest infection rate compared to population
 
 select location, population, max(total_cases) as 
 HighestInfectionCount, Max((total_cases/population))*100
 as PercentPopulationInfected 
 from coviddeathscsv
 group by location, population
 order by PercentPopulationInfected desc;
 
 --- To get the Highest Death Count per Population by location
 
 select location, max(cast(total_deaths as signed)) as TotalDeathCount 
 from coviddeathscsv
 where continent is not null
 group by location 
 order by TotalDeathCount desc;
 
 
 --- To extract total death counts by the continent 
 
 select continent, max(cast(total_deaths as signed)) as TotalDeathCount 
 from coviddeathscsv
 where continent is not null
 group by continent 
 order by TotalDeathCount desc;
 
 --- TO extract the highest death counts per population by continents
 
  select continent, max(cast(total_deaths as signed)) as TotalDeathCount 
 from coviddeathscsv
 where continent is not null
 group by continent 
 order by TotalDeathCount desc;
 
 --- Total cases, deaths & their deathpercentage by date across the world
 
 select date, sum(new_cases) as total_cases, 
 sum(cast(new_deaths as signed)) as total_deaths,
 sum(cast(new_deaths as signed)) / sum(new_cases)*100 as 
 DeathPercentage
 from coviddeathscsv
 where continent is not null
 group by date
 order by 1,2;

--- Total cases, deaths and deathpercentage 

select sum(new_cases) as total_cases, 
sum(cast(new_deaths as signed)) as total_deaths,
sum(cast(new_deaths as signed)) / sum(new_cases)*100 as 
DeathPercentage 
from coviddeathscsv
where continent is not null 
order by 1,2;

--- Joining  coviddeaths and covidvaccinations 

select* from 
coviddeathscsv dea 
join covidvaccinationscsv vac
	on dea.location = vac.location
	and dea.date = vac.date;

--- Total amount of people got vaccinated accross the world

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from coviddeathscsv dea
join  covidvaccinationscsv vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--- USE CTE (Common Table Expression) to extract the rolling total 

with PopvsVac (continent, Location, date, population, 
new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations,
    Sum(cast(vac.new_vaccinations as signed)) 
    over (partition by dea.location order by dea.location, dea.date)
	as RollingPeopleVaccinated
    from coviddeathscsv dea
    join covidvaccinationscsv vac
		on dea.location = vac.location
        and dea.date = vac.date
	where dea.continent is not null
)
select *, (RollingPeopleVaccinated / Population)*100 
from PopvsVac;

--- TEMP Table 


/*CREATE TEMPORARY TABLE #PercentPopulationVaccinated (
    Continent VARCHAR(255),
    Location VARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);


INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM
    coviddeathscsv dea
JOIN
    covidvaccinationscsv vac ON dea.location = vac.location AND dea.date = vac.date;

SELECT *, (RollingPeopleVaccinated / Population) * 100
 from #PercentPopulationVaccinated; */


 ---   Creating view to store data for later visualizations
 
 create view PercentPopulationVaccinatted 
 as 
 select dea.continent, dea.location, dea.date, dea.population,
 vac.new_vaccinations, 
 sum(cast(new_vaccinations as SIGNED)) OVER (partition by
 dea.location order by dea.location, dea.date) 
 as RollingPeopleVaccinated
 from
	coviddeathscsv dea
join 
	covidvaccinationscsv vac
on  dea.location = vac.location
	and dea.date = vac.date
where
	dea.continent is not null;
    
SELECT * FROM
 `project portfolio v`.percentpopulationvaccinatted;