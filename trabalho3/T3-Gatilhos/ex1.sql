-- ---- Passo 1: Criação da tabela de auditoria ---------------
DROP TABLE IF EXISTS Airports_Audit;

CREATE TABLE Airports_Audit (
    audit_id    SERIAL PRIMARY KEY,
    airport_id  INTEGER,
    ident       VARCHAR(100),
    name        TEXT,
    city_id     INTEGER,
    operacao    CHAR(1)   NOT NULL,
    data_hora   TIMESTAMP NOT NULL,
    usuario_bd  TEXT      NOT NULL
);

-- ---- Passo 2: Função de trigger ----------------------------
CREATE OR REPLACE FUNCTION AuditaAeroporto()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO Airports_Audit
            (airport_id, ident, name, city_id, operacao, data_hora, usuario_bd)
        VALUES
            (NEW.id, NEW.ident, NEW.name, NEW.city_id,
             'I', NOW(), CURRENT_USER);

    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO Airports_Audit
            (airport_id, ident, name, city_id, operacao, data_hora, usuario_bd)
        VALUES
            (OLD.id, OLD.ident, OLD.name, OLD.city_id,
             'D', NOW(), CURRENT_USER);

    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO Airports_Audit
            (airport_id, ident, name, city_id, operacao, data_hora, usuario_bd)
        VALUES
            (NEW.id, NEW.ident, NEW.name, NEW.city_id,
             'U', NOW(), CURRENT_USER);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- ---- Passo 3: Criação do trigger ---------------------------
DROP TRIGGER IF EXISTS TR_AirportsAudit ON airports;

CREATE TRIGGER TR_AirportsAudit
    AFTER INSERT OR UPDATE OR DELETE
    ON airports
    FOR EACH ROW
    EXECUTE FUNCTION AuditaAeroporto();

-- ============================================================
-- TESTES – Aeroporto de Juazeiro do Norte (id=78748)
-- ============================================================

-- ---- Preparação: remove Juazeiro para poder testar INSERT (pois o aeroporto existe) --
DELETE FROM airports WHERE id = 78748;
DELETE FROM Airports_Audit; -- limpa o registro gerado pela remoção preparatória

-- -------------------------------------------------------
-- Teste 1 – INSERT -> operação 'I'
-- -------------------------------------------------------
INSERT INTO airports
    (id, ident, airport_type_id, name,
     latitude_deg, longitude_deg, elevation_ft,
     city_id, scheduled_service,
     icao_code, iata_code, gps_code, local_code,
     home_link, wikipedia_link, keywords)
VALUES
    (78748, 'SBJU', 6, 'Orlando Bezerra de Menezes Airport',
     -7.21932, -39.269096, 1342,
     3397147, 'yes',
     'SBJU', 'JDO', 'SBJU', 'CE0002',
     NULL, 'https://en.wikipedia.org/wiki/Juazeiro_do_Norte_Airport',
     'Juazeiro do Norte Airport');

-- -------------------------------------------------------
-- Teste 2 – UPDATE -> operação 'U'
-- -------------------------------------------------------
UPDATE airports
SET name = 'Aeroporto Orlando Bezerra de Menezes'
WHERE id = 78748;

-- -------------------------------------------------------
-- Teste 3 – DELETE -> operação 'D'
-- -------------------------------------------------------
DELETE FROM airports WHERE id = 78748;

-- ---- Restauração: devolve o aeroporto à base --------------
INSERT INTO airports
    (id, ident, airport_type_id, name,
     latitude_deg, longitude_deg, elevation_ft,
     city_id, scheduled_service,
     icao_code, iata_code, gps_code, local_code,
     home_link, wikipedia_link, keywords)
VALUES
    (78748, 'SBJU', 6, 'Orlando Bezerra de Menezes Airport',
     -7.21932, -39.269096, 1342,
     3397147, 'yes',
     'SBJU', 'JDO', 'SBJU', 'CE0002',
     NULL, 'https://en.wikipedia.org/wiki/Juazeiro_do_Norte_Airport',
     'Juazeiro do Norte Airport');

-- -------------------------------------------------------
-- VERIFICAÇÃO DOS TESTES
-- -------------------------------------------------------
SELECT * FROM Airports_Audit ORDER BY audit_id;


