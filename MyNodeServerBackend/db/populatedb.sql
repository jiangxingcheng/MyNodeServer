SELECT createUser('schafezp','changething');
SELECT createUser('zamanmm','otherthing');
SELECT createUser('jiangx1','otherthing');
SELECT createUser('vanpelwc','asdfasdf');
SELECT setUserLevel('schafezp','A');
SELECT setUserLevel('zamanmm','M');
SELECT setUserLevel('jiangx1','U');
SELECT setUserLevel('vanpelwc','A');

SELECT createCategory('General','schafezp',NULL);
SELECT createCategory('Help','schafezp',NULL);
SELECT createCategory('NSFW','schafezp',NULL);
SELECT createCategory('/b/','schafezp',NULL);
SELECT createCategory('Pirated Software','vanpelwc',NULL);

SELECT createThread('A collection of one liners','zamanmm','General',NULL);
SELECT createThread('My node adventures','jiangx1','General',NULL);
SELECT createThread('Intro to threads','schafezp','Help',NULL);
SELECT createThread('General','schafezp','General',NULL);
SELECT createThread('Zombie Squirrel','zamanmm','NSFW',NULL);
SELECT createThread('Internet stuff','zamanmm','General',NULL);
SELECT createThread('Orange waffles','zamanmm','NSFW',NULL);
SELECT createThread('You dont want to know','jiangx1','/b/',NULL);
SELECT createThread('Microsoft''s Overpriced Shit','vanpelwc','Pirated Software','Fuck Microsoft');

SELECT createThreadComment('vanpelwc','Microsoft''s Overpriced Shit', 'They really suck');

--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------   Depricated Creation Methods  ------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- INSERT INTO UserAccount values('schafezp','changething',NULL,'Admin','2001-02-16 20:38:40','2001-02-16 20:38:40');
-- INSERT INTO UserAccount values('zamanmm','otherthing',NULL,'Mod','2012-02-16 20:38:40','2001-02-16 20:38:40');
-- INSERT INTO UserAccount values('jiangx1','otherthing',NULL,'User','2012-02-16 20:38:40','2001-02-16 20:38:40');
-- INSERT INTO UserAccount values('vanpelwc','1AlautLrbWPBQsvpNIf6',NULL,'User','2012-02-16 20:38:40','2001-02-16 20:38:40');

-- INSERT INTO Category values('General','schafezp','2014-02-16 12:30:40');
-- INSERT INTO Category values('Help','schafezp','2015-02-16 12:30:40');
-- INSERT INTO Category values('NSFW','schafezp','2015-02-16 12:30:40');
-- INSERT INTO Category values('/b/','schafezp','2015-02-16 12:30:40');
-- INSERT INTO Category values('Pirated Software','vanpelwc','2016-05-06 00:00:00');

-- INSERT INTO Thread values('A collection of one liners','zamanmm','General','2016-02-16 12:30:40');
-- INSERT INTO Thread values('My node adventures','jiangx1','2016-04-10 04:30:00','General');
-- INSERT INTO Thread values('Intro to threads','schafezp','2016-04-10 04:30:00', 'General');
-- INSERT INTO Thread values('General','schafezp','2016-04-10 04:30:00', 'General');
-- INSERT INTO Thread values('Zombie Squirrel','zamanmm','2016-04-10 04:20:00', 'General');
-- INSERT INTO Thread values('Internet stuff','zamanmm','NSFW','2016-05-10 04:21:00');
-- INSERT INTO Thread values('Orange waffles','zamanmm','Help','2016-04-8 04:23:00');
-- INSERT INTO Thread values('You dont want to know','jiangx1','/b/','2016-04-8 04:23:00');
-- INSERT INTO Thread values('Microsoft''s Overpriced Shit','vanpelwc','Pirated Software','2016-05-06 00:00:00');

-- INSERT INTO CategoryHasThread values('General','Internet stuff');
-- INSERT INTO CategoryHasThread values('Help','Intro to threads');
-- INSERT INTO CategoryHasThread values('NSFW','Zombie Squirrel');
-- INSERT INTO CategoryHasThread values('NSFW','Orange waffles');
-- INSERT INTO CategoryHasThread values('/b/','You dont want to know');
-- INSERT INTO CategoryHasThread values('Pirated Software','Microsoft''s Overpriced Shit');

-- INSERT INTO ThreadComment values('schafezp','2016-04-8 04:23:00','General','Here is my comment');
-- INSERT INTO ThreadHasCategory values('JS fun things','My node adventures');
-- INSERT INTO ThreadHasCategory values('SQL useful files','SQL backing up postgres');
