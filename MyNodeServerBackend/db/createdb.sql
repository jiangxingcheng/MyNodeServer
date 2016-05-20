CREATE DOMAIN username TEXT NOT NULL;
CREATE DOMAIN title VARCHAR(64) NOT NULL;

--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- User Stuff ----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE UserAccount(
	Username username CHECK(LENGTH(Username) > 2),
	Password TEXT CHECK(LENGTH(Password) > 7),
	Salt TEXT NOT NULL,
	UserLevel VARCHAR(1) NOT NULL,
	LastAccessDate TIMESTAMP NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Username));


CREATE TABLE UserSessions(
	SessionID TEXT NOT NULL,
	Username username NOT NULL,
	ActiveTime TIMESTAMP NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(SessionID),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username));


CREATE TABLE Friends(
	Username1 username NOT NULL,
	Username2 username NOT NULL,
	PRIMARY KEY(Username1, Username2),
	FOREIGN KEY(Username1) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(Username2) REFERENCES UserAccount(Username) ON DELETE CASCADE);


--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------- File Stuff ----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE File(
	FPath VARCHAR(255)[] NOT NULL,
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	IsDir BOOLEAN,
	PRIMARY KEY(FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE);
CREATE INDEX ON File (Username);


CREATE TABLE UserPermissionsOnFile(
	Username username NOT NULL,
	FPath VARCHAR(255)[] NOT NULL,
	ReadAllowed BOOLEAN NOT NULL,
	WriteAllowed BOOLEAN NOT NULL,
	PRIMARY KEY(Username, FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(FPath) REFERENCES File(FPath));


--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- Forum Stuff ----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Category(
	CTitle title NOT NULL,
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	LogoPath TEXT,
	PRIMARY KEY(CTitle),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE);


CREATE TABLE Thread(
	TTitle title NOT NULL,
	Username username NOT NULL,
	CTitle title NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	Body TEXT,
	PRIMARY KEY(TTitle),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(CTitle) REFERENCES Category(CTitle));
CREATE INDEX ON Thread (Username);
CREATE INDEX ON Thread (CTitle);
CREATE INDEX ON Thread (TimeOfCreation);


CREATE TABLE ThreadComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	TTitle title NOT NULL,
	userText TEXT NOT NULL CHECK(LENGTH(userText) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(TTitle) REFERENCES Thread(TTitle));
CREATE INDEX ON ThreadComment (TTitle);


CREATE TABLE FileComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	FPath VARCHAR(255)[] NOT NULL,
	userText TEXT NOT NULL CHECK(LENGTH(userText) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(FPath) REFERENCES File(FPath));
CREATE INDEX ON FileComment (FPath);
