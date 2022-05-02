-- Question 1/4


SELECT CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(YEAR(OrderDate) AS VARCHAR(4)) AS MonYr
	,ROUND((SUM(SalesAmount) - Sum(TotalProductCost)), 0) AS TotalProfit
FROM dbo.FactInternetSales
GROUP BY CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(YEAR(OrderDate) AS VARCHAR(4))
ORDER BY CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(YEAR(OrderDate) AS VARCHAR(4))


-- Question 2/4


SELECT SUM(sales.SalesAmount) AS TotalSales
	,sub.EnglishProductSubcategoryName
	,cat.EnglishProductCategoryName
	,geo.EnglishCountryRegionName
	,CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(YEAR(OrderDate) AS VARCHAR(4)) AS MonYr
FROM dbo.DimCustomer AS cust
LEFT JOIN dbo.DimGeography AS geo ON cust.GeographyKey = geo.GeographyKey
INNER JOIN dbo.FactInternetSales AS sales ON cust.CustomerKey = sales.CustomerKey
LEFT JOIN dbo.DimProduct AS prod ON sales.ProductKey = prod.ProductKey
LEFT JOIN dbo.DimProductSubcategory AS sub ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
WHERE cat.EnglishProductCategoryName <> 'Bikes'
	AND sub.EnglishProductSubcategoryName NOT LIKE 'Bike%'
GROUP BY sub.EnglishProductSubcategoryName
	,cat.EnglishProductCategoryName
	,geo.EnglishCountryRegionName
	,CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(YEAR(OrderDate) AS VARCHAR(4))
ORDER BY SUB.EnglishProductSubcategoryName


-- Question 3/4


SELECT *
FROM dbo.CanadianBikesView

SELECT COUNT(orderdate) AS TotalSold
	,EnglishProductSubcategoryName AS BikeType
FROM dbo.CanadianBikesView
GROUP BY EnglishProductSubcategoryName
ORDER BY TotalSold DESC
	,BikeType

----CHILDREN'S INFLUENCE IN TOTAL SALES

SELECT COUNT(orderdate) AS TotalSold
	,NumberChildrenAtHome
	,EnglishProductSubcategoryName AS BikeType
FROM dbo.CanadianBikesView
GROUP BY EnglishProductSubcategoryName
	,NumberChildrenAtHome
HAVING NumberChildrenAtHome >= 1
ORDER BY NumberChildrenAtHome DESC
	,TotalSold
	,BikeType

--Families with >=1 child:

--132/315 mountain bikes 42%
--60/144 touring bikes 41%
--160/465 road bikes 34%

----PROFIT MARGINS PER CATEGORY

SELECT ROUND((SUM(SalesAmount) - Sum(TotalProductCost)), 0) AS TotalProfit
	,EnglishProductSubcategoryName
FROM dbo.CanadianBikesView
GROUP BY EnglishProductSubcategoryName

--per unit profits:

--mountain bikes = $887 (mountain bikes high in profit & children sales)
--road bikes = $773
--touring bikes = $710

----CHECKING GEOGRAPHICAL SIGNIFICANCIES

SELECT SUM(SalesAmount) AS TotalSales
	,City
FROM dbo.CanadianBikesView
GROUP BY City
ORDER BY TotalSales DESC

SELECT ROUND((SUM(SalesAmount) - Sum(TotalProductCost)), 0) AS TotalProfit
	,City
FROM dbo.CanadianBikesView
GROUP BY City
ORDER BY TotalProfit DESC

SELECT COUNT(orderdate) AS TotalSold
	,City
FROM dbo.CanadianBikesView
GROUP BY City
ORDER BY TotalSold DESC

--per city & per unit profits:

--Cliffside = $787, 100 bycicles
--Langford = $817, 70 bycicles
--Oak Bay = $752 , 74 bycicles

--INCOME SIGNIFICANCE 

SELECT COUNT(OrderDate) AS HighIncomeCustomerSales
FROM dbo.CanadianBikesView
WHERE YearlyIncome > (
		SELECT AVG(YearlyIncome)
		FROM dbo.CanadianBikesView
		)
	AND EnglishProductSubcategoryName = 'Road Bikes'

SELECT COUNT(*) AS TotalNumberOfSales
FROM dbo.CanadianBikesView

SELECT SUM(NumberChildrenAtHome) AS MediumToLowIncomeSales
FROM dbo.CanadianBikesView
WHERE YearlyIncome < (
		SELECT AVG(YearlyIncome)
		FROM dbo.CanadianBikesView
		)
	AND EnglishProductSubcategoryName = 'Touring Bikes'

-- >60000 = 356/924; = 111 Road Bikes, 167 = Mountain Bikes , 78 = Touring Bikes
-- <60000 = 297/924; 179 = Road Bikes, 95 = Mountain Bikes, 23 = Touring Bikes


--Question 4/4


SELECT *
	,CAST(MONTH(OrderDate) AS VARCHAR(2)) + '-' + CAST(YEAR(OrderDate) AS VARCHAR(4)) AS MonYr
FROM dbo.DimCustomer AS cust
LEFT JOIN dbo.DimGeography AS geo ON cust.GeographyKey = geo.GeographyKey
INNER JOIN dbo.FactInternetSales AS sales ON cust.CustomerKey = sales.CustomerKey
LEFT JOIN dbo.DimProduct AS prod ON sales.ProductKey = prod.ProductKey
LEFT JOIN dbo.DimProductSubcategory AS sub ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey

