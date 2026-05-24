-- Exercício 5 - View Correcao_aeroportos e atualização de city_id
-- Depende das views Problemas_aeroportos (ex4.sql) e Cidades_brasileiras (ex2.sql)

-- ============================================================
-- Criação da view Correcao_aeroportos
-- ============================================================

CREATE OR REPLACE VIEW Correcao_aeroportos AS
SELECT a.id, a.name, a.latitude_deg, a.longitude_deg, a.city_id
FROM airports a
WHERE a.id IN (SELECT id FROM Problemas_aeroportos);

-- ============================================================
-- Verificação da view antes da correção
-- ============================================================

\echo '========================================================='
\echo 'TESTE 1 - Aeroportos a corrigir'
\echo '========================================================='

SELECT * FROM Correcao_aeroportos ORDER BY id;

\echo '========================================================='
\echo 'TESTE 2 - Total de aeroportos a corrigir'
\echo '========================================================='

SELECT COUNT(*) AS total_aeroportos FROM Correcao_aeroportos;

-- ============================================================
-- Atualização: vincula cada aeroporto à cidade mais próxima
-- Usa Problemas_aeroportos para identificar as candidatas e Cidades_brasileiras para obter o id da cidade escolhida.
-- ============================================================

WITH cidade_mais_proxima AS (
    SELECT DISTINCT ON (pa.id)
        pa.id   AS airport_id,
        cb.id   AS city_id,
        pa.distancia_metros
    FROM Problemas_aeroportos pa
    JOIN Cidades_brasileiras cb ON pa.nome_cidade_candidata = cb.name
    ORDER BY pa.id, pa.distancia_metros ASC
)
UPDATE airports
SET city_id = cidade_mais_proxima.city_id
FROM cidade_mais_proxima
WHERE airports.id = cidade_mais_proxima.airport_id;

-- ============================================================
-- Verificação pós-correção
-- ============================================================

\echo '========================================================='
\echo 'TESTE 3 — Aeroportos que ainda nao tem cidade vinculada'
\echo '========================================================='

SELECT * FROM Aeroportos_sem_cidades LIMIT 10;

\echo '========================================================='
\echo 'TESTE 4 — Problemas_aeroportos apos correcao'
\echo '========================================================='

SELECT COUNT(*) AS restantes FROM Problemas_aeroportos;

\echo '========================================================='
\echo 'TESTE 5 — Correcao_aeroportos apos UPDATE'
\echo '========================================================='

SELECT * FROM Correcao_aeroportos ORDER BY id;
