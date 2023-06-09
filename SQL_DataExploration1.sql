

--Select Data that we are going to be using

SELECT [Date], [State Postal Code], [Population Staying at Home], [Population Not Staying at Home], [Number of Trips <1], [Number of Trips 1-3], [Number of Trips 3-5], [Number of Trips 5-10], [Number of Trips 10-25], [Number of Trips 25-50], [Number of Trips 50-100], [Number of Trips 100-250], [Number of Trips 250-500], [Number of Trips > 500]  
FROM PortfolioProject..Trips_by_Distance
--GROUP BY level
WHERE level = 'state'
ORDER BY 2, 1 desc

--Total Population And Converted Date

SELECT [State Postal Code], 
CAST(LEFT([Date], 4) as int) as [Year], 
CAST(RIGHT([Date], 2) as int) as [Day], 
CAST(SUBSTRING([Date], 6, 2) as int) as [Month], 
case when [Date] like '%/%'
            then  CONVERT(DATE, [Date], 111)
			else [Date]
            end  as Date_Converted, 
CAST([Population Staying at Home] as int) + CAST([Population Not Staying at Home] as int) as Total_Population, 
[Population Staying at Home], [Population Not Staying at Home]  
FROM PortfolioProject..Trips_by_Distance
WHERE level like '%state%'
ORDER BY 1,3,2



-- Looking at AVG Population Staying at Home and Population Not Staying at Home by State

SELECT [State Postal Code], 
		Avg(convert(bigint,[Population Staying at Home])) as Avg_Home, 
		Avg(CAST([Population Not Staying at Home] as bigint)) as Avg_NotHome,
		Avg(CAST([Population Staying at Home] as float) + CAST([Population Not Staying at Home] as float)) as Avg_TotalPopulation
FROM PortfolioProject..Trips_by_Distance
WHERE level like '%state%'
GROUP BY [State Postal Code]
ORDER BY 1



-- Using CTE to perform Calculation
--- Percentage_Not_Staying_at_Home

With PercentPopulationNotStayingAtHome
(Date, State, Total_Population, Population_Staying_at_Home, Population_Not_Staying_at_Home)
as
(
SELECT 
	case when [Date] like '%/%'
            then  CONVERT(DATE, [Date], 111)
			else [Date]
            end  as Date_Converted, 
	[State Postal Code], 
	CAST([Population Staying at Home] as float) + CAST([Population Not Staying at Home] as int) as Total_Population, 
	CAST([Population Staying at Home] as float), CAST([Population Not Staying at Home] as int)
FROM PortfolioProject..Trips_by_Distance
WHERE level like '%state%'
)
Select *, Population_Not_Staying_at_Home/Total_Population*100 as Percentage_Not_Staying_at_Home
From PercentPopulationNotStayingAtHome
--where [State]='AK'
order by 2


--- Percentage_Not_Staying_at_Home BREAKING THINGS DOWN BY Full State Name, Year


With PercentPopulationNotStayingAtHome (
[Year], State, Total_Population, Population_Staying_at_Home, Population_Not_Staying_at_Home)
as
(
SELECT 
	CAST(LEFT([Date], 4) as int) as [Year], 
	[State Postal Code],
	CAST([Population Staying at Home] as float) + CAST([Population Not Staying at Home] as float) as Total_Population, 
	cast([Population Staying at Home] as float), 
	cast([Population Not Staying at Home] as float)
FROM PortfolioProject.dbo.Trips_by_Distance
WHERE level like '%state%'

),
PercentPopulationNotStayingAtHome_1 AS 
(
SELECT [Year], [State], 

Total_Population, Population_Staying_at_Home, Population_Not_Staying_at_Home
FROM PercentPopulationNotStayingAtHome
)

