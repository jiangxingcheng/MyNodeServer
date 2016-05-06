CREATE DOMAIN username VARCHAR(16) NOT NULL;
-- name was renamed to title
CREATE DOMAIN title VARCHAR(64) NOT NULL;
--path was renamed to fullpath
CREATE DOMAIN fullpath TEXT NOT NULL;

CREATE TYPE permissionLevel AS ENUM('r', 'w', 'rw');
create TYPE userLevel as ENUM('Admin', 'Mod', 'User');
--CREATE TYPE path must be implemented

------------ Create Tables ------------
CREATE TABLE UserAccount(
Username username CHECK(LENGTH(Username) > 1),
Password VARCHAR(32) CHECK(LENGTH(Password) > 7),
Salt text, --Would be not null, but that makes static data hard...
UserLevel userLevel NOT NULL,
LastAccessDate TIMESTAMP NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
PRIMARY KEY(Username)
);

CREATE TABLE Friends(
Username1 username NOT NULL,
Username2 username NOT NULL,
PRIMARY KEY(Username1, Username2),
FOREIGN KEY(Username1) REFERENCES UserAccount(Username),
FOREIGN KEY(Username2) REFERENCES UserAccount(Username)
);
------ Forum Tables ------
CREATE TABLE Directory(
DPath fullpath NOT NULL,
ParentPath fullpath,
Username username,
PRIMARY KEY(DPath),
FOREIGN KEY(Username) REFERENCES UserAccount(Username)
);
CREATE TABLE UserPermitsDirectory(
Username username NOT NULL,
DPath fullpath NOT NULL,
PermissionLevel permissionLevel NOT NULL,
PRIMARY KEY(Username, DPath),
FOREIGN KEY(Username) REFERENCES UserAccount(Username),
FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);
CREATE TABLE File(
FPath fullpath NOT NULL,
ParentPath fullpath,
Username username,
PRIMARY KEY(FPath),
FOREIGN KEY(Username) REFERENCES UserAccount(Username)
);
CREATE TABLE UserPermitsFile(
Username username NOT NULL,
FPath fullpath NOT NULL,
PermissionLevel permissionLevel NOT NULL,
PRIMARY KEY(Username, FPath),
FOREIGN KEY(Username) REFERENCES UserAccount(Username),
FOREIGN KEY(FPath) REFERENCES File(FPath)
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
FOREIGN KEY(Username) REFERENCES UserAccount(Username)
);
CREATE TABLE Comment(
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
Text text NOT NULL CHECK(LENGTH(text) > 0),
PRIMARY KEY(Username, TimeOfCreation),
FOREIGN KEY(Username) REFERENCES UserAccount(Username)
);
CREATE TABLE CategoryHasThread(
CTitle title NOT NULL,
TTitle title NOT NULL,
PRIMARY KEY(CTitle,TTitle),
FOREIGN KEY(CTitle) REFERENCES Category(Title),
FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);
CREATE TABLE ThreadComment(
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
TTitle title NOT NULL,
Text text NOT NULL CHECK(LENGTH(text) > 0),
PRIMARY KEY(Username, TimeOfCreation),
FOREIGN KEY(Username) REFERENCES UserAccount(Username),
FOREIGN KEY(TTitle) REFERENCES Thread(Title)
);
CREATE TABLE DirectoryComment(
Username username NOT NULL,
TimeOfCreation TIMESTAMP NOT NULL,
DPath fullpath NOT NULL,
PRIMARY KEY(Username, TimeOfCreation),
FOREIGN KEY(DPath) REFERENCES Directory(DPath)
);
