-- Instalar extensões
CREATE EXTENSION IF NOT EXISTS cube CASCADE;
CREATE EXTENSION IF NOT EXISTS earthdistance CASCADE;

-- View Aeroportos Sem Cidades
CREATE OR REPLACE VIEW Aeroportos_sem_cidades AS
SELECT id, name, latitude_deg, longitude_deg
FROM airports
WHERE city_id IS NULL;

-- View Cidades Brasileiras
CREATE OR REPLACE VIEW Cidades_brasileiras AS
SELECT ci.id, ci.name, ci.population, ci.latitude, ci.longitude
FROM cities ci
JOIN countries co ON ci.country_id = co.id
WHERE co.name = 'Brazil'
  AND ci.population >= 100000;

-- Consulta Final
WITH distancias AS (
    SELECT
        a.name                    AS nome_aeroporto,
        c.name                    AS nome_cidade,
        c.population              AS populacao_cidade,
        earth_distance(
            ll_to_earth(a.latitude_deg, a.longitude_deg),
            ll_to_earth(c.latitude,     c.longitude)
        ) AS distancia_metros
    FROM Aeroportos_sem_cidades a, Cidades_brasileiras c
)
SELECT
    nome_aeroporto,
    nome_cidade,
    populacao_cidade,
    ROUND(distancia_metros::numeric, 2) AS distancia_metros
FROM distancias
WHERE distancia_metros <= 10000
ORDER BY nome_aeroporto, distancia_metros;