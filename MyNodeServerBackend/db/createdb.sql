CREATE DOMAIN username VARCHAR(16) NOT NULL;
--name and path must be renamed
--CREATE DOMAIN name VARCHAR(64) NOT NULL;
--CREATE DOMAIN path TEXT NOT NULL;
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
