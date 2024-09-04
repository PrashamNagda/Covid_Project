# COVID-19 Data Analysis Project

This project involves analyzing COVID-19 data, focusing on understanding the spread of the virus, its impact on different populations, and the progress of vaccination efforts globally.

## Table of Contents

- [Project Overview](#project-overview)
- [Data Source](#data-source)
- [SQL Queries and Analysis](#sql-queries-and-analysis)
  - [COVID-19 Deaths by Continent](#covid-19-deaths-by-continent)
  - [Total Cases vs. Total Deaths](#total-cases-vs-total-deaths)
  - [Infection Rate Compared to Population](#infection-rate-compared-to-population)
  - [Countries with the Highest Death Count per Population](#countries-with-the-highest-death-count-per-population)
  - [Vaccination Progress](#vaccination-progress)
  - [Global Trends](#global-trends)
- [Creating Views for Visualization](#creating-views-for-visualization)
- [Conclusion](#conclusion)

## Project Overview

The aim of this project is to perform a comprehensive analysis of COVID-19 data, examining various aspects such as total cases, deaths, and vaccination rates across different countries and continents. The analysis includes calculating key metrics like death percentage, infection rate, and vaccination coverage.

## Data Source

The data used in this project was sourced from [Our World in Data - COVID-19](https://ourworldindata.org/covid-deaths). The dataset includes information on COVID-19 cases, deaths, and vaccinations, segmented by location and date.

## SQL Queries and Analysis

### COVID-19 Deaths by Continent
```sql
SELECT *
FROM CovidProject..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3, 4;
```
This query retrieves all COVID-19 death records by continent, ordered by specific criteria.

### Total Cases vs. Total Deaths
```sql
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidProject..CovidDeaths$
WHERE location LIKE '%India%'
ORDER BY 1, 2;
```
This analysis shows the likelihood of dying if infected with COVID-19 in a specific country (e.g., India).

### Infection Rate Compared to Population
```sql
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS PercentofPopulationInfected
FROM CovidProject..CovidDeaths$
WHERE location LIKE '%India%'
ORDER BY 1, 2;
```
This query calculates the percentage of the population that got infected with COVID-19.

### Countries with the Highest Death Count per Population
```sql
SELECT Location, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM CovidProject..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;
```
Identifies countries with the highest death counts relative to their population.

### Vaccination Progress
```sql
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths$ dea
JOIN CovidProject..CovidVaccinations$ vac
   ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;
```
Analyzes the progress of vaccination efforts, calculating the rolling total of people vaccinated over time.

### Global Trends
```sql
SELECT date, SUM(new_cases) AS Total_cases, SUM(cast(new_deaths AS int)) AS TotalDeaths, 
       SUM(cast(new_deaths AS int))/SUM(New_cases)*100 AS DeathPercentage
FROM CovidProject..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;
```
Provides a global overview of COVID-19 trends, including total cases, deaths, and death percentages by date.

## Creating Views for Visualization
```sql
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths$ dea
JOIN CovidProject..CovidVaccinations$ vac
   ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
```
This view stores the vaccination data for further visualization and analysis.

## Conclusion

This project provides insights into the COVID-19 pandemic's impact across different regions, highlighting key trends in cases, deaths, and vaccinations. The SQL queries used in this analysis can serve as a foundation for further exploration and visualization of the data.
