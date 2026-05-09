-- =====================================================================================
-- FUNÇÃO: Numero_vitorias
-- OBJETIVO:
-- Retornar a quantidade de vitórias (position_order = 1) de um piloto.
--
-- PARÂMETROS:
-- 1. given_name  -> primeiro nome do piloto
-- 2. family_name -> sobrenome do piloto
-- 3. p_year      -> ano da temporada (opcional)
--
-- REGRA:
-- - Se o ano for informado: conta apenas naquele ano
-- - Se o ano NÃO for informado: conta em toda a base
-- =====================================================================================

-- -----------------------------------------------------------------------------
-- VERSÃO COM ANO
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Numero_vitorias(
    p_given_name VARCHAR,
    p_family_name VARCHAR,
    p_year INTEGER
)
RETURNS INTEGER AS
$$
DECLARE
    total_vitorias INTEGER;
BEGIN

    SELECT COUNT(*)
    INTO total_vitorias
    FROM results r
    JOIN drivers d
        ON d.id = r.driver_id
    JOIN races ra
        ON ra.id = r.race_id
    JOIN seasons s
        ON s.id = ra.season_id
    WHERE d.given_name = p_given_name
      AND d.family_name = p_family_name
      AND r.position_order = 1
      AND s.year = p_year;

    RETURN total_vitorias;

END;
$$ LANGUAGE plpgsql;


-- -----------------------------------------------------------------------------
-- VERSÃO SEM ANO (usa toda a base)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Numero_vitorias(
    p_given_name VARCHAR,
    p_family_name VARCHAR
)
RETURNS INTEGER AS
$$
DECLARE
    total_vitorias INTEGER;
BEGIN

    SELECT COUNT(*)
    INTO total_vitorias
    FROM results r
    JOIN drivers d
        ON d.id = r.driver_id
    WHERE d.given_name = p_given_name
      AND d.family_name = p_family_name
      AND r.position_order = 1;

    RETURN total_vitorias;



END;
$$ LANGUAGE plpgsql;
\echo 'Testando a função Numero_vitorias com corredor que existe:'
\echo 'Número de vitórias de Lewis Hamilton: '
SELECT Numero_vitorias('Lewis', 'Hamilton');
\echo 'Número de vitórias de Lewis Hamilton em 2020:'
SELECT Numero_vitorias('Lewis', 'Hamilton', 2020);


\echo 'Testando a função Numero_vitorias com corredor que NÃO existe:'
\echo 'Número de vitórias de John Doe: '
SELECT Numero_vitorias('John', 'Doe');
\echo 'Número de vitórias de John Doe em 2020:'
SELECT Numero_vitorias('John', 'Doe', 2020);