Select [Year], 
	Avg(Total_Population) as Avg_TotalPopulation, 
	Avg(Population_Staying_at_Home) as Avg_StayingHome, 
	Avg(Population_Not_Staying_at_Home) as Avg_StayingNotHome,
	Avg(Population_Not_Staying_at_Home/Total_Population*100) Percentage_Not_Staying_at_Home,
	CASE [State]
		WHEN 'AL' THEN 'Alabama'
		WHEN 'AK' THEN 'Alaska'
		WHEN 'AZ' THEN 'Arizona'
		WHEN 'AR' THEN 'Arkansas'
		WHEN 'CA' THEN 'California'
		WHEN 'CO' THEN 'Colorado'
		WHEN 'CT' THEN 'Connecticut'
		WHEN 'DE' THEN 'Delaware'
		WHEN 'DC' THEN 'District of Columbia'
		WHEN 'FL' THEN 'Florida'
		WHEN 'GA' THEN 'Georgia'
		WHEN 'HI' THEN 'Hawaii'
		WHEN 'ID' THEN 'Idaho'
		WHEN 'IL' THEN 'Illinois'
		WHEN 'IN' THEN 'Indiana'
		WHEN 'IA' THEN 'Iowa'
		WHEN 'KS' THEN 'Kansas'
		WHEN 'KY' THEN 'Kentucky'
		WHEN 'LA' THEN 'Louisiana'
		WHEN 'ME' THEN 'Maine'
		WHEN 'MD' THEN 'Maryland'
		WHEN 'MA' THEN 'Massachusetts'
		WHEN 'MI' THEN 'Michigan'
		WHEN 'MN' THEN 'Minnesota'
		WHEN 'MS' THEN 'Mississippi'
		WHEN 'MO' THEN 'Missouri'
		WHEN 'MT' THEN 'Montana'
		WHEN 'NE' THEN 'Nebraska'
		WHEN 'NV' THEN 'Nevada'
		WHEN 'NH' THEN 'New Hampshire'
		WHEN 'NJ' THEN 'New Jersey'
		WHEN 'NM' THEN 'New Mexico'
		WHEN 'NY' THEN 'New York'
		WHEN 'NC' THEN 'North Carolina'
		WHEN 'ND' THEN 'North Dakota'
		WHEN 'OH' THEN 'Ohio'
		WHEN 'OK' THEN 'Oklahoma'
		WHEN 'OR' THEN 'Oregon'
		WHEN 'PA' THEN 'Pennsylvania'
		WHEN 'RI' THEN 'Rhode Island'
		WHEN 'SC' THEN 'South Carolina'
		WHEN 'SD' THEN 'South Dakota'
		WHEN 'TN' THEN 'Tennessee'
		WHEN 'TX' THEN 'Texas'
		WHEN 'UT' THEN 'Utah'
		WHEN 'VT' THEN 'Vermont'
		WHEN 'VA' THEN 'Virginia'
		WHEN 'WV' THEN 'West Virginia'
		WHEN 'WA' THEN 'Washington'
		WHEN 'WI' THEN 'Wisconsin'
		WHEN 'WY' THEN 'Wyoming'
		ELSE [State]
		END as State_Name
From PercentPopulationNotStayingAtHome_1
Group by [Year], [State]
ORDER BY 1, 6



-- Subqueries in the Select Filtered by Year
--- States with a greater than Average Not staying at Home over the Country 

With PercentPopulationNotStayingAtHome
([Year], State, Total_Population, Population_Staying_at_Home, Population_Not_Staying_at_Home)
as
(
SELECT 
	CAST(LEFT([Date], 4) as int) as [Year], 
	[State Postal Code], 
	CAST([Population Staying at Home] as float) + CAST([Population Not Staying at Home] as float) as Total_Population, 
	cast([Population Staying at Home] as float), 
	cast([Population Not Staying at Home] as float)
FROM PortfolioProject.dbo.Trips_by_Distance
WHERE level like '%state%'
)
Select [Year], [State], 
	Avg(Total_Population) as Avg_TotalPopulation_byYear, 
	Avg(Population_Staying_at_Home) as Avg_StayingHome_byYear, 
	Avg(Population_Not_Staying_at_Home) as Avg_StayingNotHome_byYear,
	Avg(Population_Not_Staying_at_Home/Total_Population*100) Percentage_Not_Staying_at_Home,
		(
		SELECT Avg(Population_Not_Staying_at_Home)/Avg(Total_Population)*100 
		FROM PercentPopulationNotStayingAtHome
		Where year = 2019
		) as Country_AvgPercentage_Not_Staying_at_Home_2019
From PercentPopulationNotStayingAtHome
Where year = 2019
Group by [Year], [State]
Having Avg(Population_Not_Staying_at_Home/Total_Population*100) > 80.5656113114908
ORDER BY 1, 6 desc






