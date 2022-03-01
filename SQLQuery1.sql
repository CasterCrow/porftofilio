select * from [data visualization]..CovidDeaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases) *100 as deathPercentage
from [data visualization]..CovidDeaths
where location like '%Egypt%'
order by 1,2

select location,date,population,total_cases,(total_cases/population) *100 as CasesPercentage
from [data visualization]..CovidDeaths
where location like '%States%'
order by 1,2


select location,population,max(total_cases),max((total_cases/population)) *100 as CasesPercentage
from [data visualization]..CovidDeaths
where continent is not null
group by location,population
order by 3 asc


select location,max(cast (total_deaths as int)) as maxdeaths
from [data visualization]..CovidDeaths
where continent is not null
group by location
order by maxdeaths desc



select location,max(cast (total_deaths as int)) as maxdeaths
from [data visualization]..CovidDeaths
where continent is  null
group by location
order by maxdeaths desc


select continent,max(cast (total_deaths as int)) as maxdeaths
from [data visualization]..CovidDeaths
where continent is not null
group by continent
order by maxdeaths desc

select date,sum(new_cases)as total_cases,sum(cast(new_deaths as int))as totalDeaths,sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage
from [data visualization]..CovidDeaths
where continent is not null
group by date
order by 1,2

select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as totalDeaths,sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage
from [data visualization]..CovidDeaths
where continent is not null
order by 1,2


select a.continent,a.location,a.date,a.population,b.new_vaccinations
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null
order by 2,3

select sum(a.new_cases)as total_cases,sum(cast(b.new_vaccinations as int)) as totalvaccinations,sum(cast(b.new_vaccinations as int))/
sum(a.new_cases) *100 as totalvaccpercentage
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null
and b.continent is not null
--group by a.total_cases
--order by 2,3


select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over (partition by a.location
order by a.location,a.date) as totalvaccinations
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null
--group by a.location
order by 2,3

select a.location,sum(cast(b.new_vaccinations as int))  as totalvaccinations
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null
group by a.location
order by 1,2




with popvsvacc(continent,location,date,population,new_vaccinations,totalvaccinations)

as(select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over (partition by a.location
order by a.location,a.date) as totalvaccinations
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null
--group by a.location
--order by 2,3
)
select * ,(totalvaccinations/population)*100 as totalvaccpercentage
from popvsvacc



select sum(distinct(a.population)) as pop,sum(cast(b.new_vaccinations as int)) as total_vaccinations
,(sum(cast(b.new_vaccinations as int))/sum(distinct(a.population))) *100 as peopvaccpercentage
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null
--group by a.location
--order by 1,2




create view percentpeoplevaccinated as
select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over (partition by a.location
order by a.location,a.date) as totalvaccinations
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null


create view percentpeopledeaths as

select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as totalDeaths,sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage
from [data visualization]..CovidDeaths
where continent is not null

create view totalpeoplevaccinatedoverall as

select sum(distinct(a.population)) as pop,sum(cast(b.new_vaccinations as int)) as total_vaccinations
,(sum(cast(b.new_vaccinations as int))/sum(distinct(a.population))) *100 as peopvaccpercentage
from [data visualization]..CovidDeaths as a
join [data visualization]..CovidVaccinetion as b
on a.location=b.location
and a.date=b.date
where a.continent is not null


create view totaldeathspercontinent as
select continent,max(cast (total_deaths as int)) as maxdeaths
from [data visualization]..CovidDeaths
where continent is not null
group by continent


create view maxdeatheachcountry as
select location,max(cast (total_deaths as int)) as maxdeaths
from [data visualization]..CovidDeaths
where continent is not null
group by location
