-- Q6
SELECT M.energy_products, M.sub_products, average_import, average_export
FROM
	(SELECT energy_products, sub_products, AVG(CAST(value_ktoe AS FLOAT)) AS average_import
	FROM importsofenergyproducts
	GROUP BY energy_products, sub_products)M
	INNER JOIN
	(SELECT energy_products, sub_products, AVG(CAST(value_ktoe AS FLOAT)) AS average_export
	FROM exportsofenergyproducts
	GROUP BY energy_products, sub_products)X
	ON M.energy_products = X.energy_products
	AND M.sub_products = X.sub_products;

-- Q12
SELECT country, CAST(year AS UNSIGNED) AS year, CAST(energy_per_gdp AS FLOAT)AS energy_per_gdp, CAST(biofuel_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS biofuel_per_gdp, CAST(nuclear_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS nuclear_per_gdp,
CAST(coal_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS coal_per_gdp, CAST(gas_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS gas_per_gdp, CAST(oil_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS oil_per_gdp,
CAST(solar_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS solar_per_gdp, CAST(wind_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS wind_per_gdp, CAST(hydro_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS hydro_per_gdp,
CAST(fossil_fuel_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS fossil_fuel_per_gdp, CAST(low_carbon_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS low_carbon_per_gdp, 
CAST(renewables_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS renewables_per_gdp, CAST(other_renewable_consumption AS FLOAT)*1000000000/CAST(gdp AS FLOAT) AS other_renewable_per_gdp
FROM owid_energy_data 
WHERE CAST(year AS UNSIGNED) BETWEEN 2008 AND 2018
AND country IN
	(SELECT country FROM
		(SELECT country, AVG(CAST(gdp AS FLOAT)) AS avg_gdp FROM owid_energy_data
		WHERE CAST(year AS UNSIGNED) BETWEEN 2008 AND 2018
		GROUP BY country)T1
	WHERE avg_gdp BETWEEN 0.9*(SELECT AVG(CAST(gdp AS FLOAT)) FROM owid_energy_data WHERE country = "Singapore" AND CAST(year AS UNSIGNED) BETWEEN 2008 AND 2018) 
    AND 1.1*(SELECT AVG(CAST(gdp AS FLOAT)) FROM owid_energy_data WHERE country = "Singapore" AND CAST(year AS UNSIGNED) BETWEEN 2008 AND 2018));

SELECT country, AVG(CAST(gdp AS FLOAT)) FROM owid_energy_data 
WHERE CAST(year AS UNSIGNED) BETWEEN 2008 AND 2018
GROUP BY country 
HAVING country IN ("Singapore", "Hong Kong", "Qatar", "Austria", "Chile", "Peru", "Romania");
