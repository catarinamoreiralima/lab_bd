-- =====================================================================================
-- TABELA: lap_times
-- Armazena os tempos de volta de cada piloto em cada corrida.
-- =====================================================================================

CREATE TABLE IF NOT EXISTS lap_times (
    lap_time_id     SERIAL PRIMARY KEY,
    race_id         INTEGER NOT NULL,
    driver_id       INTEGER NOT NULL,
    lap             INTEGER NOT NULL,
    position        INTEGER,
    time            VARCHAR(16),
    milliseconds    INTEGER,
    CONSTRAINT fk_lap_times_race
        FOREIGN KEY (race_id) REFERENCES races(race_id),
    CONSTRAINT fk_lap_times_driver
        FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    CONSTRAINT uq_lap_times_race_driver_lap
        UNIQUE (race_id, driver_id, lap)
);

-- =====================================================================================
-- FUNÇÃO: Valida_Volta
-- OBJETIVO:
--   Verificar se é possível inserir uma nova volta para um piloto em uma corrida.
--
-- PARÂMETROS:
--   p_nome_autodromo   -> nome do circuito (circuits.circuit_name)
--   p_pais_autodromo   -> nome do país do circuito (countries.country_name)
--   p_ano              -> ano da temporada (seasons.season_year)
--   p_prenome_piloto   -> primeiro nome do piloto (drivers.given_name)
--   p_sobrenome_piloto -> sobrenome do piloto (drivers.family_name)
--   p_numero_volta     -> número da volta a inserir
--
-- RETORNO: TABLE(id_piloto, id_corrida, status)
--   0 -> pode inserir (última volta existente = p_numero_volta - 1)
--   1 -> volta já existe, pode substituir
--   2 -> piloto sem voltas nessa corrida (só pode inserir volta 1)
--   3 -> piloto não encontrado
--   4 -> autódromo não encontrado no país indicado
--   5 -> corrida não encontrada nesse autódromo nesse ano
--   6 -> volta anterior não registrada
-- =====================================================================================

CREATE OR REPLACE FUNCTION Valida_Volta(
    p_nome_autodromo    TEXT,
    p_pais_autodromo    TEXT,
    p_ano               INTEGER,
    p_prenome_piloto    TEXT,
    p_sobrenome_piloto  TEXT,
    p_numero_volta      INTEGER
)
RETURNS TABLE (
    id_piloto   INTEGER,
    id_corrida  INTEGER,
    status      INTEGER
)
AS $$
DECLARE
    v_driver_id     INTEGER;
    v_circuit_id    INTEGER;
    v_race_id       INTEGER;
    v_max_lap       INTEGER;
    v_lap_exists    BOOLEAN;
BEGIN
    -- 1. Verifica existência do piloto
    SELECT driver_id INTO v_driver_id
    FROM drivers
    WHERE given_name  = p_prenome_piloto
      AND family_name = p_sobrenome_piloto;

    IF NOT FOUND THEN
        id_piloto  := NULL;
        id_corrida := NULL;
        status     := 3;
        RETURN NEXT;
        RETURN;
    END IF;

    -- 2. Verifica existência do autódromo no país indicado
    SELECT c.circuit_id INTO v_circuit_id
    FROM circuits c
    JOIN cities    ci ON ci.city_id    = c.circuit_city_id
    JOIN countries co ON co.country_id = ci.country_id
    WHERE c.circuit_name = p_nome_autodromo
      AND co.country_name = p_pais_autodromo;

    IF NOT FOUND THEN
        id_piloto  := NULL;
        id_corrida := NULL;
        status     := 4;
        RETURN NEXT;
        RETURN;
    END IF;

    -- 3. Verifica existência de corrida nesse autódromo nesse ano
    SELECT r.race_id INTO v_race_id
    FROM races   r
    JOIN seasons s ON s.season_id = r.season_id
    WHERE r.circuit_id = v_circuit_id
      AND s.season_year = p_ano;

    IF NOT FOUND THEN
        id_piloto  := NULL;
        id_corrida := NULL;
        status     := 5;
        RETURN NEXT;
        RETURN;
    END IF;

    -- 4. Verifica se o piloto tem voltas registradas nessa corrida
    SELECT MAX(lap) INTO v_max_lap
    FROM lap_times
    WHERE race_id  = v_race_id
      AND driver_id = v_driver_id;

    IF v_max_lap IS NULL THEN
        id_piloto  := v_driver_id;
        id_corrida := v_race_id;
        status     := 2;
        RETURN NEXT;
        RETURN;
    END IF;

    -- 5. Verifica se essa volta exata já existe (pode ser substituída)
    SELECT EXISTS(
        SELECT 1 FROM lap_times
        WHERE race_id   = v_race_id
          AND driver_id = v_driver_id
          AND lap       = p_numero_volta
    ) INTO v_lap_exists;

    IF v_lap_exists THEN
        id_piloto  := v_driver_id;
        id_corrida := v_race_id;
        status     := 1;
        RETURN NEXT;
        RETURN;
    END IF;

    -- 6. Verifica se a volta anterior é exatamente p_numero_volta - 1
    IF v_max_lap = p_numero_volta - 1 THEN
        id_piloto  := v_driver_id;
        id_corrida := v_race_id;
        status     := 0;
        RETURN NEXT;
        RETURN;
    END IF;

    -- 7. Volta anterior não registrada
    id_piloto  := v_driver_id;
    id_corrida := v_race_id;
    status     := 6;
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;


-- TESTES - Piloto: Nino Farina (id=1), Corrida: Silverstone 1950 (id=1)

INSERT INTO lap_times (race_id, driver_id, lap, position, time, milliseconds)
VALUES (1, 1, 1, 1, '1:30.000', 90000), (1, 1, 2, 1, '1:29.500', 89500);

-- Status 0: volta 3 pode ser inserida (max_lap=2)
SELECT * FROM Valida_Volta('Silverstone Circuit', 'United Kingdom', 1950, 'Nino', 'Farina', 3);
-- Status 1: volta 1 já existe
SELECT * FROM Valida_Volta('Silverstone Circuit', 'United Kingdom', 1950, 'Nino', 'Farina', 1);

DELETE FROM lap_times WHERE race_id = 1 AND driver_id = 1 AND lap IN (1, 2);

-- Status 2: piloto sem voltas na corrida
SELECT * FROM Valida_Volta('Silverstone Circuit', 'United Kingdom', 1950, 'Nino', 'Farina', 1);
-- Status 3: piloto inexistente
SELECT * FROM Valida_Volta('Silverstone Circuit', 'United Kingdom', 1950, 'Fulano', 'Ciclano', 1);
-- Status 4: país inválido
SELECT * FROM Valida_Volta('Silverstone Circuit', 'PaisInexistente', 1950, 'Nino', 'Farina', 1);
-- Status 5: ano sem corrida
SELECT * FROM Valida_Volta('Silverstone Circuit', 'United Kingdom', 1800, 'Nino', 'Farina', 1);

INSERT INTO lap_times (race_id, driver_id, lap, position, time, milliseconds)
VALUES (1, 1, 1, 1, '1:30.000', 90000), (1, 1, 2, 1, '1:29.500', 89500);

-- Status 6: volta anterior ausente (pede 5, max_lap=2)
SELECT * FROM Valida_Volta('Silverstone Circuit', 'United Kingdom', 1950, 'Nino', 'Farina', 5);

DELETE FROM lap_times WHERE race_id = 1 AND driver_id = 1 AND lap IN (1, 2);
