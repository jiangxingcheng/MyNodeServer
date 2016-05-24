-- Takes the new username and password to salt and hash the password
CREATE OR REPLACE FUNCTION createUser(uname TEXT, upassword TEXT) RETURNS VOID AS $$
	DECLARE salt TEXT;
	DECLARE hashed TEXT;
	BEGIN
		SELECT gen_salt('md5') INTO salt;
		SELECT crypt(upassword, salt) INTO hashed;
		INSERT INTO UserAccount values(uname, hashed, salt, 'User', current_timestamp, current_timestamp);
	END; $$ LANGUAGE plpgsql;

-- Verifies username and password
CREATE OR REPLACE FUNCTION loginUser(uname TEXT, upassword TEXT) RETURNS TEXT AS $$
	DECLARE readSalt TEXT;
	DECLARE readPass TEXT;
	BEGIN
		SELECT salt INTO readSalt FROM UserAccount WHERE username = uname;
		SELECT password INTO readPass FROM UserAccount WHERE username = uname;
		IF readPass = crypt(upassword, readSalt) THEN
			UPDATE UserAccount SET LastAccessDate = current_timestamp WHERE username = uname;
			RETURN 'Login Success';
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
CREATE OR REPLACE FUNCTION getAllUsers() RETURNS TABLE(Username username, UserLevel userlevel, LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation from UserAccount ua;
	END; $$ LANGUAGE plpgsql;

-- Find a user by thier username
CREATE OR REPLACE FUNCTION findUser(uname TEXT) RETURNS TABLE(Username username, UserLevel userLevel, LastAccessDate TIMESTAMP, TimeOfCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT ua.Username, ua.UserLevel, ua.LastAccessDate, ua.TimeOfCreation FROM UserAccount AS ua WHERE ua.Username=uname;
	END; $$ LANGUAGE plpgsql;

-- Remove user and all their shit
CREATE OR REPLACE FUNCTION removeUser(uname TEXT) RETURNS VOID AS $$
	BEGIN
		DELETE FROM UserAccount WHERE username=uname;
	END; $$ LANGUAGE plpgsql;

-- Change user permission level
CREATE OR REPLACE FUNCTION setLevel(uname TEXT, newLevel userLevel) RETURNS VOID AS $$
	BEGIN
		UPDATE UserAccount SET UserLevel = newLevel WHERE username = uname;
	END; $$ LANGUAGE plpgsql;

-- Get all files/subdirs in a dir
CREATE OR REPLACE FUNCTION getSubStuff(parentDir fullpath) RETURNS TABLE(itemPath fullpath) AS $$
	BEGIN
		RETURN QUERY (SELECT DPath AS itemPath INTO dirs FROM Directory WHERE ParentPath=parentDir)
					UNION (SELECT FPath AS itemPath INTO dirs FROM File WHERE ParentPath=parentDir);
	END; $$ LANGUAGE plpgsql;

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

-- Get all threads in a category
CREATE OR REPLACE FUNCTION getThreadsInCategory(categoryName title) RETURNS TABLE(Title title, Username username, timeofCreation TIMESTAMP) AS $$
	BEGIN
		RETURN QUERY SELECT t.TTitle as Title, t.Username, t.TimeOfCreation FROM Thread t WHERE CTitle=categoryName;
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

CREATE OR REPLACE FUNCTION deleteCategory(catName title) RETURNS VOID AS $$
	BEGIN
		DELETE FROM Category c WHERE c.CTitle=catName;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteThread(threadTitle title) RETURNS VOID AS $$
		DELETE FROM Thread t WHERE c.TTitle=threadName;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteThreadComment(uname username, createTime TIMESTAMP) RETURNS VOID AS $$
		DELETE FROM ThreadComment tc WHERE tc.Username=uname AND tc.TimeOfCreation=createTime;
	END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteFileComment(uname username, createTime TIMESTAMP) RETURNS VOID AS $$
		DELETE FROM FileComment fc WHERE fc.Username=uname AND fc.TimeOfCreation=createTime;
	END; $$ LANGUAGE plpgsql;
