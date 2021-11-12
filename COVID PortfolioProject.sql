
Select*
From PortfolioProject..CovidDeaths
Order by 3,4

--Select*
--From PortfolioProject..CovidVaccinations
--Order by 3,4

Select location, date,total_cases, new_cases, total_deaths, new_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at Total cases vs Total deaths in South Africa
-- Shows likelihood of dying if you contract covid19 in South Africa

Select location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'South Africa'
Order by 1,2

--Looking at Total cases vs Population
--Shows what percentage  of population got covid in South Africa


Select location, date,total_cases,population, (total_cases/population)*100 as PercentPopulationInfected 
From PortfolioProject..CovidDeaths
Where location = 'South Africa'
Order by 1,2


--Likelihood of dying if you contract covid in Madagascar

Select location,date,population, total_deaths,(total_deaths/population)*100 as DeathPercentage 
From PortfolioProject..CovidDeaths
Where location = 'Madagascar'
Order by 1,2


--Looking at Countires with Highest infection rate compared to Population


Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location = 'South Africa'
Group by location, population
Order by PercentPopulationInfected desc

-- Looking at countries with the Highest Death rate compared to Population

Select location,population,MAX( total_cases) as HighestDeathCount,MAX(total_cases/population)*100 as DeathRate
From PortfolioProject..CovidDeaths
where location is not null
Group by location, population
order by DeathRate desc


--Showing countries with Highest deaths count per Population 


Select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'South Africa'
Where location is not null
Group by location
Order by  TotalDeathCount desc


--Showing continent with the highest death count per Population

Select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc


--GLOBAL NUMBERS
--Looking at World Total cases and Total deaths


Select SUM(new_cases) as total_cases ,SUM(cast(new_deaths as int)) as total_deaths, SUM(new_cases)/SUM(cast(new_deaths as int))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Total Population vs Vaccincations

--Using CTE

With PopVsVac ( Continent, location, date,Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
--Order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopVsVac


