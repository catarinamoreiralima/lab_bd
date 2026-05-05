-- Função Cidade_Chamada
CREATE OR REPLACE FUNCTION Cidade_Chamada(cidade_nome TEXT)
RETURNS VOID AS $$
DECLARE
    v_cidade RECORD;
	v_cidades_count INTEGER := 1;
BEGIN
	SELECT COUNT(*) INTO v_cidades_count
    FROM cities c
    WHERE c."name" = cidade_nome;

	RAISE NOTICE 'Contagem: %', v_cidades_count;

    IF v_cidades_count > 0 THEN
        FOR v_cidade IN 
            SELECT c."name", c.population, co."name" AS country_name
            FROM cities c
            JOIN countries co ON c.country_id = co.id
            WHERE c."name" = cidade_nome
        LOOP
            RAISE NOTICE 'Nome: %, População: %, País: %', v_cidade."name", v_cidade.population, v_cidade.country_name;
        END LOOP;
    ELSE
        RAISE NOTICE 'Nenhuma cidade encontrada com o nome: %', cidade_nome;
    END IF;
END;
$$ LANGUAGE PLPgSQL;

-- Teste com cidades que existem
SELECT Cidade_Chamada('York');
SELECT Cidade_Chamada('São Carlos');

-- Teste com uma cidade que não existe
SELECT Cidade_Chamada('USP');