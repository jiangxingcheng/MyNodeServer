--------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- Session Management -------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- For use by functions in this file
CREATE OR REPLACE FUNCTION createSession(session TEXT, uname TEXT) RETURNS VOID AS $$
	BEGIN
		INSERT INTO UserSessions VALUES(session, uname, current_timestamp, current_timestamp);
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getSessionUser(session TEXT) RETURNS TEXT AS $$
	DECLARE
		uname TEXT;
		uLvl VARCHAR(1);
		lastTime TIMESTAMP;
		currentTime TIMESTAMP;
		timeDiff REAL;
	BEGIN
		SELECT username INTO uname FROM UserSessions WHERE session=SessionID;
		IF uname IS NULL THEN
			RETURN 'X';
		END IF;
		SELECT ActiveTime INTO lastTime FROM UserSessions;
		SELECT current_timestamp INTO currentTime;
		SELECT EXTRACT(EPOCH FROM currentTime) - EXTRACT(EPOCH FROM lastTime) INTO timeDiff;
		IF timeDiff > 3600 THEN -- 3600 timeout is 1 hour
			DELETE FROM UserSessions WHERE session=SessionID;
			RETURN 'X';
		END IF;
		UPDATE UserSessions SET ActiveTime=current_timestamp;
		RETURN uname;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getSessionUserLevel(session TEXT) RETURNS VARCHAR(1) AS $$
	DECLARE
		uname TEXT;
		uLvl VARCHAR(1);
	BEGIN
		SELECT * INTO uname FROM getSessionUser(session);
		IF uname = 'X' THEN
			RETURN 'N';
		END IF;
		SELECT userLevel INTO uLvl FROM UserAccount WHERE uname=Username;
		RETURN uLvl;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION closeSession(session TEXT) RETURNS VOID AS $$
	BEGIN
		DELETE FROM UserSessions WHERE session=sessionID;
	END;

--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- User Management --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- Takes the new username and password to salt and hash the password
CREATE OR REPLACE FUNCTION createUser(uname TEXT, upassword TEXT) RETURNS VOID AS $$
	DECLARE
		salt TEXT;
		hashed TEXT;
	BEGIN
		IF CHAR_LENGTH(upassword) < 7 THEN
			RAISE EXCEPTION 'Password too short.' USING HINT = 'Must be at least 8 characters';
		END IF;
		SELECT gen_salt('md5') INTO salt;
		SELECT crypt(upassword, salt) INTO hashed;
		INSERT INTO UserAccount values(uname, hashed, salt, 'U', current_timestamp, current_timestamp);
		INSERT INTO File VALUES(ARRAY['home', uname], uname, current_timestamp, TRUE);
	END; $$ LANGUAGE plpgsql;

-- Verifies username and password
CREATE OR REPLACE FUNCTION loginUser(uname TEXT, upassword TEXT) RETURNS TEXT AS $$
	DECLARE
		readSalt TEXT;
		readPass TEXT;
		level TEXT;
		session TEXT;
	BEGIN
		SELECT salt INTO readSalt FROM UserAccount WHERE username = uname;
		SELECT password INTO readPass FROM UserAccount WHERE username = uname;
		IF readPass = crypt(upassword, readSalt) THEN
			UPDATE UserAccount SET LastAccessDate = current_timestamp WHERE username = uname;
			SELECT userLevel INTO level FROM UserAccount WHERE username = uname;
			SELECT crypt(current_timestamp || 'MS SQL SUCKS', gen_salt('md5')) INTO session;
			PERFORM createSession(session, uname);
			RETURN '{ loginStatus: "ok", userLevel: "' || level || '", sessionID: "' || session ||'" }';
		END IF;
		RETURN '{ loginStatus: "fail", userLevel: "", sessionID: "" }';
	END; $$ LANGUAGE plpgsql;

-- Was originally here just to try making a function, but maybe we could use it?
CREATE OR REPLACE FUNCTION userCount() RETURNS bigint AS $$
	DECLARE
		thing INT;
	BEGIN
		SELECT COUNT(*) INTO thing FROM UserAccount;
		RETURN thing;
	END; $$ LANGUAGE plpgsql;

