CREATE TABLE IF NOT EXISTS CIRCUITS (
    circuit_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    circuit_ref VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    alt INT NOT NULL,
    url VARCHAR(255) NOT NULL
);

/* circuit_ref = circuit id (circuits)
altitude: buscar no geocities*/

CREATE TABLE IF NOT EXISTS CONSTRUCTORS (
    constructor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    constructor_ref VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    url VARCHAR(255) NOT NULL
);

/*.  constructor_ref = constructor_id (constructor)*/

CREATE TABLE IF NOT EXISTS DRIVERS (
    driver_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    driver_ref VARCHAR(255) NOT NULL,
    number INT,
    code VARCHAR(255),
    forename VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    dob  DATE NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    url VARCHAR(255) NOT NULL
); 

/* id, ref, forename, surname, doc, nationality -> drivers
   resto -> f1_2025_last_race_results */

CREATE TABLE IF NOT EXISTS SEASONS (
    year INT PRIMARY KEY,
    url VARCHAR(255) NOT NULL
);

/*tabela nao existe -> pegar unique de races */

CREATE TABLE IF NOT EXISTS RACES (
    race_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    race_ref VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    round INT NOT NULL,
    circuit_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    time VARCHAR(255) NOT NULL,
    url VARCHAR(255) NOT NULL,
    FOREIGN KEY (circuit_id) REFERENCES CIRCUITS(circuit_id),
    FOREIGN KEY (year) REFERENCES SEASONS(year)
);

/* race_ref = race id (races)
url -> nao achei em outras tabelas */

CREATE TABLE IF NOT EXISTS DRIVERSTANDINGS (
    driver_standings_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    points FLOAT NOT NULL,
    position INT NOT NULL,
    position_text VARCHAR(255) NOT NULL,
    wins INT NOT NULL,
    FOREIGN KEY (race_id) REFERENCES RACES(race_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id)
);

/*nao tem race_id, n sei como achar tbm*/

CREATE TABLE IF NOT EXISTS LAPTIMES (
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    lap INT NOT NULL,
    position INT NOT NULL,
    time VARCHAR(255) NOT NULL,
    millis INT NOT NULL,
    PRIMARY KEY (race_id, driver_id, lap),
    FOREIGN KEY (race_id) REFERENCES RACES(race_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id)
);

/* não achei a tabela nem as informações*/

CREATE TABLE IF NOT EXISTS PITSTOPS (
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    stop INT NOT NULL,
    lap INT NOT NULL,
    time VARCHAR(255) NOT NULL,
    duration VARCHAR(255) NOT NULL,
    millis INT NOT NULL,
    PRIMARY KEY (race_id, driver_id, stop),
    FOREIGN KEY (race_id) REFERENCES RACES(race_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id)
);

/*também não achei a tabela nem as informações*/

CREATE TABLE IF NOT EXISTS QUALIFYING (
    qualify_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    constructor_id INT NOT NULL,
    number INT NOT NULL,
    position INT NOT NULL,
    Q1 VARCHAR(255) NOT NULL,
    Q2 VARCHAR(255) NOT NULL,
    Q3 VARCHAR(255) NOT NULL,
    FOREIGN KEY (race_id) REFERENCES RACES(race_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id),
    FOREIGN KEY (constructor_id) REFERENCES CONSTRUCTORS(constructor_id)
);

/*na tabela tem as refs, mas conseguimos constuir puxando das outras tabelas
não tem number, mas podemos esclarescer se é um auto-increment*/

CREATE TABLE IF NOT EXISTS STATUS (
    status_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status_text VARCHAR(255) NOT NULL
);

/*nao existe mas de novo, só colocar as uniques da tabela result*/



CREATE TABLE IF NOT EXISTS RESULTS (
    result_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    constructor_id INT NOT NULL,
    number INT NOT NULL,
    grid INT NOT NULL,
    position INT NOT NULL,
    position_text VARCHAR(255) NOT NULL,
    position_order INT NOT NULL,
    points FLOAT NOT NULL,
    laps   INT NOT NULL,
    time VARCHAR(255) NOT NULL,
    millis INT NOT NULL,
    fastest_lap INT NOT NULL,
    rank INT NOT NULL,
    fastest_lap_time VARCHAR(255) NOT NULL,
    fastest_lap_speed VARCHAR(255) NOT NULL,
    status_id INT NOT NULL,
    FOREIGN KEY (race_id) REFERENCES RACES(race_id),
    FOREIGN KEY (driver_id) REFERENCES DRIVERS(driver_id),
    FOREIGN KEY (constructor_id) REFERENCES CONSTRUCTORS(constructor_id),
    FOREIGN KEY (status_id) REFERENCES STATUS(status_id)
);  


/*tem tudo até points, depois tem que pegar em last_results lap speed ->n tem, e acho q tbm nao temos o tamanho do circuito */

CREATE TABLE IF NOT EXISTS AIRPORTS (
    airport_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    airport_identifier VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    lat_deg FLOAT NOT NULL,
    long_deg  FLOAT NOT NULL,
    elev_ft INT NOT NULL,
    continent VARCHAR(255) NOT NULL,
    ISOCountry VARCHAR(255) NOT NULL,
    ISORegion VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    ScheduledService VARCHAR(255) NOT NULL,
    GPSCode VARCHAR(255) NOT NULL,
    IATACode VARCHAR(255) NOT NULL,
    LocalCode VARCHAR(255) NOT NULL,
    HomeLink VARCHAR(255) NOT NULL,
    WikipediaLink VARCHAR(255) NOT NULL,
    Keywords VARCHAR(255) NOT NULL
);

/*tudo ok*/

CREATE TABLE IF NOT EXISTS COUNTRIES (
    country_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    continent VARCHAR(255) NOT NULL,
    wikipedia_link VARCHAR(255) NOT NULL,
    keywords VARCHAR(255) NOT NULL
);

/*tudo certo*/


CREATE TABLE IF NOT EXISTS GEOCITIES15K (
    GeoCityID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Asciiname VARCHAR(255) NOT NULL,
    Alternatenames VARCHAR(255) NOT NULL,
    Latitude FLOAT NOT NULL,
    Longitude FLOAT NOT NULL,
    FeatureClass VARCHAR(255) NOT NULL,
    FeatureCode VARCHAR(255) NOT NULL,
    CountryCode VARCHAR(255) NOT NULL,
    CC2 VARCHAR(255) NOT NULL,
    Admin1Code VARCHAR(255) NOT NULL,
    Admin2Code VARCHAR(255) NOT NULL,
    Admin3Code VARCHAR(255) NOT NULL,
    Admin4Code VARCHAR(255) NOT NULL,
    Population INT NOT NULL,
    Elevation INT NOT NULL,
    Dem INT NOT NULL,
    Timezone VARCHAR(255) NOT NULL,
    ModificationDate DATE NOT NULL
);

/*o cities ta sem header!! tentei entrar no site mas ta organizado por pais kkkk */

