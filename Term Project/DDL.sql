--Updated: 12/06/2020 3:22pm 

CREATE TABLE cityLocation(
cityName VARCHAR(30) NOT NULL, 
country VARCHAR(30) NOT NULL,

CONSTRAINT cityLocation_pk PRIMARY KEY(cityName, country)
);

CREATE TABLE airline(
airlineName VARCHAR(30) NOT NULL, 
hotlineNumber VARCHAR(20) NOT NULL,
headquarterCountry VARCHAR(30) NOT NULL,
headquarterCity VARCHAR(30) NOT NULL,

CONSTRAINT airline_pk PRIMARY KEY(airlineName), 

CONSTRAINT airline_cityLocation_fk FOREIGN KEY
(headquarterCity, headquarterCountry) 
REFERENCES cityLocation(cityName, country)
);

CREATE TABLE planes(
tailNumber VARCHAR(20) NOT NULL, 
accumulatedFlightTime INT NOT NULL, 
model VARCHAR(40) NOT NULL, 
capacity INT NOT NULL, 
airline VARCHAR(30) NOT NULL, 

CONSTRAINT planes_pk PRIMARY KEY (tailNumber),

CONSTRAINT palnes_airline_fk FOREIGN KEY(airline) 
REFERENCES airline(airlineName)
);

CREATE TABLE maintenance(
date DATE NOT NULL, 
cost DECIMAL(10, 2) NOT NULL, 
tailNumber VARCHAR(20) NOT NULL, 

CONSTRAINT maintenance_pk PRIMARY KEY(tailNumber, date), 

CONSTRAINT maintenance_planes_fk FOREIGN KEY(tailNumber) 
REFERENCES planes(tailNumber)
);

CREATE TABLE airport(
airportName VARCHAR(40) NOT NULL, 
FAAAbbreviation VARCHAR(20) NOT NULL,
airportCountry VARCHAR(30) NOT NULL,
airportCity VARCHAR(30) NOT NULL,

CONSTRAINT airport_pk PRIMARY KEY(FAAAbbreviation),

CONSTRAINT airport_cityLocation_fk FOREIGN KEY(airportCity, airportCountry)
REFERENCES cityLocation(cityName, country)
);

CREATE TABLE flightSchedule(
estimatedDepartureTime TIME NOT NULL,  
estimatedArrivalTime TIME NOT NULL,  
FSID INT NOT NULL, 
departureAirport VARCHAR(20) NOT NULL,  
arrivalAirport VARCHAR(20) NOT NULL, 
airline VARCHAR(30) NOT NULL, 

CONSTRAINT flightSchedule_pk PRIMARY KEY(FSID), 

CONSTRAINT flightSchedule_departureAirport_fk FOREIGN KEY
(departureAirport)
REFERENCES airport(FAAAbbreviation), 

CONSTRAINT flightSchedule_arrivalAirport_fk FOREIGN KEY
(arrivalAirport)
REFERENCES airport(FAAAbbreviation), 

CONSTRAINT flightSchedule_airline_fk FOREIGN KEY(airline)
REFERENCES airline(airlineName),

CONSTRAINT flightSchedule_ck UNIQUE(estimatedDepartureTime, estimatedArrivalTime, departureAirport, arrivalAirport, airline)
); 

