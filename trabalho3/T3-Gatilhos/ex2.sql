-- =====================================================================================
-- FUNÇÃO: VerificaQualifying
-- OBJETIVO:
-- Garantir que não existam posições inválidas ou repetidas
-- na tabela QUALIFYING.
-- =====================================================================================

CREATE OR REPLACE FUNCTION VerificaQualifying()
RETURNS TRIGGER AS
$$
BEGIN

    -- Regra (a): posição deve ser maior que zero
    IF NEW.position <= 0 THEN
        RAISE EXCEPTION
        'Posição inválida! Operação cancelada.';
    END IF;

    -- Regra (b): não pode repetir posição na mesma corrida
    IF EXISTS (
        SELECT 1
        FROM qualifying q
        WHERE q.race_id = NEW.race_id
          AND q.position = NEW.position
          AND q.id <> NEW.id
    ) THEN
        RAISE EXCEPTION
        'Posição já cadastrada para essa corrida! Operação cancelada.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================================================
-- TRIGGER: TR_Qualifying
-- =====================================================================================

CREATE OR REPLACE TRIGGER TR_Qualifying
BEFORE INSERT OR UPDATE OF position
ON qualifying
FOR EACH ROW
EXECUTE FUNCTION VerificaQualifying();


-- =====================================================================================
-- TESTE 1: Inserção com posição inválida
-- =====================================================================================

\echo '========================================================='
\echo 'TESTE 1 - Inserção com posição inválida'
\echo 'Resultado esperado:'
\echo 'Posição inválida! Operação cancelada.'
\echo '========================================================='

BEGIN;

INSERT INTO qualifying (
    race_id,
    driver_id,
    constructor_id,
    position,
    q1,
    q2,
    q3
)
VALUES (
    1,
    1,
    1,
    0,
    '1:20.000',
    '1:19.500',
    '1:19.000'
);

ROLLBACK;


-- =====================================================================================
-- TESTE 2: Inserção válida
-- =====================================================================================

\echo '========================================================='
\echo 'TESTE 2 - Inserção válida'
\echo 'Resultado esperado:'
\echo 'INSERT 0 1'
\echo '========================================================='

BEGIN;

INSERT INTO qualifying (
    race_id,
    driver_id,
    constructor_id,
    position,
    q1,
    q2,
    q3
)
VALUES (
    1,
    1,
    1,
    99,
    '1:20.000',
    '1:19.500',
    '1:19.000'
);

ROLLBACK;


-- =====================================================================================
-- TESTE 3: Inserção com posição repetida
-- =====================================================================================

\echo '========================================================='
\echo 'TESTE 3 - Inserção com posição repetida'
\echo 'Resultado esperado:'
\echo 'Posição já cadastrada para essa corrida! Operação cancelada.'
\echo '========================================================='

BEGIN;

-- Inserção inicial válida
INSERT INTO qualifying (
    race_id,
    driver_id,
    constructor_id,
    position,
    q1,
    q2,
    q3
)
VALUES (
    1,
    1,
    1,
    50,
    '1:20.000',
    '1:19.500',
    '1:19.000'
);

-- Tentativa de posição repetida
INSERT INTO qualifying (
    race_id,
    driver_id,
    constructor_id,
    position,
    q1,
    q2,
    q3
)
VALUES (
    1,
    2,
    1,
    50,
    '1:21.000',
    '1:20.500',
    '1:20.000'
);

ROLLBACK;


-- =====================================================================================
-- TESTE 4: Atualização inválida
-- =====================================================================================

\echo '========================================================='
\echo 'TESTE 4 - Atualização inválida'
\echo 'Resultado esperado:'
\echo 'Posição inválida! Operação cancelada.'
\echo '========================================================='

BEGIN;

-- Inserção válida
INSERT INTO qualifying (
    race_id,
    driver_id,
    constructor_id,
    position,
    q1,
    q2,
    q3
)
VALUES (
    1,
    1,
    1,
    60,
    '1:22.000',
    '1:21.500',
    '1:21.000'
);

-- Atualização inválida
UPDATE qualifying
SET position = -3
WHERE race_id = 1
  AND driver_id = 1;

ROLLBACK;