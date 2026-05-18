---- Q1 -----
CREATE MATERIALIZED VIEW Aeroportos_Brasileiros as 
SELECT 
	a.name as Nome_Aeroporto, 
	a.latitude_deg as Latitude, 
	a.longitude_deg as Longitude, 
	co.name as País, 
	co.continent_id as Continente, 
	ci.name as Cidade, 
	ci.population as População_Cidade
FROM airports a
JOIN cities    ci ON a.city_id        = ci.id
JOIN countries co ON ci.country_id    = co.id
JOIN continents ct ON co.continent_id = ct.id
WHERE co.name='Brazil'

-- Ver algumas tuplas
SELECT * FROM Aeroportos_Brasileiros LIMIT 10;

-- Contar total de tuplas
SELECT COUNT(*) FROM Aeroportos_Brasileiros;