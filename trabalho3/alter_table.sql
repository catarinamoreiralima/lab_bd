-- INÍCIO DE MUDANÇA DE COUNTRIES

-- ANTES DE TUDO, CRIANDO O MAPEAMENTO DE PAÍS-NACIONALIDAE PARA USAR NAS PRÓXIMAS QUERIES (TABELA TEMPORÁRIA)
-- (APENAS FOI INSERIDA AS NACIONALDADES QUE JÁ EXISTIAM NO BANCO)

CREATE TEMP TABLE nat_mapping(nat TEXT, country_name TEXT) AS 
    VALUES 
  	('American', 'United States'),
  	('Argentine', 'Argentina'),
  	('Australian', 'Australia'),
  	('Austrian', 'Austria'),
    ('Belgian', 'Belgium'),
    ('Brazilian', 'Brazil'),
    ('British', 'United Kingdom'),
    ('Canadian', 'Canada'),
    ('Chilean', 'Chile'),
    ('Chinese', 'China'),
    ('Colombian', 'Colombia'),
    ('Danish', 'Denmark'),
    ('Dutch', 'Netherlands'),
    ('Finnish', 'Finland'),
    ('French', 'France'),
    ('German', 'Germany'),
    ('Hong Kong', 'Hong Kong'),
    ('Hungarian', 'Hungary'),
    ('Indian', 'India'),
    ('Indonesian', 'Indonesia'),
    ('Irish', 'Ireland'),
    ('Italian', 'Italy'),
    ('Japanese', 'Japan'),
    ('Liechtensteiner', 'Liechtenstein'),
    ('Malaysian', 'Malaysia'),
    ('Mexican', 'Mexico'),
    ('Monegasque', 'Monaco'),
    ('New Zealander', 'New Zealand'),
    ('Polish', 'Poland'),
    ('Portuguese', 'Portugal'),
    ('Russian', 'Russia'),
    ('South African', 'South Africa'),
    ('Spanish', 'Spain'),
    ('Swedish', 'Sweden'),
    ('Swiss', 'Switzerland'),
    ('Thai', 'Thailand'),
    ('Uruguayan', 'Uruguay'),
    ('Venezuelan', 'Venezuela')

-- CRIANDO A COLUNA NACIONALIDADE AOS COUNTRIES

ALTER TABLE countries ADD COLUMN IF NOT EXISTS nationality VARCHAR(255);

-- INSERINDO AS NACIONALIDADES CORRETAS PARA CADA PAÍS

UPDATE countries c
SET nationality = m.nat
FROM nat_mapping m
WHERE c.name = m.country_name;

-- MUDANÇA DE DRIVERS E CONSTRUCTORS: MANTER COLUNA DE NACIONALIDADE PARA MANTER HISTÓRICO
ALTER TABLE drivers
RENAME COLUMN nationality TO nationality_deprecated;

ALTER TABLE constructors
RENAME COLUMN nationality TO nationality_deprecated;

-- CRIAR A RELAÇÃO COUNTRY_ID COM DRIVERS E CONSTRUCTORS
ALTER TABLE drivers
ADD COLUMN country_id INT REFERENCES countries(id);

ALTER TABLE constructors
ADD COLUMN country_id INT REFERENCES countries(id);

-- INSERIR DADOS PARA CONECTAR ESSA RELÇÃO COM OS DRIVERS E CONSTRUCTORS EXISTENTES
UPDATE drivers d
SET country_id = c.id
FROM nat_mapping m
JOIN countries c ON c.name = m.country_name
WHERE d.nationality_deprecated = m.nat;

UPDATE constructors con
SET country_id = c.id
FROM nat_mapping m
JOIN countries c ON c.name = m.country_name
WHERE con.nationality_deprecated = m.nat;

-- CASO ESPECÍFICO DE RHODESIAN
UPDATE drivers
SET country_id = 249
WHERE id IN (105, 401);

UPDATE constructors SET country_id = 249 WHERE id = 77;

-- APAGANDO A TABELA TEMPORÁRIA DE MAPEAMENTO
DROP TABLE nat_mapping;

-- FINAL DE MUDANÇA DE COUNTRIES