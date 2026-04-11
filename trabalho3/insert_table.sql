BEGIN;

-- TABELAS DE STAGING (temporárias, descartadas ao fim da sessão)

CREATE TEMP TABLE stg_countries (
    id             TEXT,
    code           TEXT,
    name           TEXT,
    continent      TEXT,
    wikipedia_link TEXT,
    keywords       TEXT
);

CREATE TEMP TABLE stg_timezones (
    country_code  TEXT,
    timezone_name TEXT,
    gmt_offset    TEXT,
    dst_offset    TEXT,
    raw_offset    TEXT
);

CREATE TEMP TABLE stg_featurecodes (
    code_full          TEXT,   -- formato "CLASS.CODE", ex: "P.PPL"
    featurename        TEXT,
    featuredescription TEXT
);

CREATE TEMP TABLE stg_cities (
    geoname_id            TEXT,   -- usado apenas como dado da cidade, não como FK
    city_name             TEXT,
    city_ascii_name       TEXT,
    city_alternate_names  TEXT,
    latitude              TEXT,
    longitude             TEXT,
    feature_class         TEXT,
    feature_code          TEXT,
    country_code          TEXT,
    cc2                   TEXT,
    admin1_code           TEXT,
    admin2_code           TEXT,
    admin3_code           TEXT,
    admin4_code           TEXT,
    population            TEXT,
    elevation             TEXT,
    dem                   TEXT,
    timezone_name         TEXT,
    modification_date     TEXT
);

CREATE TEMP TABLE stg_languagecodes (
    iso_639_3     TEXT,
    iso_639_2     TEXT,
    iso_639_1     TEXT,
    language_name TEXT
);

CREATE TEMP TABLE stg_constructors (
    constructor_ref  TEXT,
    constructor_name TEXT,
    nationality      TEXT,
    wikipedia_url    TEXT
);

CREATE TEMP TABLE stg_drivers (
    driver_ref    TEXT,
    given_name    TEXT,
    family_name   TEXT,
    nationality   TEXT,
    date_of_birth TEXT
);

CREATE TEMP TABLE stg_circuits (
    circuit_ref   TEXT,
    circuit_name  TEXT,
    lat           TEXT,
    lng           TEXT,
    locality      TEXT,   -- nome da cidade do circuito
    country       TEXT,   -- nome do país do circuito
    wikipedia_url TEXT
);

CREATE TEMP TABLE stg_races (
    race_ref    TEXT,
    season_year TEXT,
    round       TEXT,
    race_name   TEXT,
    race_date   TEXT,
    race_time   TEXT,
    circuit_ref TEXT
);

CREATE TEMP TABLE stg_results (
    race_ref        TEXT,
    driver_ref      TEXT,
    constructor_ref TEXT,
    grid            TEXT,
    position        TEXT,
    position_order  TEXT,
    points          TEXT,
    laps            TEXT,
    status_text     TEXT
);

CREATE TEMP TABLE stg_qualifying (
    race_ref        TEXT,
    driver_ref      TEXT,
    constructor_ref TEXT,
    position        TEXT,
    q1              TEXT,
    q2              TEXT,
    q3              TEXT
);

CREATE TEMP TABLE stg_driver_standings (
    season_year TEXT,
    round       TEXT,
    driver_ref  TEXT,
    position    TEXT,
    points      TEXT,
    wins        TEXT
);

CREATE TEMP TABLE stg_constructor_standings (
    season_year     TEXT,
    round           TEXT,
    constructor_ref TEXT,
    position        TEXT,
    points          TEXT,
    wins            TEXT
);

CREATE TEMP TABLE stg_airports (
    id                TEXT,
    ident             TEXT,
    type              TEXT,
    name              TEXT,
    latitude_deg      TEXT,
    longitude_deg     TEXT,
    elevation_ft      TEXT,
    continent         TEXT,
    iso_country       TEXT,
    iso_region        TEXT,
    municipality      TEXT,   -- nome da cidade do aeroporto
    scheduled_service TEXT,
    icao_code         TEXT,
    iata_code         TEXT,
    gps_code          TEXT,
    local_code        TEXT,
    home_link         TEXT,
    wikipedia_link    TEXT,
    keywords          TEXT
);


