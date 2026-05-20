select * from countries c

---- CRIAÇÃO DA VIEW (letra (a))-----
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

---- MEDIÇÃO DOS TEMPOS (letra (b)) ----

-- Consulta sobre a Visão Materializada
EXPLAIN ANALYZE
SELECT * FROM Aeroportos_Brasileiros;

-- Consulta equivalente sobre as tabelas-base
EXPLAIN ANALYZE
SELECT
    a.name          AS nome_aeroporto,
    a.latitude_deg  AS latitude,
    a.longitude_deg AS longitude,
    co.name         AS nome_pais,
    ct.name         AS continente,
    ci.name         AS nome_cidade,
    ci.population   AS populacao_cidade
FROM airports a
JOIN cities     ci ON a.city_id       = ci.id
JOIN countries  co ON ci.country_id   = co.id
JOIN continents ct ON co.continent_id = ct.id
WHERE co.name = 'Brazil';

---- MEDIÇÃO DE ARMAZENAMENTO (letra (b)) ----

-- Tamanho da visão materializada
SELECT pg_size_pretty(
    pg_total_relation_size('Aeroportos_Brasileiros')
) AS tamanho_visao_materializada;

---- NECESSIDADE DO REFRESH (letra (c) ----

-- Verificar valor atual na view, depois consultar view pré e pós REFRESH
SELECT Cidade, População_Cidade
FROM Aeroportos_Brasileiros
WHERE Cidade = 'São Paulo'
LIMIT 1;

-- Ataulizar a tabela-base
UPDATE cities
SET population = population + 1000
WHERE name = 'São Paulo';

-- Executar o REFRESH
REFRESH MATERIALIZED VIEW Aeroportos_Brasileiros;

-- Desfazer a alteração
UPDATE cities
SET population = population - 1000
WHERE name = 'São Paulo';

REFRESH MATERIALIZED VIEW Aeroportos_Brasileiros;