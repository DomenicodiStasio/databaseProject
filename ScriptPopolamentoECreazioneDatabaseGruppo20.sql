DROP TABLE IF EXISTS Sinistro CASCADE;
DROP TABLE IF EXISTS Aeromobile CASCADE;
DROP TABLE IF EXISTS Volo CASCADE;
DROP TABLE IF EXISTS CondizioneMeteo CASCADE;
DROP TABLE IF EXISTS Detrito CASCADE;
DROP TABLE IF EXISTS Pilota CASCADE;
DROP TABLE IF EXISTS EsperienzaDiVolo CASCADE;
DROP TABLE IF EXISTS SegnoParticolare CASCADE;
DROP TABLE IF EXISTS RegistroDiManutenzione CASCADE;
DROP TABLE IF EXISTS Costruttore CASCADE;
DROP TABLE IF EXISTS Stabilimento CASCADE;
DROP TABLE IF EXISTS A3 CASCADE;
DROP TABLE IF EXISTS A5 CASCADE;
DROP TABLE IF EXISTS Avvenimento CASCADE;
DROP TABLE IF EXISTS Conduzione CASCADE;
DROP TABLE IF EXISTS Serie CASCADE;

CREATE TABLE Sinistro (
	DenominazioneIncidente varchar(30) PRIMARY KEY, 
	DistanzaDalRiferimento decimal(6,2) NOT NULL,
	Fase varchar(30) NOT NULL,
	Navigazione varchar(20) NOT NULL,
	FormaIncidente varchar(50) NOT NULL,
	Ora time NOT NULL,
	Data date NOT NULL,
	NumeroDiVittime integer NOT NULL,
	RitrovamentoScatoleNere boolean NOT NULL,
	LocalitaDiRiferimento varchar(30) NOT NULL
);

CREATE TABLE Costruttore (
	CodiceCostruttore varchar(30) PRIMARY KEY, 
	Nome varchar(30) NOT NULL,
	RecapitoTelefonico char(13) NOT NULL
);


CREATE TABLE Serie(
	SerieId varchar(30) PRIMARY KEY,
	CapienzaMassimaPasseggeri integer NOT NULL,
	NumeroMotori integer NOT NULL,
	Tipologia varchar(30) NOT NULL
);