-- 
-- COPY: leitura dos arquivos nas tabelas de staging

COPY stg_countries (id, code, name, continent, wikipedia_link, keywords)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/countries.csv'
WITH (FORMAT csv, HEADER true, QUOTE '"', DELIMITER ',', NULL '');

-- timeZones.tsv: separado por tab, tem header
COPY stg_timezones (country_code, timezone_name, gmt_offset, dst_offset, raw_offset)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/timeZones.tsv'
WITH (FORMAT csv, HEADER true, DELIMITER E'\t', NULL '');

-- featureCodes_en.tsv: separado por tab, SEM header
COPY stg_featurecodes (code_full, featurename, featuredescription)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/featureCodes_en.tsv'
WITH (FORMAT csv, HEADER false, DELIMITER E'\t', NULL '');

-- cities.tsv: separado por tab, SEM header (formato padrão Geonames)
COPY stg_cities (
    geoname_id, city_name, city_ascii_name, city_alternate_names,
    latitude, longitude, feature_class, feature_code,
    country_code, cc2, admin1_code, admin2_code, admin3_code, admin4_code,
    population, elevation, dem, timezone_name, modification_date
)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/cities.tsv'
WITH (FORMAT csv, HEADER false, DELIMITER E'\t', NULL '');

-- iso-languagecodes.tsv: separado por tab, tem header
COPY stg_languagecodes (iso_639_3, iso_639_2, iso_639_1, language_name)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/iso-languagecodes.tsv'
WITH (FORMAT csv, HEADER true, DELIMITER E'\t', NULL '');

COPY stg_constructors (constructor_ref, constructor_name, nationality, wikipedia_url)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/constructors.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_drivers (driver_ref, given_name, family_name, nationality, date_of_birth)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/drivers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_circuits (circuit_ref, circuit_name, lat, lng, locality, country, wikipedia_url)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/circuits.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_races (race_ref, season_year, round, race_name, race_date, race_time, circuit_ref)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/races.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_results (race_ref, driver_ref, constructor_ref, grid, position, position_order, points, laps, status_text)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/results.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_qualifying (race_ref, driver_ref, constructor_ref, position, q1, q2, q3)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/qualifying.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_driver_standings (season_year, round, driver_ref, position, points, wins)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/driver_standings.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_constructor_standings (season_year, round, constructor_ref, position, points, wins)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/constructor_standings.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

COPY stg_airports (
    id, ident, type, name, latitude_deg, longitude_deg, elevation_ft,
    continent, iso_country, iso_region, municipality, scheduled_service,
    icao_code, iata_code, gps_code, local_code, home_link, wikipedia_link, keywords
)
FROM '/Users/catarinamoreiralima/Documents/Faculdade/lab_bd/trabalho3/airports.csv'
WITH (FORMAT csv, HEADER true, QUOTE '"', DELIMITER ',', NULL '');


-- INSERT nas tabelas finais
-- (ordem respeita as dependências de chaves estrangeiras)

-- 1. CONTINENTS
-- Não existe CSV de continentes; os códigos são derivados de countries.csv.
INSERT INTO CONTINENTS (continent_code, continent_name)
SELECT DISTINCT
    continent,
    CASE continent
        WHEN 'AF' THEN 'Africa'
        WHEN 'AN' THEN 'Antarctica'
        WHEN 'AS' THEN 'Asia'
        WHEN 'EU' THEN 'Europe'
        WHEN 'NA' THEN 'North America'
        WHEN 'OC' THEN 'Oceania'
        WHEN 'SA' THEN 'South America'
    END
FROM stg_countries
WHERE continent IN ('AF','AN','AS','EU','NA','OC','SA')
ON CONFLICT DO NOTHING;

