/* SCRIPTS PARA CRIAÇÃO DAS TABELAS */

CREATE TABLE IF NOT EXISTS CONSTRUCTORS (
    constructor_id INT GENERATED ALWAYS AS IDENTITY,
    constructor_ref VARCHAR(255) NOT NULL UNIQUE,
    constructor_name VARCHAR(255) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    constructor_url VARCHAR(255),
    PRIMARY KEY (constructor_id)
);



CREATE TABLE IF NOT EXISTS DRIVERS (
    driver_id INT GENERATED ALWAYS AS IDENTITY,
    driver_ref VARCHAR(255) UNIQUE,
    given_name VARCHAR(255) NOT NULL,
    family_name VARCHAR(255) NOT NULL,
    date_of_birth  DATE,
    nationality VARCHAR(255) NOT NULL,
    PRIMARY KEY (driver_id)
); 



CREATE TABLE IF NOT EXISTS SEASONS (
    season_id INT GENERATED ALWAYS AS IDENTITY,
    season_year INT NOT NULL UNIQUE,
    PRIMARY KEY (season_id)
);


  


/*tem tudo até points, depois tem que pegar em last_results lap speed ->n tem, e acho q tbm nao temos o tamanho do circuito */

CREATE TABLE IF NOT EXISTS RACESTATUS (
    status_id INT GENERATED ALWAYS AS IDENTITY,
    status_text VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (status_id)
);


CREATE TABLE IF NOT EXISTS STANDINGS (
    standings_id INT GENERATED ALWAYS AS IDENTITY,
    season_id INT NOT NULL,
    round INT NOT NULL,
    position FLOAT NOT NULL,
    points FLOAT NOT NULL,
    wins FLOAT NOT NULL,
    PRIMARY KEY (standings_id),
    FOREIGN KEY (season_id) REFERENCES SEASONS(season_id)
);



CREATE TABLE IF NOT EXISTS CONTINENTS (
    continent_id INT GENERATED ALWAYS AS IDENTITY,
    continent_code VARCHAR(255) NOT NULL UNIQUE,
    continent_name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (continent_id)
);

CREATE TABLE IF NOT EXISTS COUNTRIES (
    country_id INT GENERATED ALWAYS AS IDENTITY,
    code VARCHAR(255) NOT NULL UNIQUE,
    country_name VARCHAR(255) NOT NULL UNIQUE,
    continent_id INT NOT NULL,
    wikipedia_link VARCHAR(255),
    PRIMARY KEY (country_id),
    FOREIGN KEY (continent_id) REFERENCES CONTINENTS(continent_id)  
);

CREATE TABLE IF NOT EXISTS COUNTRY_KEYWORDS (
    alternate_id   INT GENERATED ALWAYS AS IDENTITY,
    country_id        INT NOT NULL,
    keyword VARCHAR(255) NOT NULL,
    PRIMARY KEY (alternate_id),
    FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id)
);

CREATE TABLE IF NOT EXISTS TIMEZONES (
    timezone_id INT GENERATED ALWAYS AS IDENTITY,
    timezone_name VARCHAR(255) NOT NULL UNIQUE,
    gmt_offset FLOAT NOT NULL,
    dst_offset FLOAT NOT NULL,
    raw_offset FLOAT NOT NULL,
    PRIMARY KEY (timezone_id)
);

CREATE TABLE IF NOT EXISTS LANGUAGENAMES (
    language_id INT GENERATED ALWAYS AS IDENTITY,
    language_name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (language_id)
);

CREATE TABLE IF NOT EXISTS ISOLANGUAGECODES (
    isolanguage_id INT GENERATED ALWAYS AS IDENTITY,
    iso_639_3 VARCHAR(255) UNIQUE,
    iso_639_2 VARCHAR(255) UNIQUE,
    iso_639_1 VARCHAR(255) UNIQUE,
    language_id INT NOT NULL,
    PRIMARY KEY (isolanguage_id),
    FOREIGN KEY (language_id) REFERENCES LANGUAGENAMES(language_id)
);