--$ SALES AMOUNT PER U.S. STATE

SELECT SUM(sales.SalesAmount) AS TotalSales
	,geo.City
	,geo.StateProvinceName
FROM dbo.DimCustomer AS cust
LEFT JOIN dbo.DimGeography AS geo ON cust.GeographyKey = geo.GeographyKey
INNER JOIN dbo.FactInternetSales AS sales ON cust.CustomerKey = sales.CustomerKey
LEFT JOIN dbo.DimProduct AS prod ON sales.ProductKey = prod.ProductKey
LEFT JOIN dbo.DimProductSubcategory AS sub ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
GROUP BY geo.City
	,geo.StateProvinceName

--GENDER

SELECT *
FROM dbo.WorldBikesView

SELECT COUNT(OrderDate) AS TotalNumberOfSales
	,Gender
FROM dbo.WorldBikesView
GROUP BY Gender

--OCCUPATION

SELECT COUNT(OrderDate) AS TotalNumberOfSales
	,EnglishOccupation
FROM dbo.WorldBikesView
GROUP BY EnglishOccupation
ORDER BY TotalNumberOfSales DESC

--NUMBER OF CARS

SELECT COUNT(OrderDate) AS TotalNumberOfSales
	,NumberCarsOwned
FROM dbo.WorldBikesView
GROUP BY NumberCarsOwned
ORDER BY NumberCarsOwned

	

----Q3 BEFORE VIEW WAS MADE

	--SELECT *
	--FROM dbo.DimCustomer AS cust
	--LEFT JOIN dbo.DimGeography AS geo ON cust.GeographyKey = geo.GeographyKey
	--INNER JOIN dbo.FactInternetSales AS sales ON cust.CustomerKey = sales.CustomerKey
	--LEFT JOIN dbo.DimProduct AS prod ON sales.ProductKey = prod.ProductKey
	--LEFT JOIN dbo.DimProductSubcategory AS sub ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey
	--LEFT JOIN dbo.DimProductCategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
	--WHERE geo.CountryRegionCode = 'CA'
	--	AND cat.EnglishProductCategoryName = 'Bikes'

---- VIEW CREATED FOR Q3

	--CREATE VIEW CanadianBikesView
	--AS
	--SELECT sales.CustomerKey
	--	,geo.GeographyKey
	--	,cust.BirthDate
	--	,cust.MaritalStatus
	--	,cust.Gender
	--	,cust.YearlyIncome
	--	,cust.TotalChildren
	--	,cust.NumberChildrenAtHome
	--	,geo.CountryRegionCode
	--	,sales.ProductKey
	--	,sales.PromotionKey
	--	,sales.OrderQuantity
	--	,sales.TotalProductCost
	--	,sales.SalesAmount
	--	,sales.OrderDate
	--	,prod.Color
	--	,cat.EnglishProductCategoryName
	--	,sub.EnglishProductSubcategoryName
	--	,prod.EnglishProductName
	--	,geo.City
	--	,cust.EnglishOccupation
	--	,cust.NumberCarsOwned
	--FROM dbo.DimCustomer AS cust
	--LEFT JOIN dbo.DimGeography AS geo ON cust.GeographyKey = geo.GeographyKey
	--INNER JOIN dbo.FactInternetSales AS sales ON cust.CustomerKey = sales.CustomerKey
	--LEFT JOIN dbo.DimProduct AS prod ON sales.ProductKey = prod.ProductKey
	--LEFT JOIN dbo.DimProductSubcategory AS sub ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey
	--LEFT JOIN dbo.DimProductCategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
	--WHERE geo.CountryRegionCode = 'CA' 
	--	AND EnglishProductCategoryName = 'Bikes'

---- VIEW CREATED FOR Q4

	--CREATE VIEW WorldBikesView 
	--AS
	--SELECT sales.CustomerKey
	--	,geo.GeographyKey
	--	,cust.BirthDate
	--	,cust.MaritalStatus
	--	,cust.Gender
	--	,cust.YearlyIncome
	--	,cust.TotalChildren
	--	,cust.NumberChildrenAtHome
	--	,geo.CountryRegionCode
	--	,sales.ProductKey
	--	,sales.PromotionKey
	--	,sales.OrderQuantity
	--	,sales.TotalProductCost
	--	,sales.SalesAmount
	--	,sales.OrderDate
	--	,prod.Color
	--	,cat.EnglishProductCategoryName
	--	,sub.EnglishProductSubcategoryName
	--	,prod.EnglishProductName
	--	,geo.City
	--	,cust.EnglishOccupation
	--	,cust.NumberCarsOwned
	--FROM dbo.DimCustomer AS cust
	--LEFT JOIN dbo.DimGeography AS geo ON cust.GeographyKey = geo.GeographyKey
	--INNER JOIN dbo.FactInternetSales AS sales ON cust.CustomerKey = sales.CustomerKey
	--LEFT JOIN dbo.DimProduct AS prod ON sales.ProductKey = prod.ProductKey
	--LEFT JOIN dbo.DimProductSubcategory AS sub ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey
	--LEFT JOIN dbo.DimProductCategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
	--WHERE EnglishProductCategoryName = 'Bikes'