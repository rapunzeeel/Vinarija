CREATE TABLE Vinarija(
    idvi Integer NOT NULL,
    imevi varchar(30) NOT NULL,
    adrvi varchar(30),
    vlvi  varchar(30),
    
    CONSTRAINT Vinarija_PK PRIMARY KEY (idvi),
    CONSTRAINT Vinarija_UK UNIQUE (imevi)
);

CREATE TABLE Vino(
    idv Integer NOT NULL,
    idvin Integer NOT NULL,
    nazv varchar(30) NOT NULL,
    vrv varchar(10) NOT NULL,
    podvr varchar(30) NOT NULL, 
    godv Integer NOT NULL,
    kis decimal(5,2),
     
    CONSTRAINT Vino_PK PRIMARY KEY (idv, idvin),
    CONSTRAINT Vino_UK UNIQUE (nazv)
);

CREATE TABLE Radnik(
    jmbgr varchar(13) NOT NULL, 
    imer varchar(20) NOT NULL,
    przr varchar(20) NOT NULL,
    adrr varchar(30),
    plt decimal(10,2),
    tipr varchar(30),
    
    CONSTRAINT Radnik_PK PRIMARY KEY (jmbgr),
    CONSTRAINT Radnik_CH CHECK (Plt>=1000)
    
);

CREATE TABLE vinrad(
    idvi Integer NOT NULL,
    jmbgr varchar(13) NOT NULL,
    
    CONSTRAINT vinrad_PK PRIMARY KEY (idvi, jmbgr),
    CONSTRAINT vinrad_vinarija_FK FOREIGN KEY (idvi) REFERENCES Vinarija(idvi),
    CONSTRAINT vinrad_radnik_FK FOREIGN KEY (jmbgr) REFERENCES Radnik(jmbgr)
);

CREATE TABLE vinvin(
    idv Integer NOT NULL,
    idvin Integer NOT NULL,
    idvi Integer NOT NULL,
    kol Integer, 
    
    CONSTRAINT vinvin_PK PRIMARY KEY (idv,idvin, idvi),
    CONSTRAINT vinvin_vino_FK FOREIGN KEY (idv, idvin) REFERENCES Vino(idv,idvin),
    CONSTRAINT vinvin_vinarija_FK FOREIGN KEY (idvi) REFERENCES Vinarija(idvi)
    
);