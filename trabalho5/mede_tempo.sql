-- =============================================================================
-- Função: mede_tempo
--
-- Executa uma query Q exatamente n_runs vezes, medindo individualmente o tempo
-- de cada execução. Retorna uma linha por execução com o número da rodada e a
-- duração em milissegundos, permitindo cálculo de média, percentis e análise
-- de variância externamente.
--
-- Correções em relação à versão original:
--   - TIni/TFim: TIME -> TIMESTAMPTZ (evita truncamento de data e erro em
--     testes que cruzem meia-noite; EXTRACT(EPOCH FROM timestamptz) é preciso)
--   - Loop: 0..100 (101 iterações) -> 1..n_runs (exatamente n_runs iterações)
--   - Matemática: /10 (errado) -> * 1000.0 (converte segundos -> ms, com decimais)
--   - Tipo de retorno: fixo em (Name, Nationality) -> (run, duration_ms) genérico,
--     desacoplado do resultado da query; a query é executada separadamente
--   - n_runs parametrizado com default 100
-- =============================================================================

CREATE OR REPLACE FUNCTION mede_tempo(
    q      TEXT,
    n_runs INTEGER DEFAULT 100
)
RETURNS TABLE (run INTEGER, duration_ms NUMERIC) AS $$
DECLARE
    t_ini TIMESTAMPTZ;
    t_fim TIMESTAMPTZ;
    i     INTEGER;
BEGIN
    FOR i IN 1..n_runs LOOP
        t_ini := CLOCK_TIMESTAMP();
        EXECUTE q;
        t_fim := CLOCK_TIMESTAMP();

        run         := i;
        duration_ms := ROUND(
            EXTRACT(EPOCH FROM (t_fim - t_ini)) * 1000.0,
            3  -- precisão de microssegundos (3 casas = microseg arredondados)
        );
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- =============================================================================
-- Template de uso: resumo estatístico
--
-- Substitua '...' pela query do exercício. Use $$ para delimitar a string e
-- evitar problemas com aspas simples dentro da query.
--
-- Exemplo de invocação:
-- =============================================================================

/*
WITH tempos AS (
    SELECT * FROM mede_tempo($$
        SELECT given_name || ' ' || family_name AS name, nationality
        FROM drivers
        WHERE given_name || ' ' || family_name = 'Lewis Hamilton'
    $$)
)
SELECT
    COUNT(*)                                                                        AS runs,
    ROUND(AVG(duration_ms),                                                      3) AS avg_ms,
    ROUND(MIN(duration_ms),                                                      3) AS min_ms,
    ROUND(MAX(duration_ms),                                                      3) AS max_ms,
    ROUND(CAST(percentile_cont(0.50) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p50_ms,
    ROUND(CAST(percentile_cont(0.95) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p95_ms,
    ROUND(CAST(percentile_cont(0.99) WITHIN GROUP (ORDER BY duration_ms) AS NUMERIC), 3) AS p99_ms
FROM tempos;
*/
