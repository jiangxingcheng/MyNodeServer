-- This file contains all of the functions to be created, only these should be used when interacting with the database.
-- It contains the following:
--
-- User Management:
--		createUser(uname TEXT, upassword TEXT) RETURNS VOID
--		loginUser(uname TEXT, upassword TEXT) RETURNS TEXT
--		userCount() RETURNS bigint
--		getAllUsers() RETURNS TABLE(Username username, UserLevel VARCHAR(1), LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP)
--		findUser(uname TEXT) RETURNS TABLE(Username username, UserLevel VARCHAR(1), LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP)
--		removeUser(uname TEXT) RETURNS VOID
--		setUserLevel(uname TEXT, newLevel VARCHAR(1)) RETURNS VOID
--		addFriend(uname1 TEXT, uname2 TEXT) RETURNS VOID
--		removeFriend(uname1 TEXT, uname2 TEXT) RETURNS VOID
--		getFriends(uname TEXT) RETURNS TABLE(Username username)
--
-- File Management:
--		ls
--		touch(filePath fullpath, parentDir fullpath, creatorUsername TEXT) RETURNS VOID
--		mkdir(dirPath fullpath, parentDir fullpath, creatorUsername TEXT) RETURNS VOID
--		rm(filePath fullpath) RETURNS VOID
--		rm_r(dirPath fullpath) RETURNS VOID
--		chmod
--
-- Forum Management:
--		createCategory(cname title, uname TEXT, pathOfLogo TEXT) RETURNS VOID
--		createThread(tname title, uname TEXT, threadCategory title, textBody TEXT) RETURNS VOID
--		createThreadComment(uname TEXT, threadName title, userText TEXT) RETURNS VOID
--		createDirComment(uname TEXT, dPath fullpath, userText TEXT) RETURNS VOID
--		createFileComment(uname TEXT, fPath fullpath, userText TEXT) RETURNS VOID
--		getAllCategories() RETURNS TABLE(title title, Username username, timeofCreation TIMESTAMP)
--		getThreadsInCategory(categoryName title) RETURNS TABLE(Title title, Username username, timeofCreation TIMESTAMP)
--		getThreadComments(threadName title) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT)
--		getDirComments(dirPath fullpath) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT)
--		getFileComments(filePath fullpath) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT)
--
-- Created by Wesley Van Pelt on 2016-05-06
-- Last modified by Wesley Van Pelt on 2016-05-11
--
--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- User Management --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- Takes the new username and password to salt and hash the password
CREATE OR REPLACE FUNCTION createUser(uname TEXT, upassword TEXT) RETURNS VOID AS $$
	DECLARE salt TEXT;
	DECLARE hashed TEXT;
	BEGIN
		SELECT gen_salt('md5') INTO salt;
		SELECT crypt(upassword, salt) INTO hashed;
		INSERT INTO UserAccount values(uname, hashed, salt, 'U', current_timestamp, current_timestamp);
	END; $$ LANGUAGE plpgsql;

-- Verifies username and password
CREATE OR REPLACE FUNCTION loginUser(uname TEXT, upassword TEXT) RETURNS TEXT AS $$
	DECLARE readSalt TEXT;
	DECLARE readPass TEXT;
	DECLARE level TEXT;
	BEGIN
		SELECT salt INTO readSalt FROM UserAccount WHERE username = uname;
		SELECT password INTO readPass FROM UserAccount WHERE username = uname;
		IF readPass = crypt(upassword, readSalt) THEN
			UPDATE UserAccount SET LastAccessDate = current_timestamp WHERE username = uname;
			SELECT userLevel INTO level FROM UserAccount WHERE username = uname;
			RETURN 'Login Success: ' || level;
		END IF;
		RETURN 'Login Failure';
	END; $$ LANGUAGE plpgsql;

-- Was originally here just to try making a function, but maybe we could use it?
CREATE OR REPLACE FUNCTION userCount() RETURNS bigint AS $$
	DECLARE thing INT;
	BEGIN
		SELECT COUNT(*) INTO thing FROM UserAccount;
		RETURN thing;
	END; $$ LANGUAGE plpgsql;

