CREATE DATABASE “DB05”;

CREATE TABLE Country (
    CountryID VARCHAR(20) NOT NULL,
    CountryName VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Country PRIMARY KEY (CountryID)
);
CREATE TABLE Province (
    ProvinceID VARCHAR(20) NOT NULL,
    ProvinceName VARCHAR(100) NOT NULL,
    Population INT,
    Area FLOAT,
    CountryID VARCHAR(20),
    CONSTRAINT PK_Province PRIMARY KEY (ProvinceID),
    CONSTRAINT FK_Province_Country FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);
CREATE TABLE Border (
    ProvinceID VARCHAR(20) NOT NULL,
    NationID VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Border PRIMARY KEY (ProvinceID, NationID),
    CONSTRAINT FK_Border_Province FOREIGN KEY (ProvinceID) REFERENCES Province(ProvinceID)
);
CREATE TABLE Neighbor (
    ProvinceID VARCHAR(20) NOT NULL,
    NeighborID VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Neighbor PRIMARY KEY (ProvinceID, NeighborID),
    CONSTRAINT FK_Neighbor_Province FOREIGN KEY (ProvinceID) REFERENCES Province(ProvinceID),
    CONSTRAINT FK_Neighbor_Province_Neighbor FOREIGN KEY (NeighborID) REFERENCES Province(ProvinceID)
);
