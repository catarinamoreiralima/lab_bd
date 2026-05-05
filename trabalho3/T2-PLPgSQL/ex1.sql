-- Função Nome_Nacionalidade
-- Função Nome_Nacionalidade
CREATE OR REPLACE FUNCTION Nome_Nacionalidade(nome_escuderia TEXT)
RETURNS TEXT AS $$
DECLARE
    v_nacionalidade TEXT;
BEGIN
    SELECT co.nationality INTO v_nacionalidade
    FROM constructors c
    JOIN countries co ON c.country_id = co.id
    WHERE c.name = nome_escuderia;

	IF NOT FOUND THEN
        RAISE NOTICE 'Escuderia "%" não encontrada.', nome_escuderia;
        RETURN NULL;
    END IF;
    
    RETURN v_nacionalidade;
END;
$$ LANGUAGE PLPgSQL;

-- Testando com uma escuderia que existe
SELECT Nome_Nacionalidade('Ferrari');

-- Testando com uma escuderia que NÃO existe
SELECT Nome_Nacionalidade('USP');

--  Listando a nacionalidade da escuderia de 5 pilotos quaisquer
SELECT * FROM (
    SELECT DISTINCT
        d.family_name AS piloto, 
        Nome_Nacionalidade(c.name) AS nacionalidade_escuderia
    FROM results r
    JOIN drivers d ON d.id = r.driver_id
    JOIN constructors c ON c.id = r.constructor_id
) AS pilotos_unicos
ORDER BY RANDOM()
LIMIT 5;