CREATE TABLE Aeromobile (
	CodiceAeromobile varchar(30) PRIMARY KEY, 
	ColoreFusoliera varchar(30) NOT NULL,
	Serie varchar(30),
	Costruttore varchar(30),
	CONSTRAINT fk_aeroserie FOREIGN KEY(Serie) REFERENCES Serie(SerieId) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_aerocostr FOREIGN KEY(Costruttore) REFERENCES Costruttore(CodiceCostruttore) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Volo (
	Id varchar(30) PRIMARY KEY,
	NumeroVolo varchar(10) NOT NULL,
	AeroportoDiPartenza varchar(30) NOT NULL,
	Data date NOT NULL,
	TipoVolo varchar(30) NOT NULL,
	AeroportoDiArrivo varchar(30) NOT NULL,
	NumeroDiPasseggeri integer NOT NULL,
	PostiLiberi integer NOT NULL,
	Ora time NOT NULL,
	UNIQUE(NumeroVolo, Data),
	Aeromobile varchar(30) REFERENCES Aeromobile(CodiceAeromobile) ON UPDATE CASCADE ON DELETE RESTRICT,
	Sinistro varchar(30) REFERENCES Sinistro(DenominazioneIncidente) ON UPDATE CASCADE ON DELETE RESTRICT,
	Scalo varchar(30)
);


CREATE TABLE CondizioneMeteo (
	Meteo varchar(30) PRIMARY KEY
);

CREATE TABLE Detrito (
	Id varchar(30) PRIMARY KEY, 
	CodiceDiIdentificazione varchar(30),
	NumeroTelaio varchar(30),
	LuogoDiRitrovamento varchar(40),
	Aeromobile varchar(30) REFERENCES Aeromobile(CodiceAeromobile) ON UPDATE CASCADE ON DELETE RESTRICT,
	Sinistro varchar(30) REFERENCES Sinistro(DenominazioneIncidente) ON UPDATE CASCADE ON DELETE RESTRICT,
	UNIQUE(CodiceDiIdentificazione)
);

CREATE TABLE Pilota (
	CodiceIdentificativo varchar(30) PRIMARY KEY,
	CodiceFiscale char(16),
	Nome varchar(30) NOT NULL,
	DataDiNascita date NOT NULL,
	OreDiVolo integer NOT NULL,
	Cognome varchar(30) NOT NULL,
	LuogoDiProvenienza varchar(30) NOT NULL,
	AnzianitaDiServizio integer NOT NULL,
	Grado varchar(20) NOT NULL,
	DataOttenimentoLicenza date,
	Cellulare char(13) NOT NULL,
	UNIQUE(CodiceFiscale),
	Constraint CheckGrado check(Grado='Primo ufficiale' or Grado='Comandante')
);

CREATE TABLE EsperienzaDiVolo (
	Esperienza varchar(50) PRIMARY KEY
);

CREATE TABLE SegnoParticolare (
	Id varchar(30) PRIMARY KEY,
	Segno varchar(50) NOT NULL,
	Detrito varchar(30) REFERENCES Detrito(Id) ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE RegistroDiManutenzione (
	CodiceManutenzione varchar(10) PRIMARY KEY, 
	NomeDittaDiManutenzione varchar(30) NOT NULL,
	Ora time NOT NULL,
	Luogo varchar(30) NOT NULL,
	Descrizione varchar(100) NOT NULL,
	Data date NOT NULL,
	Aeromobile varchar(30) REFERENCES Aeromobile(CodiceAeromobile) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Stabilimento (
	TipoStabilimento varchar(30), 
	SedeStabilimento varchar(30),
	Costruttore varchar(30) REFERENCES Costruttore(CodiceCostruttore),
	PRIMARY KEY(TipoStabilimento, SedeStabilimento)
);



CREATE TABLE A3 (
	Volo varchar(30) REFERENCES Volo(Id),
	CondizioneMeteo varchar(30) REFERENCES CondizioneMeteo(Meteo) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(Volo, CondizioneMeteo)
);

CREATE TABLE A5 (
	EsperienzaDiVolo varchar(50) REFERENCES EsperienzaDiVolo(Esperienza),
	Pilota varchar(30) REFERENCES Pilota(CodiceIdentificativo) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(EsperienzaDiVolo, Pilota)
);

CREATE TABLE Avvenimento(
	Sinistro varchar(30) REFERENCES Sinistro(DenominazioneIncidente) ON UPDATE CASCADE ON DELETE RESTRICT,
	Aeromobile varchar(30) REFERENCES Aeromobile(CodiceAeromobile) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(Sinistro, Aeromobile)
);

CREATE TABLE Conduzione(
	Volo varchar(30) REFERENCES Volo(Id) ON UPDATE CASCADE ON DELETE RESTRICT,
	Pilota varchar(30) REFERENCES Pilota(CodiceIdentificativo) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(Volo, Pilota)
);

INSERT INTO Sinistro(DenominazioneIncidente, DistanzaDalRiferimento, Fase, Navigazione, FormaIncidente, Ora, Data, NumeroDiVittime, RitrovamentoScatoleNere, LocalitaDiRiferimento) VALUES
('A123IT', 100.00, 'Decollo', 'Strumentale', 'Nei dintorni di una montagna', '12:00', '07/06/2021', 150, true, 'Gragnano'),
('B123IT', 152.30, 'Atterraggio', 'A vista', 'Nei dintorni dell''aeroporto', '21:30', '05/11/2021', 10, true, 'Milano'),
('C123IT', 125.00, 'Volo', 'Strumentale', 'Nei pressi del mar mediterraneo', '10:00', '22/05/2022', 25, false, 'Palermo'),
('D123IT', 1.00, 'Rullaggio', 'A vista', 'Nei dintorni dell''aeroporto', '7:00', '04/08/2020', 0, true, 'Napoli'),
('E123IT', 150.00, 'Volo', 'Strumentale', 'Nei pressi del mar mediterraneo', '10:00', '04/05/2019', 15, true, 'Palermo');

INSERT INTO Costruttore(CodiceCostruttore, Nome, RecapitoTelefonico) VALUES
('213409','ATR','+393457928048'),
('220700','Airbus','+393330338328'),
('240520','Boeing','+393660666664');

INSERT INTO Stabilimento(TipoStabilimento, SedeStabilimento, Costruttore) VALUES
('Montaggio','Milano','213409'),
('Produzione','Torino','220700'),
('Testing','Bologna','240520');

INSERT INTO Serie(SerieId, CapienzaMassimaPasseggeri, NumeroMotori, Tipologia) VALUES
('Beech 1900', 0,3, 'merci'),
('Boeing 737 ',350,4, 'linea'),
('Airbus A320',195,2, 'linea'),
('Airbus A300',200,4, 'linea'),
('ATR 42',0,2, 'merci');

INSERT INTO Aeromobile (CodiceAeromobile, ColoreFusoliera, Serie,Costruttore) VALUES
('123QW','rosso','Beech 1900','213409'),
('123ER','bianco', 'Boeing 737 ','240520'),
('123AZ','nero', 'Airbus A320','220700'),
('123IN','giallo', 'Airbus A300','220700'),
('123OO','arancione','ATR 42', '213409');

INSERT INTO Volo(Id, NumeroVolo, AeroportoDiPartenza, Data, TipoVolo, AeroportoDiArrivo, NumeroDiPasseggeri, PostiLiberi, Ora, Aeromobile, Sinistro,scalo) VALUES
('1', '10123', 'Bologna', '05/11/2021', 'linea', 'Milano', 300, 50, '15:00', '123ER', 'B123IT',''),
('2', '42123', 'Gragnano', '07/06/2021', 'linea', 'Bari', 150, 45,'9:30', '123AZ', 'A123IT',''),
('3', '22123', 'Palermo', '22/05/2022', 'linea', 'Napoli', 200, 150,'8:00', '123ER', 'C123IT',''),
('4', '55123', 'Roma', '22/05/2022', 'cargo', 'Palermo', 0, 0,'7:30', '123OO', 'C123IT',''),
('5', '75123', 'Firenze', '04/05/2019', 'cargo', 'New York', 0, 0,'5:30', '123QW', 'E123IT','Madrid');

INSERT INTO CondizioneMeteo(Meteo) VALUES
('Soleggiato'),
('Nuvoloso'),
('Pioggia'),
('Temporale'),
('Grandinata'),
('Ventoso');

INSERT INTO A3(Volo, CondizioneMeteo) VALUES
('1','Soleggiato'),
('1','Ventoso'),
('2','Soleggiato'),
('3','Temporale'),
('3','Pioggia'),
('4','Soleggiato'),
('5','Nuvoloso'),
('5','Grandinata');



INSERT INTO Pilota(codiceIdentificativo, codiceFiscale, nome, dataDiNascita, oreDiVolo, cognome, luogoDiProvenienza, anzianitaDiServizio, grado, dataOttenimentoLicenza,cellulare) VALUES
('AGSTR4', 'GLSGLC00M05L845Z', 'Gianluca', '05/08/2000', 400, 'Galasso', 'Gragnano',100,'Comandante', '12/06/2021','+393394567843'),
('MDTEF7', 'EGNBGC00M22L845Z', 'Eugenio',  '22/05/1998', 211, 'Bagno', 'Vico equense',43,'Comandante', '12/05/2021','+393345898880'),
('INGFD9', 'GVNCMA00L21L845Z', 'Giovanni', '22/08/1978', 554, 'Cuomo', 'Castellammare di stabia',54,'Primo ufficiale',NULL,'+393332123769'),
('POIEB8', 'RFLCST00Q12L845Z', 'Raffaele', '05/11/1981', 87,'Castellano', 'Castellammare di stabia',43,'Primo ufficiale', NULL,'+393390077666'),
('HDTEV2', 'DMNPLM00P07L845Z', 'Domenico', '05/12/1999', 98,'Palomba', 'Milano',66, 'Primo ufficiale', NULL,'+393312895343');

INSERT INTO RegistroDiManutenzione(CodiceManutenzione, NomeDittaDiManutenzione, Ora, Luogo, Descrizione, Data, Aeromobile) VALUES
('1A', 'AirServices', '10:30:00', 'Napoli', 'Riverniciatura fusoliera', '17/09/2021', '123QW'),
('2B', 'ProPlain', '12:06:00', 'Roma', 'Cambio motore destro', '08/11/2020', '123ER'),
('3C', 'MCplain', '08:25:00', 'Torino', 'Sostituzione ruote di atterraggio', '22/09/2021', '123AZ'),
('4S', 'FixAndFly', '05:45:00', 'Veneto', 'Manutenzione di ruotine', '08/09/2021', '123OO');

INSERT INTO Detrito (Id ,CodiceDiIdentificazione ,NumeroTelaio ,LuogoDiRitrovamento ,Aeromobile ,Sinistro ) VALUES
('1','az1','123','gragnano','123QW','A123IT'),
('2','az2','234','milano','123ER','B123IT'),
('3','az3','345','palermo','123AZ','C123IT'),
('4','az4','456','napoli','123IN','D123IT'),
('5','az5','567','palermo','123OO','E123IT');

INSERT INTO SegnoParticolare (id,Segno,Detrito)VALUES
('1','crepa',1),
('2','crepa',2),
('3','bruciatura',3),
('4','presenza di vernice di altri aeromobili',4),
('5','usura',5),
('6','bruciatura',5),
('7','bruciatura',5),
('8','bruciatura',5);

INSERT INTO EsperienzaDiVolo(Esperienza) VALUES 
('Boing'),
('Airbus'),
('Ryanair');

INSERT INTO A5(EsperienzaDiVolo, Pilota) VALUES
('Boing','AGSTR4'),
('Airbus','MDTEF7'),
('Airbus','AGSTR4'),
('Ryanair','INGFD9'),
('Ryanair','HDTEV2'),
('Ryanair','POIEB8');

INSERT INTO Avvenimento(Sinistro, Aeromobile) VALUES
('D123IT','123IN');

INSERT INTO Conduzione(Volo, Pilota) VALUES
('1','AGSTR4'),
('1','MDTEF7'),
('2','INGFD9'),
('2','POIEB8'),
('3','HDTEV2');
