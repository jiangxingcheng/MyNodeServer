CREATE DOMAIN username TEXT NOT NULL;
CREATE DOMAIN title VARCHAR(64) NOT NULL;
CREATE DOMAIN fullpath TEXT NOT NULL;

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

CREATE TABLE Directory(
	DPath fullpath NOT NULL,
	ParentPath fullpath,
	Username username,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(DPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE
);

CREATE TABLE File(
	FPath fullpath NOT NULL,
	ParentPath fullpath,
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE
);

CREATE TABLE UserPermitsDirectory(
	Username username NOT NULL,
	DPath fullpath NOT NULL,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, DPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE UserPermitsFile(
	Username username NOT NULL,
	FPath fullpath NOT NULL,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);

------ Forum Tables ------
CREATE TABLE Category(
	CTitle title NOT NULL,
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	LogoPath TEXT,
	PRIMARY KEY(CTitle),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE
);

CREATE TABLE Thread(
	TTitle title NOT NULL,
	Username username NOT NULL,
	CTitle title NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	Body TEXT,
	PRIMARY KEY(TTitle),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(CTitle) REFERENCES Category(CTitle)
);

CREATE TABLE ThreadComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	TTitle title NOT NULL,
	Text text NOT NULL CHECK(LENGTH(text) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(TTitle) REFERENCES Thread(TTitle)
);

CREATE TABLE DirectoryComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	DPath fullpath NOT NULL,
	Text text NOT NULL CHECK(LENGTH(text) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE FileComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	FPath fullpath NOT NULL,
	Text text NOT NULL CHECK(LENGTH(text) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username) ON DELETE CASCADE,
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);
