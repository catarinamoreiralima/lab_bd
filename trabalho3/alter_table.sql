-- Ainda countries, mas agora add nacionalidades (gentílicos)
-- CASO RHODESIAN (é atualmente a região de Zimbabwe) --
-- CASO BRITISH:  England, Scotland, Wales, or Northern Ireland --
-- CASO HONG KONG (não é tecnicamente um país), nem Liechtenstein, nem Monaco

ALTER TABLE countries ADD COLUMN IF NOT EXISTS nationality VARCHAR(255);

WITH mapping(nat, country_name) AS (
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
)
UPDATE countries c
SET nationality = m.nat
FROM mapping m
WHERE c.name = m.country_name;