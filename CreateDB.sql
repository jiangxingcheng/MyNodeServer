-- Script to create all of the required stuff for MyNodeServer
--
-- Created by Wesley Van Pelt on 25 April 2016
-- Last modified by Wesley Van Pelt on 25 April 2016


------------ Create Data Types ------------
CREATE TYPE username FROM VARCHAR(16) NOT NULL;
CREATE TYPE name FROM VARCHAR(64) NOT NULL;
CREATE TYPE path FROM TEXT NOT NULL;
CREATE TYPE permissionLevel FROM ENUM('r', 'w', 'rw');


------------ Create Tables ------------
CREATE TABLE User(
	Username username CHECK(LEN(Username) > 1),
	Password VARCHAR(32) CHECK(LEN(Password) > 7),
	UserLevel ENUM('Admin', 'Mod', 'User') NOT NULL,
	LastAccessDate TIMESTAMP NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Username)
);

------ File System Tables ------
CREATE TABLE Directory(
	DPath path NOT NULL,
	PRIMARY KEY(DPath)
);

CREATE TABLE File(
	FPath path NOT NULL,
	PRIMARY KEY(FPath)
);

CREATE TABLE DirectoryContainsFile(
	DPath path,
	FPath path,
	PRIMARY KEY(DPath, FPath),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);

CREATE TABLE UserPermitsDirectory(
	Username username,
	DPath path,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, DPath),
	FOREIGN KEY(Username) REFERENCES User(Username),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE UserPermitsFile(
	Username username,
	FPath path,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, FPath),
	FOREIGN KEY(Username) REFERENCES User(Username),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);

------ Forum Tables ------
CREATE TABLE Category(
	Title name NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Title)
);

CREATE TABLE Thread(
	Title name NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Title)
);

CREATE TABLE Comment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	Text text NOT NULL CHECK(LEN(text) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES User(Username)
);

CREATE TABLE ThreadHasCategory(
	CTitle name NOT NULL,
	TTitle name NOT NULL,
	PRIMARY KEY(CTitle, TTitle),
	FOREIGN KEY(CTitle) REFERENCES Category(Title),
	FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);

CREATE TABLE ThreadComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	TTitle name NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES Thread(Username),
	FOREIGN KEY(TimeOfCreation) REFERENCES Thread(TimeOfCreation),
	FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);

CREATE TABLE DirectoryComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	DPath path NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES Thread(Username),
	FOREIGN KEY(TimeOfCreation) REFERENCES Thread(TimeOfCreation),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE FileComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	FPath path NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES Thread(Username),
	FOREIGN KEY(TimeOfCreation) REFERENCES Thread(TimeOfCreation),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);
