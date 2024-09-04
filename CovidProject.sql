select *
From CovidProject..CovidDeaths$
where continent IS NOT NULL
order by 3,4

--select *
--From CovidProject..CovidVaccinations$
--order by 3,4

-- Select Data that we are going to be using 
Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeaths$
order by 1,2

-- Looking at Total Cases Vs Total Deaths
-- Shows this likelihood of dying if you contract covid in your country 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject..CovidDeaths$
where location like '%India%'
order by 1,2

-- Looking at Total Cases Vs Population
-- Shows What percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentofPopulationInfected
From CovidProject..CovidDeaths$
where location like '%India%'
order by 1,2

--Looking at Countrieswith Highest Infection Rate Compared to population
Select Location,population, MAX(total_cases) as HighestInfecctionCount, Max((total_cases/population))*100 as PercentofPopulationInfected
From CovidProject..CovidDeaths$
--where location like '%India%'
Group by location, population
order by PercentofPopulationInfected desc


-- Show Countries With the highest deth count per Population 
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths$
--where location like '%India%'
where continent IS NOT NULL
Group by location
order by TotalDeathCount desc

-- LETS BREAK THINGS DOWN BY CONTINENT
-- Showing the Continents with the highest Death Count per Population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths$
--where location like '%India%'
where continent IS NOT NULL
Group by continent
order by TotalDeathCount desc


--Global Numbers on date
Select date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast (new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From CovidProject..CovidDeaths$
where continent IS NOT NULL
Group By date
order by 1,2

-- World Total cases, deaths , Death Percentage 
Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast (new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From CovidProject..CovidDeaths$
where continent IS NOT NULL
order by 1,2


-- Looking at total Population Vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths$ dea
Join  CovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent IS NOT NULL
	order by 2,3

-- USE CTE 
with PopvsVac (cotinent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths$ dea
Join  CovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent IS NOT NULL
	--order by 2,3 
)
select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--TEMP TABLE 

DROP table if exists #PercentPopulationnVaccinated
Create Table #PercentPopulationnVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric, 
)

Insert into #PercentPopulationnVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths$ dea
Join  CovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent IS NOT NULL
	--order by 2,3 
	
select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationnVaccinated


-- Creating View to store data for later Visualizations

Create View PercentPopulationnVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths$ dea
Join  CovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent IS NOT NULL


select *
From PercentPopulationnVaccinated 