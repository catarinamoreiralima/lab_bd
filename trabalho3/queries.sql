-- Exercício 1: Total de pontos por piloto, por ano, em ordem descendente de pontuação.
-- driverstandings armazena standings cumulativos por rodada.
-- MAX(points) por piloto/temporada retorna o total acumulado na última rodada (= total da temporada).

SELECT
    d.given_name || ' ' || d.family_name AS driver_name,
    se.season_year                        AS year,
    MAX(st.points)                        AS total_points
FROM driverstandings ds
JOIN standings st ON st.standings_id = ds.standings_id
JOIN drivers d    ON d.driver_id     = ds.driver_id
JOIN seasons se   ON se.season_id    = st.season_id
GROUP BY d.driver_id, d.given_name, d.family_name, se.season_year
ORDER BY se.season_year DESC, total_points DESC;

-- Exercício 2: Piloto que partiu mais vezes em primeiro lugar no grid.

SELECT
    d.given_name || ' ' || d.family_name AS driver_name,
    COUNT(*)                             AS pole_positions
FROM results r
JOIN drivers d ON d.driver_id = r.driver_id
WHERE r.grid = 1
GROUP BY d.driver_id, d.given_name, d.family_name
ORDER BY pole_positions DESC
LIMIT 1;

-- Exercício 3: Para cada país que sedia corridas, quantidade de cidades e total de aeroportos.
-- Filtra países vinculados a circuitos por races -> circuits -> cities -> countries.

SELECT
    co.country_name                      AS country,

    -- DISTINCT evita duplicar cidades por múltiplos aeroportos
    COUNT(DISTINCT ci.city_id)           AS city_count,
    COUNT(DISTINCT a.airport_id)         AS total_airports
FROM countries co

-- Todas as cidades do país
JOIN cities ci
ON ci.country_id = co.country_id

-- LEFT JOIN mantém cidades mesmo sem aeroporto
LEFT JOIN airports a
ON a.city_id = ci.city_id

-- Apenas países que aparecem em circuitos com corridas
WHERE co.country_id IN (
    SELECT DISTINCT ci2.country_id
    FROM races ra
    JOIN circuits circ
        ON circ.circuit_id = ra.circuit_id
    JOIN cities ci2
        ON ci2.city_id = circ.circuit_city_id
)
GROUP BY co.country_id, co.country_name
ORDER BY co.country_name;