-- Get all users
CREATE OR REPLACE FUNCTION getAllUsers(session TEXT) RETURNS TABLE(Username username, UserLevel VARCHAR(1), LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP) AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' THEN
			RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation FROM UserAccount ua;
		END IF;
		RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation FROM UserAccount ua WHERE ua.Username='fu'; --TODO: There should be a better way, but this works
	END; $$ LANGUAGE plpgsql;

-- Find a user by thier username
CREATE OR REPLACE FUNCTION findUser(uname TEXT, session TEXT) RETURNS TABLE(Username username, UserLevel VARCHAR(1), LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP) AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' THEN
			RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation FROM UserAccount ua WHERE ua.Username=uname;
		END IF;
		RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation FROM UserAccount ua WHERE ua.Username='fu';
	END; $$ LANGUAGE plpgsql;

-- Remove user and all their shit
CREATE OR REPLACE FUNCTION removeUser(uname TEXT, session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' THEN
			DELETE FROM UserAccount WHERE username=uname;
		END IF;
	END; $$ LANGUAGE plpgsql;

-- Change user permission level
CREATE OR REPLACE FUNCTION setUserLevel(uname TEXT, newLevel VARCHAR(1), session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' THEN
			UPDATE UserAccount SET UserLevel = newLevel WHERE username = uname;
		END IF;
	END; $$ LANGUAGE plpgsql;

-- Make 2 users friends
CREATE OR REPLACE FUNCTION addFriend(uname1 TEXT, uname2 TEXT, session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionUser TEXT;
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUser(session);
		IF sessionStatus = 'A' OR sessionUser = uname1 OR sessionUser = uname2 THEN
			INSERT INTO Friends values(uname1, uname2);
		END IF;
	END; $$ LANGUAGE plpgsql;

-- Make 2 users not friends
CREATE OR REPLACE FUNCTION removeFriend(uname1 TEXT, uname2 TEXT, session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' OR sessionUser = uname1 OR sessionUser = uname2 THEN
			DELETE FROM Friends f WHERE f.Username1=uname1 AND f.Username2=uname2;
			DELETE FROM Friends f WHERE f.Username1=uname2 AND f.Username2=uname1;
		END IF;
	END; $$ LANGUAGE plpgsql;

-- Get a user's friends
CREATE OR REPLACE FUNCTION getFriends(uname TEXT) RETURNS TABLE(Username username) AS $$
	BEGIN
		RETURN QUERY (SELECT f.Username2 AS Username FROM Friends f WHERE f.Username1=uname)
					UNION (SELECT f.Username1 AS Username FROM Friends f WHERE f.Username2=uname);
	END; $$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- File Management --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- Here for the use by other functions in this file
CREATE OR REPLACE FUNCTION convertToTextPath(fPath VARCHAR(255)[]) RETURNS TEXT AS $$
	DECLARE
		loopCount INT := 1;
		maxCount INT := cardinality(fPath);
		textPath TEXT := '/';
	BEGIN
		LOOP
			SELECT textPath || fPath[loopCount] || '/' INTO textPath;
			SELECT loopCount+1 INTO loopCount;
			IF loopCount>maxCount THEN RETURN textPath; END IF;
		END LOOP;
	END; $$ LANGUAGE plpgsql;

-- Here for the use by other functions in this file
CREATE OR REPLACE FUNCTION convertToArrPath(fPath TEXT) RETURNS VARCHAR(255)[] AS $$
	DECLARE
		loopCount INT := 1;
		pos INT;
		plen INT;
		tempString VARCHAR(255);
		arrPath VARCHAR(255)[];
	BEGIN
		SELECT * INTO fPath FROM TRIM(BOTH '/' FROM fPath);
		SELECT * INTO pos FROM position('/' in fPath);
		IF pos>0 THEN
			LOOP
				SELECT * INTO plen FROM CHAR_LENGTH(fPath);
				SELECT * INTO tempString FROM SUBSTRING(fPath from 1 for pos-1);
				SELECT * INTO fPath FROM SUBSTRING(fPath from pos+1 for plen-pos);
				SELECT * INTO arrPath FROM ARRAY_APPEND(arrPath, tempString);
				SELECT loopCount+1 INTO loopCount;
				SELECT * INTO pos FROM position('/' in fPath);
				IF pos=0 THEN EXIT; END IF;
			END LOOP;
		END IF;
		SELECT * INTO plen FROM CHAR_LENGTH(fPath);
		SELECT * INTO tempString FROM SUBSTRING(fPath from 1 for plen);
		SELECT * INTO arrPath FROM ARRAY_APPEND(arrPath, tempString);
		RETURN arrPath;
	END; $$ LANGUAGE plpgsql;

-- Here for the use by other functions in this file
CREATE OR REPLACE FUNCTION containsPath(basePath VARCHAR(255)[], checkingPath VARCHAR(255)[]) RETURNS BOOLEAN AS $$
	DECLARE
		loopCount INT := 1;
		baseLen INT;
		checkingLen INT;
	BEGIN
		SELECT * INTO baseLen FROM cardinality(basePath);
		SELECT * INTO checkingLen FROM cardinality(checkingPath);
		IF baseLen>checkingLen THEN RETURN FALSE; END IF;
		LOOP
			IF basePath[loopCount]<>checkingPath[loopCount] THEN RETURN FALSE; END IF;
			SELECT loopCount+1 INTO loopCount;
			IF loopCount>=baseLen THEN EXIT; END IF;
		END LOOP;
		RETURN TRUE;
	END; $$ LANGUAGE plpgsql;

-- Here for the use by other functions in this file
CREATE OR REPLACE FUNCTION isUserAllowedToRead(arrPath VARCHAR(255)[], uname TEXT) RETURNS BOOLEAN AS $$
	DECLARE isAllowed BOOLEAN;
	BEGIN
		SELECT ReadAllowed INTO isAllowed FROM UserPermissionsOnFile upof WHERE uname=upof.username AND arrPath=upof.FPath;
		RETURN isAllowed;
	END; $$ LANGUAGE plpgsql;

-- Here for the use by other functions in this file
CREATE OR REPLACE FUNCTION setPerms(uname TEXT, arrPath VARCHAR(255)[], readEnable BOOLEAN, writeEnable BOOLEAN, recurse BOOLEAN) RETURNS VOID AS $$
	DECLARE
		isDir BOOLEAN;
	BEGIN
		SELECT f.isDir INTO isDir FROM File f WHERE arrPath=f.FPath;
		DELETE FROM UserPermissionsOnFile upof WHERE upof.username=uname AND upof.FPath=arrPath;
		INSERT INTO UserPermissionsOnFile VALUES(uname, arrPath, readEnable, writeEnable);
		IF isDir THEN
			CREATE TEMP TABLE moreFiles(username TEXT, fPath VARCHAR(255)[], readAllowed BOOLEAN, writeAllowed BOOLEAN) ON COMMIT DROP;
			INSERT INTO moreFiles (fPath) SELECT FPath FROM File f WHERE
				containsPath(arrPath, f.FPath) AND
				(CARDINALITY(arrPath)+2 > CARDINALITY(f.FPath) OR recurse) AND
				CARDINALITY(arrPath) <> CARDINALITY(f.FPath);
			UPDATE moreFiles SET username=uname, readAllowed=readEnable, writeAllowed=writeEnable WHERE fPath IS NOT NULL;
			DELETE FROM UserPermissionsOnFile upof WHERE upof.username=uname AND upof.FPath IN (SELECT fPath FROM moreFiles);
			INSERT INTO UserPermissionsOnFile SELECT * FROM moreFiles;--mf WHERE mf.fPath IS NOT NULL;
		END IF;
	END; $$ LANGUAGE plpgsql;

-- Here for the use by other functions in this file
CREATE OR REPLACE FUNCTION addFile(arrPath VARCHAR(255)[], creatorUsername username, isDir BOOLEAN) RETURNS VOID AS $$
	DECLARE
		loopCount INT := 1;
		arrPathWithoutCurrent VARCHAR(255)[];
	BEGIN
		INSERT INTO File VALUES(arrPath, creatorUsername, current_timestamp, isDir);
	END; $$ LANGUAGE plpgsql;

-- Makes a directory
CREATE OR REPLACE FUNCTION mkdir(dirPath TEXT, creatorUsername TEXT) RETURNS VOID AS $$
	DECLARE arrPath VARCHAR(255)[];
	BEGIN
		SELECT * INTO arrPath FROM convertToArrPath(dirPath);
		PERFORM addFile(arrPath, creatorUsername, TRUE);
	END; $$ LANGUAGE plpgsql;

-- Makes a file
CREATE OR REPLACE FUNCTION touch(filePath TEXT, creatorUsername TEXT) RETURNS VOID AS $$
	DECLARE arrPath VARCHAR(255)[];
	BEGIN
		SELECT * INTO arrPath FROM convertToArrPath(filePath);
		PERFORM addFile(arrPath, creatorUsername, FALSE);
	END; $$ LANGUAGE plpgsql;

-- Lists stuff in the directory
CREATE OR REPLACE FUNCTION ls(parentDir TEXT, uname TEXT, recurse BOOLEAN, adminMode BOOLEAN) RETURNS TABLE(FilePath VARCHAR(255)[], IsDirectory BOOLEAN, CreatorUsername username, TimeOfCreation TIMESTAMP) AS $$
	DECLARE
		arrPath VARCHAR(255)[];
		isAdmin BOOLEAN;
	BEGIN
		SELECT * INTO arrPath FROM convertToArrPath(parentDir);
		SELECT userLevel='A' INTO isAdmin FROM UserAccount ua WHERE uname=ua.username;
		RETURN QUERY SELECT f.FPath AS FilePath, f.IsDir AS IsDirectory, f.username AS CreatorUsername, f.TimeOfCreation FROM File f WHERE
			containsPath(arrPath, f.FPath) AND
			(CARDINALITY(arrPath)+2 > CARDINALITY(f.FPath) OR recurse) AND
			CARDINALITY(arrPath) <> CARDINALITY(f.FPath) AND
			((isAdmin AND adminMode) OR uname=f.username OR isUserAllowedToRead(f.FPath, uname) OR uname='fu');
	END; $$ LANGUAGE plpgsql;

-- Deletes files/directories
CREATE OR REPLACE FUNCTION rm(filePath TEXT) RETURNS VOID AS $$
	DECLARE
		arrPath VARCHAR(255)[];
		isDir BOOLEAN;
	BEGIN
		SELECT * INTO arrPath FROM convertToArrPath(filePath);
		DELETE FROM File f WHERE containsPath(arrPath, f.FPath);
	END; $$ LANGUAGE plpgsql;

-- Changes permisions on files and directories
CREATE OR REPLACE FUNCTION chmod(uname TEXT, filePath TEXT, readEnable BOOLEAN, writeEnable BOOLEAN, recurse BOOLEAN) RETURNS VOID AS $$
	DECLARE
		arrPath VARCHAR(255)[];
	BEGIN
		SELECT * INTO arrPath FROM convertToArrPath(filePath);
		PERFORM setPerms(uname, arrPath, readEnable, writeEnable, recurse);
	END; $$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- Forum Management -------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION createCategory(cname title, session TEXT, pathOfLogo TEXT) RETURNS VOID AS $$
	DECLARE
		uname TEXT;
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO uname FROM getSessionUser(session);
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' OR sessionStatus = 'M' THEN
			INSERT INTO Category values(cname, uname, current_timestamp, pathOfLogo);
		END IF;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION createThread(tname title, session TEXT, threadCategory title, textBody TEXT) RETURNS VOID AS $$
	DECLARE
		uname TEXT;
	BEGIN
		SELECT * INTO uname FROM getSessionUser(session);
		INSERT INTO Thread values(tname, uname, threadCategory, current_timestamp, textBody);
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION createThreadComment(session TEXT, threadName title, userText TEXT) RETURNS VOID AS $$
	DECLARE
		uname TEXT;
	BEGIN
		SELECT * INTO uname FROM getSessionUser(session);
		INSERT INTO ThreadComment values(uname, current_timestamp, threadName, userText);
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION createFileComment(session TEXT, filePath TEXT, userText TEXT) RETURNS VOID AS $$
	DECLARE
		arrPath VARCHAR(255)[];
		uname TEXT;
	BEGIN
		SELECT * INTO uname FROM getSessionUser(session);
		SELECT * INTO arrPath FROM convertToArrPath(filePath);
		INSERT INTO FileComment values(uname, current_timestamp, arrPath, userText);
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getAllCategories(session TEXT) RETURNS TABLE(title title, Username username, timeofCreation TIMESTAMP) AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus <> 'N' THEN
			RETURN QUERY SELECT c.CTitle AS title, c.Username, c.TimeOfCreation FROM Category c;
		END IF;
		RETURN QUERY SELECT c.CTitle AS title, c.Username, c.TimeOfCreation FROM Category c WHERE c.Username='fu';
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getThreadsInCategory(categoryName title, session TEXT) RETURNS TABLE(Title title, Username username, timeofCreation TIMESTAMP) AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus <> 'N' THEN
			RETURN QUERY SELECT t.TTitle as Title, t.Username, t.TimeOfCreation FROM Thread t WHERE CTitle=categoryName;
		END IF;
		RETURN QUERY SELECT t.TTitle as Title, t.Username, t.TimeOfCreation FROM Thread t WHERE t.Username='fu';
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getThreadComments(threadName title, session TEXT) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT) AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus <> 'N' THEN
			RETURN QUERY SELECT tc.Username, tc.TimeOfCreation, tc.userText AS Body FROM ThreadComment tc WHERE tc.TTitle=threadName;
		END IF;
		RETURN QUERY SELECT tc.Username, tc.TimeOfCreation, tc.userText AS Body FROM ThreadComment tc WHERE tc.Username='fu';
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getFileComments(filePath TEXT, session TEXT) RETURNS TABLE(Username username, timeofCreation TIMESTAMP, body TEXT) AS $$
	DECLARE
		sessionStatus VARCHAR(1);
		arrPath VARCHAR(255)[];
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		SELECT * INTO arrPath FROM convertToArrPath(filePath);
		IF sessionStatus <> 'N' THEN
			RETURN QUERY SELECT fc.Username, fc.TimeOfCreation, fc.userText AS Body FROM FileComment fc WHERE fc.FPath=arrPath;
		END IF;
		RETURN QUERY SELECT fc.Username, fc.TimeOfCreation, fc.userText AS Body FROM FileComment fc WHERE fc.Username='fu';
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteCategory(catName title, session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' OR sessionStatus = 'M' THEN
			DELETE FROM Category c WHERE c.CTitle=catName;
		END IF;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteThread(threadName title, session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' OR sessionStatus = 'M' THEN
			DELETE FROM Thread t WHERE c.TTitle=catName;
		END IF;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteThreadComment(uname username, postTime DATETIME, session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' OR sessionStatus = 'M' THEN
			DELETE FROM ThreadComment tc WHERE tc.Username=uname, tc.TimeOfCreation=postTime;
		END IF;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteFileComment(uname username, postTime DATETIME, session TEXT) RETURNS VOID AS $$
	DECLARE
		sessionStatus VARCHAR(1);
	BEGIN
		SELECT * INTO sessionStatus FROM getSessionUserLevel(session);
		IF sessionStatus = 'A' OR sessionStatus = 'M' THEN
			DELETE FROM FileComment fc WHERE fc.Username=uname, fc.TimeOfCreation=postTime;
		END IF;
	END; $$ LANGUAGE plpgsql;