CREATE TABLE IF NOT EXISTS COUNTRYLANGUAGES (
    country_id INT NOT NULL,
    language_id INT NOT NULL,
    PRIMARY KEY (country_id, language_id),
    FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id),
    FOREIGN KEY (language_id) REFERENCES LANGUAGENAMES(language_id)
);



CREATE TABLE IF NOT EXISTS FEATURECODES (
    featurecode_id INT GENERATED ALWAYS AS IDENTITY,
    featurecode VARCHAR(255) NOT NULL UNIQUE,
    featureclass VARCHAR(255) NOT NULL,
    featurename VARCHAR(255) NOT NULL,
    featuredescription VARCHAR(255),
    PRIMARY KEY (featurecode_id)
);

CREATE TABLE IF NOT EXISTS CITIES (
    city_id INT GENERATED ALWAYS AS IDENTITY,
    city_name VARCHAR(255) NOT NULL,
    city_ascii_name VARCHAR(255) NOT NULL,
    latitude FLOAT,
    longitude FLOAT,
    featurecode_id INT NOT NULL,
    country_id INT,
    timezone_id INT NOT NULL,
    cc2 VARCHAR(255),
    admin1_code VARCHAR(255),
    admin2_code VARCHAR(255),
    admin3_code VARCHAR(255),
    admin4_code VARCHAR(255),
    city_population INT,
    city_elevation INT,
    city_dem INT,
    modification_date DATE NOT NULL,
    PRIMARY KEY (city_id),
    FOREIGN KEY (featurecode_id) REFERENCES FEATURECODES(featurecode_id),
    FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id),
    FOREIGN KEY (timezone_id) REFERENCES TIMEZONES(timezone_id)
);

CREATE TABLE IF NOT EXISTS CITY_ALTERNATE_NAMES (
    alternate_id   INT GENERATED ALWAYS AS IDENTITY,
    city_id        INT NOT NULL,
    alternate_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (alternate_id),
    FOREIGN KEY (city_id) REFERENCES CITIES(city_id)
);

CREATE TABLE IF NOT EXISTS CIRCUITS (
    circuit_id INT GENERATED ALWAYS AS IDENTITY,
    circuit_ref VARCHAR(255) NOT NULL UNIQUE,
    circuit_name VARCHAR(255) NOT NULL,
    circuit_lat FLOAT,
    circuit_lng FLOAT,
    circuit_city_id INT,
    circuit_url VARCHAR(255),
    PRIMARY KEY (circuit_id),
    FOREIGN KEY (circuit_city_id) REFERENCES CITIES(city_id)
);

CREATE TABLE IF NOT EXISTS RACES (
    race_id INT GENERATED ALWAYS AS IDENTITY,
    race_ref VARCHAR(255) NOT NULL UNIQUE,
    season_id INT NOT NULL,
    circuit_id INT NOT NULL,
    round INT,
    race_name VARCHAR(255),
    race_date DATE,
    race_time TIME,
    PRIMARY KEY (race_id),
    FOREIGN KEY (circuit_id) REFERENCES CIRCUITS(circuit_id),
    FOREIGN KEY (season_id) REFERENCES SEASONS(season_id)
);

CREATE TABLE IF NOT EXISTS QUALIFYING (
    qualify_id INT GENERATED ALWAYS AS IDENTITY,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    constructor_id INT NOT NULL,
    position INT NOT NULL,
    Q1 VARCHAR(255),
    Q2 VARCHAR(255),
    Q3 VARCHAR(255),
    PRIMARY KEY (qualify_id),
    FOREIGN KEY (race_id) REFERENCES RACES(race_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id),
    FOREIGN KEY (constructor_id) REFERENCES CONSTRUCTORS(constructor_id)
);

CREATE TABLE IF NOT EXISTS RESULTS (
    result_id INT GENERATED ALWAYS AS IDENTITY,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    constructor_id INT NOT NULL,
    grid INT,
    position VARCHAR(3),
    position_order INT,
    points FLOAT,
    laps   INT,
    status_id INT NOT NULL,
    PRIMARY KEY (result_id),
    FOREIGN KEY (race_id) REFERENCES RACES(race_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id),
    FOREIGN KEY (constructor_id) REFERENCES CONSTRUCTORS(constructor_id),
    FOREIGN KEY (status_id) REFERENCES RACESTATUS(status_id)
);

