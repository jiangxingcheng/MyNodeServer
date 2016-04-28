-- Script to create all of the required stuff for MyNodeServer
--
-- Created by Wesley Van Pelt on 25 April 2016
-- Last modified by Wesley Van Pelt on 28 April 2016


------------ Create Data Types ------------
-- As it turns out these should be domains in postgres not types
CREATE DOMAIN username VARCHAR(16) NOT NULL;
CREATE DOMAIN title VARCHAR(64) NOT NULL;
CREATE DOMAIN fullpath TEXT NOT NULL;
CREATE DOMAIN body TEXT NOT NULL;
CREATE TYPE permissionLevel AS ENUM('r', 'w', 'rw');
CREATE TYPE userLevel AS ENUM('Admin', 'Mod', 'User');

------------ Create Tables ------------
--User is a reserved word so we must use another
CREATE TABLE UserAccount(
	Username username CHECK(LENGTH(Username) > 1),
	Password VARCHAR(32) CHECK(LENGTH(Password) > 7),
	UserLevel userLevel NOT NULL,
	LastAccessDate TIMESTAMP NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Username)
);

CREATE TABLE Friends(
	Username1 username NOT NULL,
	Username2 username NOT NULL,
	PRIMARY KEY(Username1, Username2),
	FOREIGN KEY(Username1) REFERENCES UserAccount(Username1),
	FOREIGN KEY(Username2) REFERENCES UserAccount(Username2)
);

------ File System Tables ------
CREATE TABLE Directory(
	DPath fullpath NOT NULL,
	ParentPath fullpath,
	Username username,
	PRIMARY KEY(DPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username),
);

CREATE TABLE File(
	FPath fullpath NOT NULL,
	ParentPath fullpath,
	Username username,
	PRIMARY KEY(FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username),
);

CREATE TABLE UserPermitsDirectory(
	Username username NOT NULL,
	DPath fullpath NOT NULL,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, DPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE UserPermitsFile(
	Username username NOT NULL,
	FPath fullpath NOT NULL,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, FPath),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);

------ Forum Tables ------
CREATE TABLE Category(
	CTitle title NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	Username username,
	PRIMARY KEY(Title),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username)
);

CREATE TABLE Thread(
	TTitle title NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	Username username,
	PRIMARY KEY(Title),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username)
);

CREATE TABLE ThreadCategory(
	CTitle title NOT NULL,
	TTitle title NOT NULL,
	PRIMARY KEY(CTitle, TTitle),
	FOREIGN KEY(CTitle) REFERENCES Category(CTitle),
	FOREIGN KEY(TTitle) REFERENCES Thread(TTitle)
);

CREATE TABLE ThreadComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	TTitle title NOT NULL,
	Body body NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username),
	FOREIGN KEY(TTitle) REFERENCES Thread(TTitle)
);

CREATE TABLE DirectoryComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	DPath fullpath NOT NULL,
	Body body NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE FileComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	FPath fullpath NOT NULL,
	Body body NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES UserAccount(Username),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);