-- Get all users
CREATE OR REPLACE FUNCTION getAllUsers() RETURNS TABLE(Username username, UserLevel VARCHAR(1), LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation from UserAccount ua;
	END; $$ LANGUAGE plpgsql;

-- Find a user by thier username
CREATE OR REPLACE FUNCTION findUser(uname TEXT) RETURNS TABLE(Username username, UserLevel VARCHAR(1), LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation FROM UserAccount AS ua WHERE ua.Username=uname;
	END; $$ LANGUAGE plpgsql;

-- Remove user and all their shit
CREATE OR REPLACE FUNCTION removeUser(uname TEXT) RETURNS VOID AS $$
	BEGIN
		DELETE FROM UserAccount WHERE username=uname;
	END; $$ LANGUAGE plpgsql;

-- Change user permission level
CREATE OR REPLACE FUNCTION setUserLevel(uname TEXT, newLevel VARCHAR(1)) RETURNS VOID AS $$
	BEGIN
		UPDATE UserAccount SET UserLevel = newLevel WHERE username = uname;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION addFriend(uname1 TEXT, uname2 TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO Friends values(uname1, uname2);
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION removeFriend(uname1 TEXT, uname2 TEXT) RETURNS VOID AS $$
	BEGIN
		DELETE FROM Friends f WHERE f.Username1=uname1 AND f.Username2=uname2;
		DELETE FROM Friends f WHERE f.Username1=uname2 AND f.Username2=uname1;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getFriends(uname TEXT) RETURNS TABLE(Username username) AS $$
	BEGIN
		RETURN QUERY (SELECT f.Username2 AS Username FROM Friends f WHERE f.Username1=uname)
					UNION (SELECT f.Username1 AS Username FROM Friends f WHERE f.Username2=uname);
	END; $$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- File Management --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- -- Get all files/subdirs in a dir
-- CREATE OR REPLACE FUNCTION ls(parentDir fullpath, uname TEXT) RETURNS TABLE(itemPath fullpath) AS $$
-- 	BEGIN
-- 		RETURN QUERY (SELECT DPath AS itemPath FROM Directory WHERE ParentPath=parentDir)
-- 					UNION (SELECT FPath AS itemPath FROM File WHERE ParentPath=parentDir);
-- 	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION touch(filePath fullpath, parentDir fullpath, creatorUsername TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO File values(filePath, parentDir, creatorUsername, current_timestamp);
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION mkdir(dirPath fullpath, parentDir fullpath, creatorUsername username) RETURNS VOID AS $$
	BEGIN
		INSERT INTO Directory values(dirPath, parentDir, creatorUsername, current_timestamp);
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rm(filePath fullpath) RETURNS VOID AS $$
	BEGIN
		DELETE FROM File f WHERE f.FPath=filePath;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rm_r(dirPath fullpath) RETURNS VOID AS $$
	BEGIN
		DELETE FROM File f WHERE f.ParentPath=dirPath;
		DELETE FROM Directory d WHERE d.DPath=dirPath;
	END; $$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION chmod(args VARCHAR(3), thingPath fullpath) RETURNS VOID AS $$
-- 	BEGIN
-- 		CASE args
-- 			WHEN '+r' THEN
-- 			WHEN '-r' THEN
-- 			WHEN '+w' THEN
-- 			WHEN '-w' THEN
-- 			WHEN '+rw' THEN
-- 			WHEN '-rw' THEN
-- 		END CASE;
-- 	END; $$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- Forum Management -------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- Create category
CREATE OR REPLACE FUNCTION createCategory(cname title, uname TEXT, pathOfLogo TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO Category values(cname, uname, current_timestamp, pathOfLogo);
	END; $$ LANGUAGE plpgsql;

-- Create thread
CREATE OR REPLACE FUNCTION createThread(tname title, uname TEXT, threadCategory title, textBody TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO Thread values(tname, uname, threadCategory, current_timestamp, textBody);
	END; $$ LANGUAGE plpgsql;

-- Create thread comment
CREATE OR REPLACE FUNCTION createThreadComment(uname TEXT, threadName title, userText TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO ThreadComment values(uname, current_timestamp, threadName, userText);
	END; $$ LANGUAGE plpgsql;

-- createDirComment
CREATE OR REPLACE FUNCTION createDirComment(uname TEXT, dPath fullpath, userText TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO DirectoryComment values(uname, current_timestamp, dPath, userText);
	END; $$ LANGUAGE plpgsql;

-- createFileComment
CREATE OR REPLACE FUNCTION createFileComment(uname TEXT, fPath fullpath, userText TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO FileComment values(uname, current_timestamp, fPath, userText);
	END; $$ LANGUAGE plpgsql;

-- Get all categories
CREATE OR REPLACE FUNCTION getAllCategories() RETURNS TABLE(title title, Username username, timeofCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT c.CTitle AS title, c.Username, c.TimeOfCreation FROM Category c;
	END; $$ LANGUAGE plpgsql;

-- Get all threads in a category
CREATE OR REPLACE FUNCTION getThreadsInCategory(categoryName title) RETURNS TABLE(Title title, Username username, timeofCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT t.TTitle as Title, t.Username, t.TimeOfCreation FROM Thread t WHERE CTitle=categoryName;
	END; $$ LANGUAGE plpgsql;

-- getThreadComments
CREATE OR REPLACE FUNCTION getThreadComments(threadName title) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT) AS $$
	BEGIN
		RETURN QUERY SELECT tc.Username, tc.TimeOfCreation, tc.userText AS Body FROM ThreadComment tc WHERE tc.TTitle=threadName;
	END; $$ LANGUAGE plpgsql;

-- getDirComments
CREATE OR REPLACE FUNCTION getDirComments(dirPath fullpath) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT) AS $$
	BEGIN
		RETURN QUERY SELECT dc.Username, dc.TimeOfCreation, dc.userText AS Body FROM DirectoryComment dc WHERE dc.DPath=dirPath;
	END; $$ LANGUAGE plpgsql;

-- getFileComments
CREATE OR REPLACE FUNCTION getFileComments(filePath fullpath) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT) AS $$
	BEGIN
		RETURN QUERY SELECT fc.Username, fc.TimeOfCreation, fc.userText AS Body FROM FileComment fc WHERE fc.FPath=filePath;
	END; $$ LANGUAGE plpgsql;
