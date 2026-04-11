

CREATE TABLE IF NOT EXISTS CONSTRUCTORS (
    constructor_id INT GENERATED ALWAYS AS IDENTITY,
    constructor_ref VARCHAR(255) NOT NULL UNIQUE,
    constructor_name VARCHAR(255) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    contructor_url VARCHAR(255),
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
    position INT NOT NULL,
    points FLOAT NOT NULL,
    wins INT NOT NULL,
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
    keywords VARCHAR(255),
    PRIMARY KEY (country_id),
    FOREIGN KEY (continent_id) REFERENCES CONTINENTS(continent_id)  
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
    city_alternate_names VARCHAR(255),
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
    city_levation INT,
    city_dem INT,
    modification_date DATE NOT NULL,
    PRIMARY KEY (city_id),
    FOREIGN KEY (featurecode_id) REFERENCES FEATURECODES(featurecode_id),
    FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id),
    FOREIGN KEY (timezone_id) REFERENCES TIMEZONES(timezone_id)
);

CREATE TABLE IF NOT EXISTS CIRCUITS (
    circuit_id INT GENERATED ALWAYS AS IDENTITY,
    circuit_ref VARCHAR(255) NOT NULL UNIQUE,
    circuit_name VARCHAR(255) NOT NULL,
    circuit_lat FLOAT,
    circuit_lng FLOAT,
    circuit_city_id INT NOT NULL,
    circuit_url VARCHAR(255) NOT NULL,
    PRIMARY KEY (circuit_id),
    FOREIGN KEY (circuit_city_id) REFERENCES CITIES(city_id)
);

CREATE TABLE IF NOT EXISTS RACES (
    race_id INT GENERATED ALWAYS AS IDENTITY,
    race_ref VARCHAR(255) NOT NULL UNIQUE,
    season_id INT NOT NULL,
    circuit_id INT NOT NULL,
    round INT NOT NULL,
    race_name VARCHAR(255) NOT NULL,
    race_date DATE NOT NULL,
    race_time VARCHAR(255),
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
    Q1 VARCHAR(255) NOT NULL,
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
    grid INT NOT NULL,
    position INT NOT NULL,
    position_order INT NOT NULL,
    points FLOAT NOT NULL,
    laps   INT NOT NULL,
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
    elev_ft INT NOT NULL,
    city_id INT NOT NULL,
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



