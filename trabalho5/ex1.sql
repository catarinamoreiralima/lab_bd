-- =============================================================================
-- Exercício 1 — Índice sobre nome completo do piloto
--
-- Consulta: dado o nome exato de um piloto (given_name || ' ' || family_name),
-- recuperar sua nacionalidade.
--
-- Índice escolhido: HASH
-- Justificativa: o predicado é sempre igualdade exata (=), sem ranges, sem
-- ordenação, sem LIKE. Hash oferece lookup O(1) vs O(log N) do B-tree.
-- Nota: Hash não suporta INCLUDE no PostgreSQL, portanto o planner precisará
-- acessar a heap para buscar nationality_deprecated após o lookup no índice.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 0. ESTADO LIMPO
-- Remove o índice caso o arquivo seja re-executado
-- -----------------------------------------------------------------------------
DROP INDEX IF EXISTS idx_drivers_fullname_hash;

-- Garante estatísticas frescas antes de qualquer medição
VACUUM ANALYZE drivers;


-- -----------------------------------------------------------------------------
-- 1. QUERY BASE
-- Verificar que a consulta retorna resultado esperado antes de medir
-- -----------------------------------------------------------------------------
SELECT
    given_name || ' ' || family_name AS name,
    nationality_deprecated           AS nationality
FROM drivers
WHERE given_name || ' ' || family_name = 'Lewis Hamilton';


-- -----------------------------------------------------------------------------
-- 2. PLANO SEM ÍNDICE  →  esperado: Seq Scan on drivers
-- -----------------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT
    given_name || ' ' || family_name AS name,
    nationality_deprecated           AS nationality
FROM drivers
WHERE given_name || ' ' || family_name = 'Lewis Hamilton';


-- -----------------------------------------------------------------------------
-- 3. BENCHMARK SEM ÍNDICE
-- -----------------------------------------------------------------------------
WITH tempos AS (
    SELECT * FROM mede_tempo($$
        SELECT
            given_name || ' ' || family_name AS name,
            nationality_deprecated           AS nationality
        FROM drivers
        WHERE given_name || ' ' || family_name = 'Lewis Hamilton'
    $$)
)
SELECT
    COUNT(*)                                                                             AS runs,
    ROUND(AVG(duration_ms),                                                           3) AS avg_ms,
    ROUND(MIN(duration_ms),                                                           3) AS min_ms,
    ROUND(MAX(duration_ms),                                                           3) AS max_ms,
    ROUND(CAST(percentile_cont(0.50) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p50_ms,
    ROUND(CAST(percentile_cont(0.95) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p95_ms,
    ROUND(CAST(percentile_cont(0.99) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p99_ms
FROM tempos;


-- -----------------------------------------------------------------------------
-- 4. CRIAR ÍNDICE HASH na expressão computada
-- -----------------------------------------------------------------------------
CREATE INDEX idx_drivers_fullname_hash
    ON drivers USING HASH ((given_name || ' ' || family_name));

-- Atualiza estatísticas para o planner reconhecer o novo índice
ANALYZE drivers;


-- -----------------------------------------------------------------------------
-- 5. PLANO COM ÍNDICE  →  esperado: Index Scan using idx_drivers_fullname_hash
-- -----------------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT
    given_name || ' ' || family_name AS name,
    nationality_deprecated           AS nationality
FROM drivers
WHERE given_name || ' ' || family_name = 'Lewis Hamilton';


-- -----------------------------------------------------------------------------
-- 6. BENCHMARK COM ÍNDICE
-- -----------------------------------------------------------------------------
WITH tempos AS (
    SELECT * FROM mede_tempo($$
        SELECT
            given_name || ' ' || family_name AS name,
            nationality_deprecated           AS nationality
        FROM drivers
        WHERE given_name || ' ' || family_name = 'Lewis Hamilton'
    $$)
)
SELECT
    COUNT(*)                                                                             AS runs,
    ROUND(AVG(duration_ms),                                                           3) AS avg_ms,
    ROUND(MIN(duration_ms),                                                           3) AS min_ms,
    ROUND(MAX(duration_ms),                                                           3) AS max_ms,
    ROUND(CAST(percentile_cont(0.50) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p50_ms,
    ROUND(CAST(percentile_cont(0.95) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p95_ms,
    ROUND(CAST(percentile_cont(0.99) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p99_ms
FROM tempos;