--WEATHER ENUMERATION
CREATE TABLE weatherEnum (
id INTEGER PRIMARY KEY,
type VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE flightInstance(
date DATE NOT NULL, 
singleFlightTime INT NOT NULL, 
actualArrivalTime TIME NOT NULL, 
actualDepartureTime TIME NOT NULL, 
weatherType INTEGER NOT NULL DEFAULT 1,
FIID INT NOT NULL, 
FSID INT NOT NULL, 
tailNumber VARCHAR(20) NOT NULL, 

CONSTRAINT flightInstance_pk PRIMARY KEY(FIID), 

CONSTRAINT flightInstance_flightSchedule_fk FOREIGN KEY(FSID) 
REFERENCES flightSchedule(FSID), 

CONSTRAINT flightInstance_planes_fk FOREIGN KEY(tailNumber) 
REFERENCES planes(tailNumber), 

CONSTRAINT flightInstance_weatherEnum_fk FOREIGN KEY(weatherType)
REFERENCES weatherEnum (id),

CONSTRAINT flightInstance_ck UNIQUE(FSID, FIID, tailNumber)
);

CREATE TABLE weatherReport(
FIID INT NOT NULL,
reportType INTEGER NOT NULL DEFAULT 1,
value INT CHECK (value > -1 AND value < 11) DEFAULT 0,

CONSTRAINT weatherReport_pk PRIMARY KEY (FIID, reportType),

CONSTRAINT weatherReport_flightInstance_fk FOREIGN KEY (FIID)
REFERENCES flightInstance(FIID),

CONSTRAINT weatherReport_weatherEnum_fk FOREIGN KEY (reportType)
REFERENCES weatherEnum (id)
);

--CREW ENUMERATION
CREATE TABLE position(
id INTEGER PRIMARY KEY,
crewRole VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE crewMate(
FAANumber INT NOT NULL, 
crewRole INTEGER NOT NULL, 
name VARCHAR(30) NOT NULL, 
birthday DATE NOT NULL, 
emailAddress VARCHAR(40) NOT NULL, 

CONSTRAINT crewMate_pk PRIMARY KEY(FAANumber), 

CONSTRAINT crewMate_position_fk FOREIGN KEY(crewRole)
REFERENCES position(id),

CONSTRAINT crewMate_ck UNIQUE (name, birthday, emailAddress)
);

CREATE TABLE crewAssignment(
FAANumber INT NOT NULL, 
FIID INT NOT NULL, 

CONSTRAINT crewAssignment_pk PRIMARY KEY(FAANumber, FIID),

CONSTRAINT crewAssignment_crewMate_fk FOREIGN KEY(FAANumber)
REFERENCES crewMate(FAANumber), 

CONSTRAINT crewAssignment_flightInstance_fk FOREIGN KEY(FIID)
REFERENCES flightInstance(FIID) 
); 

--ENUMERATION OF INCIDENT TYPE
CREATE TABLE incidentEnum(
id INTEGER PRIMARY KEY,
type VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE incidentReport(
description VARCHAR(100) NOT NULL, 
incidentType INTEGER NOT NULL, 
reportingCrewMate INT NOT NULL, 
involvedCrewMate INT NOT NULL, 
crewFlightInstance INT NOT NULL, 
FIID INT NOT NULL, 

CONSTRAINT incidentReport_pk PRIMARY KEY(reportingCrewMate, involvedCrewMate, 
crewFlightInstance, FIID), 

CONSTRAINT incidentReport_crewAssignmentReporter_fk FOREIGN KEY
(reportingCrewMate, crewFlightInstance) 
REFERENCES crewAssignment(FAANumber, FIID), 

CONSTRAINT incidentReport_crewAssignmentInvolved_fk FOREIGN KEY
(involvedCrewMate, crewFlightInstance) 
REFERENCES crewAssignment(FAANumber, FIID), 

CONSTRAINT incidentReport_flightInstance_fk FOREIGN KEY(FIID) 
REFERENCES flightInstance(FIID), 

CONSTRAINT incidentReport_incidentEnum_fk FOREIGN KEY(incidentType) 
REFERENCES incidentEnum(id)
); 

CREATE TABLE healthTest(
date DATE NOT NULL, 
testScore INT CHECK (testScore > 49 AND testScore < 101) NOT NULL, 
description VARCHAR(200) NOT NULL,
FAANumber INT NOT NULL, 

CONSTRAINT healthTest_pk PRIMARY KEY(FAANumber, date), 

CONSTRAINT healthTest_crewMate_fk FOREIGN KEY(FAANumber) 
REFERENCES crewMate(FAANumber)
);

CREATE TABLE international(
FSID INT NOT NULL, 

CONSTRAINT international_pk PRIMARY KEY(FSID), 

CONSTRAINT international_flightSchedule_fk FOREIGN KEY(FSID) 
REFERENCES flightSchedule(FSID)
);

CREATE TABLE other(
isOfferAmenity BOOLEAN DEFAULT false,
departureState VARCHAR(30), 
arrivalState VARCHAR(30), 
FSID INT NOT NULL, 

CONSTRAINT other_pk PRIMARY KEY(FSID, isOfferAmenity), 

CONSTRAINT other_flightSchedule_fk FOREIGN KEY(FSID) 
REFERENCES flightSchedule(FSID)
);

CREATE TABLE amenity(
amenityName VARCHAR(30) NOT NULL, 
price DECIMAL(10, 2), 

CONSTRAINT amenity_pk PRIMARY KEY(amenityName) 
);

CREATE TABLE storage(
unitsInStock INT,
amenityName VARCHAR(30) NOT NULL, 
FSID INT NOT NULL, 

CONSTRAINT storage_pk PRIMARY KEY(amenityName, FSID), 

CONSTRAINT storage_amenity_fk FOREIGN KEY(amenityName) 
REFERENCES amenity(amenityName), 

CONSTRAINT storage_flightSchedule_fk FOREIGN KEY(FSID) 
REFERENCES flightSchedule(FSID)
);