-- 2. COUNTRIES
INSERT INTO COUNTRIES (code, country_name, continent_id, wikipedia_link, keywords)
SELECT
    s.code,
    s.name,
    c.continent_id,
    NULLIF(s.wikipedia_link, ''),
    NULLIF(s.keywords, '')
FROM stg_countries s
JOIN CONTINENTS c ON c.continent_code = s.continent
WHERE s.code <> ''
ON CONFLICT DO NOTHING;

-- 3. TIMEZONES
INSERT INTO TIMEZONES (timezone_name, gmt_offset, dst_offset, raw_offset)
SELECT
    timezone_name,
    CAST(gmt_offset AS FLOAT),
    CAST(dst_offset AS FLOAT),
    CAST(raw_offset AS FLOAT)
FROM stg_timezones
WHERE timezone_name <> ''
ON CONFLICT DO NOTHING;

-- 4. FEATURECODES
-- Primeira coluna tem formato "CLASS.CODE"; linhas sem ponto são ignoradas.
INSERT INTO FEATURECODES (featureclass, featurecode, featurename, featuredescription)
SELECT
    split_part(code_full, '.', 1),
    split_part(code_full, '.', 2),
    featurename,
    NULLIF(featuredescription, '')
FROM stg_featurecodes
WHERE code_full LIKE '%.%'
  AND split_part(code_full, '.', 2) <> ''
ON CONFLICT DO NOTHING;

INSERT INTO CITIES (
    city_name, city_ascii_name, city_alternate_names,
    latitude, longitude,
    featurecode_id, country_id, timezone_id,
    cc2, admin1_code, admin2_code, admin3_code, admin4_code,
    city_population, city_levation, city_dem, modification_date
)
SELECT
    s.city_name,
    s.city_ascii_name,
    LEFT(s.city_alternate_names, 255),
    CAST(s.latitude  AS FLOAT),
    CAST(s.longitude AS FLOAT),
    fc.featurecode_id,
    co.country_id,
    tz.timezone_id,
    NULLIF(s.cc2,         ''),
    NULLIF(s.admin1_code, ''),
    NULLIF(s.admin2_code, ''),
    NULLIF(s.admin3_code, ''),
    NULLIF(s.admin4_code, ''),
    CAST(NULLIF(s.population, '') AS INT),
    CAST(NULLIF(s.elevation,  '') AS INT),
    CAST(NULLIF(s.dem,        '') AS INT),
    CAST(s.modification_date AS DATE)
FROM stg_cities s
LEFT JOIN FEATURECODES fc ON fc.featurecode  = s.feature_code
                          AND fc.featureclass = s.feature_class
LEFT JOIN COUNTRIES    co ON co.code          = s.country_code
LEFT JOIN TIMEZONES    tz ON tz.timezone_name = s.timezone_name;

-- 6. LANGUAGENAMES
INSERT INTO LANGUAGENAMES (language_name)
SELECT DISTINCT language_name
FROM stg_languagecodes
ON CONFLICT DO NOTHING;

-- 7. ISOLANGUAGECODES
INSERT INTO ISOLANGUAGECODES (iso_639_3, iso_639_2, iso_639_1, language_id)
SELECT
    s.iso_639_3,
    s.iso_639_2,
    s.iso_639_1,
    ln.language_id
FROM stg_languagecodes s
JOIN LANGUAGENAMES ln ON ln.language_name = s.language_name
ON CONFLICT DO NOTHING;

-- 8. CONSTRUCTORS
INSERT INTO CONSTRUCTORS (constructor_ref, constructor_name, nationality, contructor_url)
SELECT
    constructor_ref,
    constructor_name,
    nationality,
    NULLIF(wikipedia_url, '')
FROM stg_constructors
WHERE constructor_ref <> ''
ON CONFLICT DO NOTHING;

-- 9. DRIVERS
INSERT INTO DRIVERS (driver_ref, given_name, family_name, date_of_birth, nationality)
SELECT
    driver_ref,
    given_name,
    family_name,
    CAST(date_of_birth AS DATE),
    nationality
FROM stg_drivers
ON CONFLICT DO NOTHING;