CREATE TABLE IF NOT EXISTS DRIVERSTANDINGS (
    standings_id INT NOT NULL,
    driver_id INT NOT NULL,
    PRIMARY KEY (standings_id, driver_id),
    FOREIGN KEY (standings_id) REFERENCES STANDINGS(standings_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id)
);


CREATE TABLE IF NOT EXISTS CONSTRUCTORSTANDINGS (
    standings_id INT NOT NULL,
    constructor_id INT NOT NULL,
    PRIMARY KEY (standings_id, constructor_id),
    FOREIGN KEY (standings_id) REFERENCES STANDINGS(standings_id),
    FOREIGN KEY (constructor_id) REFERENCES CONSTRUCTORS(constructor_id)
);


CREATE TABLE IF NOT EXISTS AIRPORTTYPES(
    airporttype_id INT GENERATED ALWAYS AS IDENTITY,
    airporttype VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (airporttype_id)
);



CREATE TABLE IF NOT EXISTS AIRPORTS (
    airport_id INT GENERATED ALWAYS AS IDENTITY,
    airport_identifier VARCHAR(255) NOT NULL UNIQUE,
    airporttype_id INT NOT NULL,
    airport_name VARCHAR(255) NOT NULL,
    lat_deg FLOAT NOT NULL,
    long_deg  FLOAT NOT NULL,
    elev_ft INT,
    city_id INT,
    scheduled_service VARCHAR(255) NOT NULL,
    GPS_code VARCHAR(255),
    IATA_code VARCHAR(255),
    ICAO_code VARCHAR(255),
    local_code VARCHAR(255),
    home_link VARCHAR(255),
    wikipedia_link VARCHAR(255),
    keywords VARCHAR(255),
    PRIMARY KEY (airport_id),
    FOREIGN KEY (airporttype_id) REFERENCES AIRPORTTYPES(airporttype_id),
    FOREIGN KEY (city_id) REFERENCES CITIES(city_id)
);

/* SCRIPTS PARA INSERÇÃO DE DADOS NAS TABELAS */

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

CREATE TEMP TABLE stg_countryinfo (
    iso_alpha2     TEXT,
    iso_alpha3     TEXT,
    iso_numeric    TEXT,
    fips           TEXT,
    country_name   TEXT,
    capital        TEXT,
    area_km2       TEXT,
    population     TEXT,
    continent      TEXT,
    tld            TEXT,
    currency_code  TEXT,
    currency_name  TEXT,
    phone          TEXT,
    postal_format  TEXT,
    postal_regex   TEXT,
    languages      TEXT,
    geoname_id     TEXT,
    neighbours     TEXT,
    fips_equiv     TEXT
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
-- \copy: leitura dos arquivos nas tabelas de staging (lado cliente)

\copy stg_countries (id, code, name, continent, wikipedia_link, keywords) FROM 'trabalho3/countries.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', DELIMITER ',', NULL '')
\copy stg_countryinfo FROM 'trabalho3/countryInfo_clean.txt' WITH (FORMAT csv, HEADER false, DELIMITER E'\t', NULL '')

\copy stg_timezones (country_code, timezone_name, gmt_offset, dst_offset, raw_offset) FROM 'trabalho3/timeZones.tsv' WITH (FORMAT csv, HEADER true, DELIMITER E'\t', NULL '')

\copy stg_featurecodes (code_full, featurename, featuredescription) FROM 'trabalho3/featureCodes_en.tsv' WITH (FORMAT csv, HEADER false, DELIMITER E'\t', NULL '')

\copy stg_cities (geoname_id, city_name, city_ascii_name, city_alternate_names, latitude, longitude, feature_class, feature_code, country_code, cc2, admin1_code, admin2_code, admin3_code, admin4_code, population, elevation, dem, timezone_name, modification_date) FROM 'trabalho3/cities.tsv' WITH (FORMAT csv, HEADER false, DELIMITER E'\t', NULL '')

