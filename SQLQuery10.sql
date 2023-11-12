--Select *
--From PortfolioProject..CovidDeaths
--WHERE continent is not null
--order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

--Select location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths
--WHERE continent is not null
--order by 1,2

--Looking at the Total Cases vs Total Deaths, how many cases are there in their country, what is the % of people who died
--Shows the likelihood of dieng if you contract Covid19 in your country
--Select location, date, total_cases,total_deaths, ROUND(total_deaths/total_cases,4)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--WHERE location like '%state%'
--WHERE continent is not null
--order by 1,2

--Looking at the total cases vs population
--Select location, date, population, total_cases,(total_cases/population)*100 as CovidPositive
--From PortfolioProject..CovidDeaths
--WHERE location like '%state%'
--WHERE continent is not null
--order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population
--Select location, population, max(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as PercentInfected
--From PortfolioProject..CovidDeaths
--Group by Location, Population
--WHERE continent is not null
--order by PercentInfected desc

--Showing the countries with the highest Death Count per Population
--Select location, max(cast(total_deaths as int)) as TotalDeathcount
--From PortfolioProject..CovidDeaths
--Where continent is not null
--Group by Location
--order by TotalDeathcount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT
--Select continent, max(cast(total_deaths as int)) as TotalDeathcount
--From PortfolioProject..CovidDeaths
--Where continent is not null
--Group by continent
--order by TotalDeathcount desc

--Showing the continents with the highest death count -Use this to get this proper numbers for continents (uses the null that shows only the continents count totals)
--Select location, max(cast(total_deaths as int)) as TotalDeathcount
--From PortfolioProject..CovidDeaths
--Where continent is null
--Group by location
--order by TotalDeathcount desc

--Global Numbers

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--WHERE continent is not null
----Group by date
--order by 1,2

--Looking at Total Population vs Vaccinations
--Use CTE
--With PopVSVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as INT)) OVER (Partition by dea.location
--ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is not null
--)
--Select *, (RollingPeopleVaccinated/population)*100
--From PopVSVac

--Temp Table
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--Insert Into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as INT)) OVER (Partition by dea.location
--ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is not null

--Select *, (RollingPeopleVaccinated/population)*100
--From #PercentPopulationVaccinated
--Order by 1,2

--Create View to store data
Create View PercentPopulationVaccinate as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as INT)) OVER (Partition by dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

Select * 
From PercentPopulationVaccinate