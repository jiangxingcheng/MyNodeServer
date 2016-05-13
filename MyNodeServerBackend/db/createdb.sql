CREATE DOMAIN username TEXT NOT NULL;
CREATE DOMAIN title VARCHAR(64) NOT NULL;

CREATE TYPE permissionLevel AS ENUM('r', 'w', 'rw');

------------ Create Tables ------------
CREATE TABLE UserAccount(
	Username username CHECK(LENGTH(Username) > 1 AND LENGTH(Username) < 17),
	Password TEXT CHECK(LENGTH(Password) > 7),
	Salt TEXT NOT NULL,
	UserLevel VARCHAR(1) NOT NULL,
	LastAccessDate TIMESTAMP NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Username)
);

CREATE TABLE Friends(
	Username1 username NOT NULL,
	Username2 username NOT NULL,
	PRIMARY KEY(Username1, Username2),
	FOREIGN KEY(Username1) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(Username2) REFERENCES UserAccount(Username) ON DELETE CASCADE
);

CREATE TABLE File(
	FPath VARCHAR(255)[] NOT NULL,
	Username username NOT NULL, --index this
	TimeOfCreation TIMESTAMP NOT NULL, --index this
	IsDir BOOLEAN,
	Name VARCHAR(255), -- Just here for speed improvement INDEX THIS
	PRIMARY KEY(FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE
);

CREATE TABLE UserPermitsFile(
	Username username NOT NULL,
	FPath VARCHAR(255)[] NOT NULL,
	PermissionLevel permissionLevel NOT NULL, --index this
	PRIMARY KEY(Username, FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);

CREATE TABLE Category(
	CTitle title NOT NULL,
	Username username NOT NULL, --index this
	TimeOfCreation TIMESTAMP NOT NULL, --index this
	LogoPath TEXT,
	PRIMARY KEY(CTitle),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE
);

CREATE TABLE Thread(
	TTitle title NOT NULL,
	Username username NOT NULL, --index this
	CTitle title NOT NULL, --index this
	TimeOfCreation TIMESTAMP NOT NULL, --index this
	Body TEXT,
	PRIMARY KEY(TTitle),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(CTitle) REFERENCES Category(CTitle)
);

CREATE TABLE ThreadComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	TTitle title NOT NULL, --index this
	Text text NOT NULL CHECK(LENGTH(text) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(TTitle) REFERENCES Thread(TTitle)
);

CREATE TABLE FileComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	FPath VARCHAR(255)[] NOT NULL, --index this
	Text text NOT NULL CHECK(LENGTH(text) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);
