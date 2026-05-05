-- Função Pilotos_Nacionalidade
CREATE OR REPLACE FUNCTION Pilotos_Nacionalidade(piloto_nacionalidade TEXT)
RETURNS VOID AS $$
DECLARE
    v_piloto RECORD;
	v_contador INTEGER := 1;
BEGIN
    FOR v_piloto IN 
        SELECT given_name, family_name 
        FROM drivers d
		JOIN countries co ON d.country_id = co.id
        WHERE co.nationality = piloto_nacionalidade
    LOOP
		RAISE NOTICE '% Nome: % %', v_contador, v_piloto.given_name, v_piloto.family_name;
		v_contador := v_contador + 1;
	END LOOP;

	IF v_contador = 1 THEN
        RAISE NOTICE 'Nenhum piloto encontrado para a nacionalidade: %', piloto_nacionalidade;
    END IF;
END;
$$ LANGUAGE PLPgSQL;

-- Testando com algumas nacionalidades
SELECT Pilotos_Nacionalidade('Brazilian');

SELECT Pilotos_Nacionalidade('Chilean');

SELECT Pilotos_Nacionalidade('Egyptian');

-- Testando nacionalidade que não existe
SELECT Pilotos_Nacionalidade('USPian');