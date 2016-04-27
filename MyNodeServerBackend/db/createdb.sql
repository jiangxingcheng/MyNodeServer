CREATE DOMAIN username VARCHAR(16) NOT NULL;
-- name was renamed to title
CREATE DOMAIN title VARCHAR(64) NOT NULL;
--path was renamed to fullpath
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

------ Forum Tables ------
CREATE TABLE Directory(
DPath fullpath NOT NULL,
PRIMARY KEY(DPath)
);

CREATE TABLE File(
FPath fullpath NOT NULL,
PRIMARY KEY(FPath)
);
CREATE TABLE Category(
Title title NOT NULL,
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
PRIMARY KEY(Title)
);
CREATE TABLE Thread(
Title title NOT NULL,
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
PRIMARY KEY(Title),
FOREIGN KEY(Username) REFERENCES User_account(Username)
);
CREATE TABLE Comment(
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
Text text NOT NULL CHECK(LENGTH(text) > 0),
PRIMARY KEY(Username, TimeOfCreation),
FOREIGN KEY(Username) REFERENCES User_account(Username)
);
CREATE TABLE ThreadHasCategory(
TTitle title NOT NULL,
CTitle title NOT NULL,
PRIMARY KEY(CTitle,TTitle),
FOREIGN KEY(CTitle) REFERENCES Category(Title),
FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);
CREATE TABLE ThreadComment(
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
TTitle title NOT NULL,
PRIMARY KEY(Username, TimeOfCreation),
FOREIGN KEY(Username) REFERENCES User_account(Username),
FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);
CREATE TABLE DirectoryComment(
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
DPath fullpath NOT NULL,
PRIMARY KEY(Username, TimeOfCreation),
FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);