\copy stg_languagecodes (iso_639_3, iso_639_2, iso_639_1, language_name) FROM 'trabalho3/iso-languagecodes.tsv' WITH (FORMAT csv, HEADER true, DELIMITER E'\t', NULL '')

\copy stg_constructors (constructor_ref, constructor_name, nationality, wikipedia_url) FROM 'trabalho3/constructors.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_drivers (driver_ref, given_name, family_name, nationality, date_of_birth) FROM 'trabalho3/drivers.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_circuits (circuit_ref, circuit_name, lat, lng, locality, country, wikipedia_url) FROM 'trabalho3/circuits.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_races (race_ref, season_year, round, race_name, race_date, race_time, circuit_ref) FROM 'trabalho3/races.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_results (race_ref, driver_ref, constructor_ref, grid, position, position_order, points, laps, status_text) FROM 'trabalho3/results.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_qualifying (race_ref, driver_ref, constructor_ref, position, q1, q2, q3) FROM 'trabalho3/qualifying.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_driver_standings (season_year, round, driver_ref, position, points, wins) FROM 'trabalho3/driver_standings.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_constructor_standings (season_year, round, constructor_ref, position, points, wins) FROM 'trabalho3/constructor_standings.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '')

\copy stg_airports (id, ident, type, name, latitude_deg, longitude_deg, elevation_ft, continent, iso_country, iso_region, municipality, scheduled_service, icao_code, iata_code, gps_code, local_code, home_link, wikipedia_link, keywords) FROM 'trabalho3/airports.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', DELIMITER ',', NULL '')


-- INSERT nas tabelas finais
-- (ordem respeita as dependências de chaves estrangeiras)

-- 1. CONTINENTS
\echo "Inserting CONTINENTS..."
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
\echo "Inserting COUNTRIES..."
-- 2. COUNTRIES (sem keywords)
INSERT INTO COUNTRIES (code, country_name, continent_id, wikipedia_link)
SELECT
    s.code,
    s.name,
    c.continent_id,
    NULLIF(s.wikipedia_link, '')
FROM stg_countries s
JOIN CONTINENTS c ON c.continent_code = s.continent
WHERE s.code <> ''
ON CONFLICT DO NOTHING;

-- 2b. COUNTRY_KEYWORDS
INSERT INTO COUNTRY_KEYWORDS (country_id, keyword)
SELECT
    co.country_id,
    TRIM(keyword) AS keyword
FROM stg_countries s
JOIN COUNTRIES co ON co.code = s.code
CROSS JOIN LATERAL unnest(string_to_array(s.keywords, ',')) AS keyword
WHERE s.keywords <> ''
  AND TRIM(keyword) <> '';

-- 3. TIMEZONES
\echo "Inserting TIMEZONES..."
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
\echo "Inserting FEATURECODES..."
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

-- 5. CITIES
\echo "Inserting CITIES..."
INSERT INTO CITIES (
    city_name, city_ascii_name,
    latitude, longitude,
    featurecode_id, country_id, timezone_id,
    cc2, admin1_code, admin2_code, admin3_code, admin4_code,
    city_population, city_elevation, city_dem, modification_date
)
SELECT
    s.city_name,
    s.city_ascii_name,
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

INSERT INTO CITY_ALTERNATE_NAMES (city_id, alternate_name)
SELECT
    ci.city_id,
    TRIM(alt_name) AS alternate_name
FROM stg_cities s
JOIN CITIES ci ON ci.city_ascii_name = s.city_ascii_name
               AND ci.modification_date = CAST(s.modification_date AS DATE)
CROSS JOIN LATERAL unnest(string_to_array(s.city_alternate_names, ',')) AS alt_name
WHERE s.city_alternate_names <> ''
  AND TRIM(alt_name) <> '';

-- 6. LANGUAGENAMES
\echo "Inserting LANGUAGENAMES..."
INSERT INTO LANGUAGENAMES (language_name)
SELECT DISTINCT language_name
FROM stg_languagecodes
ON CONFLICT DO NOTHING;

