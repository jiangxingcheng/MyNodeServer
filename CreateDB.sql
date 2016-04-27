-- Script to create all of the required stuff for MyNodeServer
--
-- Created by Wesley Van Pelt on 25 April 2016
-- Last modified by Zachary Schafer on 27 April 2016


------------ Create Data Types ------------
-- As it turns out these should be domains in postgres not types
CREATE DOMAIN username VARCHAR(16) NOT NULL;
CREATE DOMAIN title VARCHAR(64) NOT NULL;
CREATE DOMAIN fullpath TEXT NOT NULL;
CREATE TYPE permissionLevel AS ENUM('r', 'w', 'rw');
create TYPE userLevel as ENUM('Admin', 'Mod', 'User');
--CREATE TYPE path must be implemented

------------ Create Tables ------------
--User is a reserved word so we must another
--CREATE TABLE User(
CREATE TABLE User_account(
        --LEN changed to LENGTH
	Username username CHECK(LENGTH(Username) > 1),
	Password VARCHAR(32) CHECK(LENGTH(Password) > 7),
	UserLevel userLevel NOT NULL,
	LastAccessDate TIMESTAMP NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Username)
);

------ File System Tables ------
CREATE TABLE Directory(
	DPath fullpath NOT NULL,
	PRIMARY KEY(DPath)
);

CREATE TABLE File(
	FPath fullpath NOT NULL,
	PRIMARY KEY(FPath)
);

CREATE TABLE DirectoryContainsFile(
	DPath fullpath,
	FPath fullpath,
	PRIMARY KEY(DPath, FPath),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);

CREATE TABLE UserPermitsDirectory(
	Username username,
	DPath fullpath,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, DPath),
	FOREIGN KEY(Username) REFERENCES User(Username),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE UserPermitsFile(
	Username username,
	FPath fullpath,
	PermissionLevel permissionLevel NOT NULL,
	PRIMARY KEY(Username, FPath),
	FOREIGN KEY(Username) REFERENCES User(Username),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);

------ Forum Tables ------
CREATE TABLE Category(
	Title title NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Title)
);

CREATE TABLE Thread(
	Title title NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	PRIMARY KEY(Title)
);

CREATE TABLE Comment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	Text text NOT NULL CHECK(LENGTH(text) > 0),
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES User_account(Username)
);

CREATE TABLE ThreadHasCategory(
	CTitle title NOT NULL,
	TTitle title NOT NULL,
	PRIMARY KEY(CTitle, TTitle),
	FOREIGN KEY(CTitle) REFERENCES Category(Title),
	FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);

CREATE TABLE ThreadComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	TTitle title NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
        --Changed this foreign key to thread's title instead of username because
	--FOREIGN KEY(Username) REFERENCES Thread(Username),
        --Username should reference a user_account's username
        FOREIGN KEY(Username) REFERENCES User_account(Username),
	FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);

CREATE TABLE DirectoryComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	DPath fullpath NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES Thread(Username),
	FOREIGN KEY(TimeOfCreation) REFERENCES Thread(TimeOfCreation),
	FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);

CREATE TABLE FileComment(
	Username username NOT NULL,
	TimeOfCreation TIMESTAMP NOT NULL,
	FPath fullpath NOT NULL,
	PRIMARY KEY(Username, TimeOfCreation),
	FOREIGN KEY(Username) REFERENCES Thread(Username),
	FOREIGN KEY(TimeOfCreation) REFERENCES Thread(TimeOfCreation),
	FOREIGN KEY(FPath) REFERENCES File(FPath)
);
