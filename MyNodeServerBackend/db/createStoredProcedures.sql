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
--		addFriend
--		removeFriend
--		getFriends
--
-- File Management:
--		ls(parentDir fullpath) RETURNS TABLE(itemPath fullpath)
--		touch
--		mkdir
--		rm
--		rm-r
--		chmod
--
-- Forum Management:
--		createCategory(cname title, uname TEXT, pathOfLogo TEXT) RETURNS VOID
--		createThread(tname title, uname TEXT, threadCategory title, textBody TEXT) RETURNS VOID
--		createThreadComment(uname TEXT, threadName title, userText TEXT) RETURNS VOID
--		createDirComment
--		createFileComment
--		getAllCategories() RETURNS TABLE(title title, Username username, timeofCreation TIMESTAMP)
--		getThreadsInCategory(categoryName title) RETURNS TABLE(Title title, Username username, timeofCreation TIMESTAMP)
--		getThreadComments
--		getDirComments
--		getFileComments
--
-- Created by Wesley Van Pelt on 2016-05-06
-- Last modified by Wesley Van Pelt on 2016-05-09
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

-- addFriend

-- removeFriend

-- getFriends

--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- File Management --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- Get all files/subdirs in a dir
CREATE OR REPLACE FUNCTION ls(parentDir fullpath) RETURNS TABLE(itemPath fullpath) AS $$
	BEGIN
		RETURN QUERY (SELECT DPath AS itemPath INTO dirs FROM Directory WHERE ParentPath=parentDir)
					UNION (SELECT FPath AS itemPath INTO dirs FROM File WHERE ParentPath=parentDir);
	END; $$ LANGUAGE plpgsql;

-- touch

-- mkdir

-- rm

-- rm-r

-- chmod

--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- Forum Management -------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- Create category
CREATE OR REPLACE FUNCTION createCategory(cname title, uname TEXT, pathOfLogo TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO Category values(cname, uname, current_timestamp, pathOfLogo);
	END; $$ LANGUAGE plpgsql;

-- Get all categories
CREATE OR REPLACE FUNCTION getAllCategories() RETURNS TABLE(title title, Username username, timeofCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT c.CTitle AS title, c.Username, c.TimeOfCreation FROM Category c;
	END; $$ LANGUAGE plpgsql;

-- Create thread
CREATE OR REPLACE FUNCTION createThread(tname title, uname TEXT, threadCategory title, textBody TEXT) RETURNS VOID AS $$
	BEGIN
	INSERT INTO Thread values(tname, uname, threadCategory, current_timestamp, textBody);
	END; $$ LANGUAGE plpgsql;

-- createDirComment

-- createFileComment

-- Get all threads in a category
CREATE OR REPLACE FUNCTION getThreadsInCategory(categoryName title) RETURNS TABLE(Title title, Username username, timeofCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT t.TTitle as Title, t.Username, t.TimeOfCreation FROM Thread t WHERE CTitle=categoryName;
	END; $$ LANGUAGE plpgsql;

-- Create thread comment
CREATE OR REPLACE FUNCTION createThreadComment(uname TEXT, threadName title, userText TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO ThreadComment values(uname, current_timestamp, threadName, userText);
	END; $$ LANGUAGE plpgsql;

-- getThreadComments

-- getDirComments

-- getFileComments