-- 7. ISOLANGUAGECODES
\echo "Inserting ISOLANGUAGECODES..."
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
\echo "Inserting CONSTRUCTORS..."
INSERT INTO CONSTRUCTORS (constructor_ref, constructor_name, nationality, constructor_url)
SELECT
    constructor_ref,
    constructor_name,
    nationality,
    NULLIF(wikipedia_url, '')
FROM stg_constructors
WHERE constructor_ref <> ''
ON CONFLICT DO NOTHING;

-- 9. DRIVERS
\echo "Inserting DRIVERS..."
INSERT INTO DRIVERS (driver_ref, given_name, family_name, date_of_birth, nationality)
SELECT
    driver_ref,
    given_name,
    family_name,
    CAST(date_of_birth AS DATE),
    nationality
FROM stg_drivers
ON CONFLICT DO NOTHING;

-- 10. SEASONS
\echo "Inserting SEASONS..."
INSERT INTO SEASONS (season_year)
SELECT DISTINCT CAST(season_year AS INT)
FROM stg_races
WHERE season_year ~ '^\d+$'
ON CONFLICT DO NOTHING;

-- 11. RACESTATUS
\echo "Inserting RACESTATUS..."
INSERT INTO RACESTATUS (status_text)
SELECT DISTINCT status_text
FROM stg_results
WHERE status_text <> ''
ON CONFLICT DO NOTHING;

-- 12. CIRCUITS
\echo "Inserting CIRCUITS..."
INSERT INTO CIRCUITS (circuit_ref, circuit_name, circuit_lat, circuit_lng, circuit_city_id, circuit_url)
SELECT
    s.circuit_ref,
    s.circuit_name,
    CAST(s.lat AS FLOAT),
    CAST(s.lng AS FLOAT),
    COALESCE(
        (
            SELECT ci.city_id FROM CITIES ci
            JOIN COUNTRIES co ON co.country_id = ci.country_id
            WHERE (ci.city_name ILIKE s.locality OR ci.city_ascii_name ILIKE s.locality)
              AND co.country_name ILIKE s.country
            LIMIT 1
        ),
        (
            SELECT city_id FROM CITIES
            ORDER BY ABS(latitude  - CAST(s.lat AS FLOAT))
                   + ABS(longitude - CAST(s.lng AS FLOAT))
            LIMIT 1
        )
    ),
    NULLIF(s.wikipedia_url, '')
FROM stg_circuits s
WHERE s.circuit_ref <> ''
  AND s.lat <> ''
  AND s.lng <> ''
ON CONFLICT DO NOTHING;



-- 13. RACES
\echo "Inserting RACES..."
INSERT INTO RACES (race_ref, season_id, circuit_id, round, race_name, race_date, race_time)
SELECT
    s.race_ref,
    se.season_id,
    ci.circuit_id,
    CAST(s.round AS INT),
    s.race_name,
    CAST(s.race_date AS DATE),
    CAST(s.race_time AS TIME)
FROM stg_races s
JOIN SEASONS  se ON se.season_year = CAST(s.season_year AS INT)
JOIN CIRCUITS ci ON ci.circuit_ref = s.circuit_ref
WHERE s.race_ref  <> ''
  AND s.race_date <> ''
ON CONFLICT DO NOTHING;

-- 14. QUALIFYING
\echo "Inserting QUALIFYING..."
INSERT INTO QUALIFYING (race_id, driver_id, constructor_id, position, Q1, Q2, Q3)
SELECT
    r.race_id,
    d.driver_id,
    c.constructor_id,
    CAST(NULLIF(s.position, '') AS INT),
    s.q1,
    s.q2,
    s.q3
FROM stg_qualifying s
JOIN RACES        r ON r.race_ref        = s.race_ref
JOIN DRIVERS      d ON d.driver_ref      = s.driver_ref
JOIN CONSTRUCTORS c ON c.constructor_ref = s.constructor_ref
WHERE s.race_ref <> ''
ON CONFLICT DO NOTHING;



