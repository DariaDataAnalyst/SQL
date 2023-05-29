/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]
order by [Call Date]

----------------------------------------------
-- Standardize Date Format, Convert STRING to Data Format

ALTER TABLE Fire_Department_Calls_for_Service
Add Call_Date_Converted Date

Update Fire_Department_Calls_for_Service
SET Call_Date_Converted =
	case when [Call Date] like '%/%/%'
            then  CONVERT(DATE, [Call Date], 101)
			else [Call Date]
            end 
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]
Where [Call Date] like '%/%/%'


SELECT *
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]
where Call_Date_Converted is null


----------------------------------------------
-- Fix [City] field

SELECT DISTINCT([City]), count([City])
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]
--WHERE [Call Type] like '%Extrication%'
group by [City]
order by [City]





----------------------------------------------
--Replace not Consistent data in [Zipcode of Incident] field to N/A

SELECT DISTINCT([Zipcode of Incident]), count([Zipcode of Incident]), len([Zipcode of Incident])
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]
--WHERE [Call Type] like '%Extrication%'
group by [Zipcode of Incident]
order by [Zipcode of Incident]



SELECT [Zipcode of Incident],
	CASE WHEN len([Zipcode of Incident]) <> '5' THEN 'N/A'
	   ELSE [Zipcode of Incident]
	   END
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]



Update [Fire_Department_Calls_for_Service]
SET [Zipcode of Incident] = CASE WHEN len([Zipcode of Incident]) <> '5' THEN 'N/A'
	   ELSE [Zipcode of Incident]
	   END

----------------------------------------------

SELECT DISTINCT([Call Final Disposition]), count([Call Final Disposition])
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]
--WHERE [Call Type] is null
group by [Call Final Disposition]
order by [Call Final Disposition]



--------------------------------------------

SELECT DISTINCT([Zipcode of Incident]), count([Zipcode of Incident]), len([Zipcode of Incident])
FROM [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]
--WHERE [Call Type] like '%Extrication%'
group by [Zipcode of Incident]
order by [Zipcode of Incident]



Select [Zipcode of Incident]
, CASE When [Zipcode of Incident] LIKE '' THEN 'na'
	   ELSE [Zipcode of Incident]
	   END
From [PortfolioProject].[dbo].[Fire_Department_Calls_for_Service]


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
