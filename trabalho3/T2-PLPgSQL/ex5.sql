-- =====================================================================================
-- FUNÇÃO: Pais_Continente
-- OBJETIVO:
-- Retornar o nome do país e o continente para países cujo nome tenha
-- no máximo 15 caracteres.
--
-- REQUISITO:
-- Uso obrigatório de CURSOR.
--
-- RETORNO:
-- TABLE(nome_pais, continente)
-- =====================================================================================

CREATE OR REPLACE FUNCTION Pais_Continente()
RETURNS TABLE (
    nome_pais VARCHAR,
    continente VARCHAR
)
AS
$$
DECLARE
    -- Variável para armazenar cada linha lida pelo cursor
    registro RECORD;

    -- Cursor obrigatório
    cur_paises CURSOR FOR
        SELECT
            c.name AS nome_pais,
            ct.name AS continente
        FROM countries c
        JOIN continents ct
            ON ct.id = c.continent_id
        WHERE LENGTH(c.name) <= 15;
BEGIN

    -- Abre o cursor
    OPEN cur_paises;

    LOOP
        -- Busca próxima linha
        FETCH cur_paises INTO registro;

        -- Sai do loop quando não houver mais linhas
        EXIT WHEN NOT FOUND;

        -- Atribui valores às colunas de retorno
        nome_pais := registro.nome_pais;
        continente := registro.continente;

        -- Retorna a linha atual
        RETURN NEXT;
    END LOOP;

    -- Fecha o cursor
    CLOSE cur_paises;
END;
$$ LANGUAGE plpgsql;


-- TESTE DA FUNÇÃO
\echo total de países retornados:
SELECT count(*) FROM Pais_Continente();
\echo 10 primeiros países retornados:
SELECT * FROM Pais_Continente() LIMIT 10;