-- 15. RESULTS
\echo "Inserting RESULTS..."
INSERT INTO RESULTS (race_id, driver_id, constructor_id, grid, position, position_order, points, laps, status_id)
SELECT
    r.race_id,
    d.driver_id,
    c.constructor_id,
    CAST(NULLIF(s.grid,           '') AS INT),
    NULLIF(s.position,       ''),
    CAST(NULLIF(s.position_order, '') AS INT),
    CAST(NULLIF(s.points,         '') AS FLOAT),
    CAST(NULLIF(s.laps,           '') AS INT),
    st.status_id
FROM stg_results s
JOIN RACES        r  ON r.race_ref        = s.race_ref
JOIN DRIVERS      d  ON d.driver_ref      = s.driver_ref
JOIN CONSTRUCTORS c  ON c.constructor_ref = s.constructor_ref
JOIN RACESTATUS   st ON st.status_text    = s.status_text
WHERE s.race_ref <> ''
ON CONFLICT DO NOTHING;


-- 16. AIRPORTTYPES
\echo "Inserting AIRPORTTYPES..."
-- Derivados dos valores únicos da coluna type em airports.csv.
INSERT INTO AIRPORTTYPES (airporttype)
SELECT DISTINCT type
FROM stg_airports
WHERE type <> ''
ON CONFLICT DO NOTHING;


-- 17. STANDINGS + DRIVERSTANDINGS
-- Cada linha do CSV de driver standings gera uma linha em STANDINGS
-- e uma correspondente em DRIVERSTANDINGS, via CTE com RETURNING.

-- Não existe um .csv standings somente, então toda vez q inserimos em driver ou constructor, inserimos também em standings, e depois associamos com driverstandings ou constructorstandings, respectivamente.


\echo "Inserting STANDINGS + DRIVERSTANDINGS..."

WITH numbered AS ( -- para garantir a correspondência entre as linhas inseridas em STANDINGS e as linhas originais do CSV, mesmo com possíveis filtros ou ordenações
    SELECT *,
           ROW_NUMBER() OVER () AS rn
    FROM stg_driver_standings
    WHERE season_year <> ''
),
inserted AS ( -- inserção em STANDINGS, retornando o ID gerado para cada linha
    INSERT INTO STANDINGS (season_id, round, position, points, wins)
    SELECT
        se.season_id,
        CAST(CAST(n.round AS FLOAT) AS INT),
        COALESCE(CAST(NULLIF(n.position, '') AS FLOAT), 0),
        COALESCE(CAST(NULLIF(n.points, '') AS FLOAT), 0),
        COALESCE(CAST(NULLIF(n.wins, '') AS FLOAT), 0)
    FROM numbered n
    JOIN SEASONS se ON se.season_year = CAST(n.season_year AS INT)
    RETURNING standings_id
),
numbered_inserted AS ( -- para garantir a correspondência entre as linhas inseridas em STANDINGS e as linhas originais do CSV, mesmo com possíveis filtros ou ordenações
    SELECT
        i.standings_id,
        ROW_NUMBER() OVER () AS rn
    FROM inserted i
)
INSERT INTO DRIVERSTANDINGS (standings_id, driver_id) -- associação com driver_id via JOIN com o CSV (staged) original
SELECT
    ni.standings_id,
    d.driver_id
FROM numbered_inserted ni
JOIN numbered n ON n.rn = ni.rn
JOIN DRIVERS d ON d.driver_ref = n.driver_ref
ON CONFLICT DO NOTHING;


-- 18. CONSTRUCTORSTANDINGS
-- Mesma lógica de DRIVERSTANDINGS, mas associando com constructor_id em vez de driver_id.
\echo "Inserting STANDINGS + CONSTRUCTORSTANDINGS..."

WITH numbered AS (
    SELECT *,
           ROW_NUMBER() OVER () AS rn
    FROM stg_constructor_standings
    WHERE season_year <> ''
),
inserted AS (
    INSERT INTO STANDINGS (season_id, round, position, points, wins)
    SELECT
        se.season_id,
        CAST(CAST(n.round AS FLOAT) AS INT),
        COALESCE(CAST(NULLIF(n.position, '') AS FLOAT), 0),
        COALESCE(CAST(NULLIF(n.points, '') AS FLOAT), 0),
        COALESCE(CAST(NULLIF(n.wins, '') AS FLOAT), 0)
    FROM numbered n
    JOIN SEASONS se 
        ON se.season_year = CAST(n.season_year AS INT)
    RETURNING standings_id
),
numbered_inserted AS (
    SELECT
        i.standings_id,
        ROW_NUMBER() OVER () AS rn
    FROM inserted i
)

