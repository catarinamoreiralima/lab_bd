-- =============================================================================
-- Exercício 2 — Índice sobre nome de cidades brasileiras com padrão LIKE
--
-- Consulta: dado um prefixo de nome, recuperar latitude, longitude e população
-- das cidades brasileiras que atendam ao padrão (LIKE 'prefixo%').
-- O filtro por Brasil é feito via country_id = 30 (id do Brasil em countries).
--
-- Índice escolhido: B-tree com text_pattern_ops
-- Justificativa: LIKE 'prefixo%' é um predicado de prefixo — B-tree consegue
-- navegar pela ordenação lexicográfica para encontrar o intervalo. Hash só
-- suporta igualdade exata e é completamente inaplicável para LIKE.
-- text_pattern_ops é necessário porque a collation padrão (locale) não garante
-- que a ordem do B-tree coincida com a ordem byte-a-byte usada pelo LIKE.
--
-- Cláusula WHERE (índice parcial): WHERE country_id = 30
--   Reduz o índice a apenas cidades do Brasil (~4414 de ~1M+ linhas totais),
--   diminuindo tamanho em disco e custo de manutenção.
--
-- Cláusula INCLUDE: (latitude, longitude, population)
--   A query retorna exatamente essas três colunas. Com INCLUDE, elas ficam
--   nas páginas folha do índice → Index-Only Scan: zero acessos à heap.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 0. ESTADO LIMPO
-- -----------------------------------------------------------------------------
DROP INDEX IF EXISTS idx_cities_brazil_name;

VACUUM ANALYZE cities;


-- -----------------------------------------------------------------------------
-- 1. QUERY BASE
-- Padrão de teste: 'Santa%' → ~144 cidades brasileiras
-- -----------------------------------------------------------------------------
SELECT name, latitude, longitude, population
FROM cities
WHERE country_id = 30
  AND name LIKE 'Santa%';


-- -----------------------------------------------------------------------------
-- 2. PLANO SEM ÍNDICE  →  esperado: Seq Scan on cities
-- -----------------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT name, latitude, longitude, population
FROM cities
WHERE country_id = 30
  AND name LIKE 'Santa%';


-- -----------------------------------------------------------------------------
-- 3. BENCHMARK SEM ÍNDICE
-- -----------------------------------------------------------------------------
WITH tempos AS (
    SELECT * FROM mede_tempo($$
        SELECT name, latitude, longitude, population
        FROM cities
        WHERE country_id = 30
          AND name LIKE 'Santa%'
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
-- 4. CRIAR ÍNDICE B-tree
--
-- text_pattern_ops: operador de classe que habilita LIKE 'prefix%' no B-tree
-- WHERE country_id = 30: índice parcial — apenas cidades do Brasil
-- INCLUDE: colunas cobertas para Index-Only Scan
-- -----------------------------------------------------------------------------
CREATE INDEX idx_cities_brazil_name
    ON cities (name text_pattern_ops)
    INCLUDE (latitude, longitude, population)
    WHERE country_id = 30;

ANALYZE cities;


-- -----------------------------------------------------------------------------
-- 5. PLANO COM ÍNDICE
-- Esperado: Index Only Scan using idx_cities_brazil_name
--           Heap Fetches: 0  (confirma que INCLUDE funcionou)
-- -----------------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT name, latitude, longitude, population
FROM cities
WHERE country_id = 30
  AND name LIKE 'Santa%';


-- -----------------------------------------------------------------------------
-- 6. BENCHMARK COM ÍNDICE
-- -----------------------------------------------------------------------------
WITH tempos AS (
    SELECT * FROM mede_tempo($$
        SELECT name, latitude, longitude, population
        FROM cities
        WHERE country_id = 30
          AND name LIKE 'Santa%'
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
