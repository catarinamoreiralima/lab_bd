-- Exercício 4 - View Problemas_aeroportos
-- Depende das views Aeroportos_sem_cidades e Cidades_brasileiras (ex2.sql)

-- ============================================================
-- Criação da view
-- ============================================================

CREATE OR REPLACE VIEW Problemas_aeroportos AS
WITH distancias AS (
    SELECT
        a.id,
        a.name,
        a.latitude_deg,
        a.longitude_deg,
        c.name       AS nome_cidade_candidata,
        c.population AS populacao_cidade_candidata,
        earth_distance(
            ll_to_earth(a.latitude_deg, a.longitude_deg),
            ll_to_earth(c.latitude,     c.longitude)
        ) AS distancia_metros
    FROM Aeroportos_sem_cidades a
    CROSS JOIN Cidades_brasileiras c
)
SELECT
    id,
    name,
    latitude_deg,
    longitude_deg,
    nome_cidade_candidata,
    populacao_cidade_candidata,
    ROUND(distancia_metros::numeric, 2) AS distancia_metros
FROM distancias
WHERE distancia_metros <= 10000
ORDER BY id, distancia_metros;

-- ============================================================
-- Testes e exemplos de tuplas
-- ============================================================

\echo '========================================================='
\echo 'TESTE 1 - Primeiras tuplas da view Problemas_aeroportos'
\echo 'Resultado esperado: aeroportos sem city_id com cidades brasileiras a ate 10 km de distancia.'
\echo '========================================================='

SELECT * FROM Problemas_aeroportos LIMIT 20;

\echo '========================================================='
\echo 'TESTE 2 - Total de linhas (pares aeroporto x cidade)'
\echo '========================================================='

SELECT COUNT(*) AS total_pares FROM Problemas_aeroportos;

\echo '========================================================='
\echo 'TESTE 3 - Quantos aeroportos distintos tem problema'
\echo '========================================================='

SELECT COUNT(DISTINCT id) AS total_aeroportos_problematicos
FROM Problemas_aeroportos;