INSERT INTO CONSTRUCTORSTANDINGS (standings_id, constructor_id)
SELECT
    ni.standings_id,
    c.constructor_id
FROM numbered_inserted ni
JOIN numbered n 
    ON n.rn = ni.rn
JOIN CONSTRUCTORS c 
    ON c.constructor_ref = n.constructor_ref
ON CONFLICT DO NOTHING;

-- 19. AIRPORTS
\echo "Inserting AIRPORTS..."

ALTER TABLE AIRPORTS 
ALTER COLUMN keywords TYPE TEXT;

ALTER TABLE AIRPORTS 
ALTER COLUMN wikipedia_link TYPE TEXT;

ALTER TABLE AIRPORTS 
ALTER COLUMN home_link TYPE TEXT;

INSERT INTO AIRPORTS (
    airport_identifier, airporttype_id, airport_name,
    lat_deg, long_deg, elev_ft, city_id,
    scheduled_service, GPS_code, IATA_code, ICAO_code, local_code,
    home_link, wikipedia_link, keywords
)
SELECT
    s.ident,
    apt.airporttype_id,
    s.name,
    CAST(NULLIF(s.latitude_deg,  '') AS FLOAT),
    CAST(NULLIF(s.longitude_deg, '') AS FLOAT),
    CAST(NULLIF(s.elevation_ft, '') AS INT),

    COALESCE(
        -- 1. tenta achar cidade pelo nome + país
        (
            SELECT ci.city_id 
            FROM CITIES ci
            WHERE (ci.city_name ILIKE s.municipality 
                OR ci.city_ascii_name ILIKE s.municipality)
              AND ci.country_id = co.country_id
            LIMIT 1
        ),

        -- 2. fallback: cidade mais próxima pelas coordenadas
        (
            SELECT city_id 
            FROM CITIES
            WHERE s.latitude_deg  <> ''
              AND s.longitude_deg <> ''
            ORDER BY 
                ABS(latitude  - CAST(s.latitude_deg  AS FLOAT)) +
                ABS(longitude - CAST(s.longitude_deg AS FLOAT))
            LIMIT 1
        )
    ),

    s.scheduled_service,
    NULLIF(s.gps_code,   ''),
    NULLIF(s.iata_code,  ''),
    NULLIF(s.icao_code,  ''),
    NULLIF(s.local_code, ''),
    NULLIF(s.home_link,      ''),
    NULLIF(s.wikipedia_link, ''),
    NULLIF(s.keywords,       '')

FROM stg_airports s
JOIN AIRPORTTYPES apt 
    ON apt.airporttype = s.type

LEFT JOIN COUNTRIES co 
    ON co.code ILIKE s.iso_country

WHERE s.ident <> ''

ON CONFLICT DO NOTHING;


-- 20. COUNTRYLANGUAGES
\echo "Inserting COUNTRYLANGUAGES..."
INSERT INTO COUNTRYLANGUAGES (country_id, language_id)
SELECT DISTINCT
    co.country_id,
    ilc.language_id
FROM stg_countryinfo ci
JOIN COUNTRIES co
    ON co.code = ci.iso_alpha2
CROSS JOIN LATERAL unnest(string_to_array(ci.languages, ',')) AS raw_code
-- pegar subtag regional: 'ar-AE' -> 'ar', 'fa-AF' -> 'fa'
CROSS JOIN LATERAL (SELECT split_part(raw_code, '-', 1) AS lang_code) AS lc
JOIN ISOLANGUAGECODES ilc
    ON  ilc.iso_639_1 = lc.lang_code
    OR  ilc.iso_639_3 = lc.lang_code
    OR  ilc.iso_639_2 = lc.lang_code
WHERE ci.languages IS NOT NULL
  AND ci.languages <> ''
ON CONFLICT DO NOTHING;


COMMIT;
