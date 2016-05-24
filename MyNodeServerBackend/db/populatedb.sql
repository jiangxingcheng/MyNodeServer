INSERT INTO UserAccount VALUES('dbsetup','asdfasdf','salty','A',current_timestamp,current_timestamp);
INSERT INTO UserSessions VALUES('microsoftsucks','dbsetup',current_timestamp,current_timestamp);

SELECT createUser('schafezp','changething');
SELECT createUser('zamanmm','otherthing');
SELECT createUser('jiangx1','otherthing');
SELECT createUser('vanpelwc','asdfasdf');
SELECT setUserLevel('schafezp','A','microsoftsucks');
SELECT setUserLevel('zamanmm','M','microsoftsucks');
SELECT setUserLevel('jiangx1','U','microsoftsucks');
SELECT setUserLevel('vanpelwc','A','microsoftsucks');

SELECT createCategory('General','microsoftsucks',NULL);
SELECT createCategory('Help','microsoftsucks',NULL);
SELECT createCategory('NSFW','microsoftsucks',NULL);
SELECT createCategory('/b/','microsoftsucks',NULL);
SELECT createCategory('Pirated Software','microsoftsucks',NULL);
SELECT mkdir('/home/', 'microsoftsucks');


UPDATE UserSessions SET Username='vanpelwc' WHERE SessionID='microsoftsucks';
SELECT touch('/home/wesley/.bash_profile', 'microsoftsucks');
SELECT touch('/home/wesley/.bashrc', 'microsoftsucks');
SELECT createThread('Microsoft''s Overpriced Shit','microsoftsucks','Pirated Software','Fuck Microsoft');
SELECT createThreadComment('microsoftsucks','Microsoft''s Overpriced Shit', 'They really suck');

UPDATE UserSessions SET Username='schafezp' WHERE SessionID='microsoftsucks';
SELECT mkdir('/home/schafezp/csse333', 'microsoftsucks');
SELECT mkdir('/home/schafezp/csse564', 'microsoftsucks');
SELECT createThread('Intro to threads','microsoftsucks','Help',NULL);
SELECT createThread('General','microsoftsucks','General',NULL);
SELECT createThread('A collection of one liners','microsoftsucks','General',NULL);

UPDATE UserSessions SET Username='zamanmm' WHERE SessionID='microsoftsucks';
SELECT mkdir('/home/zamanmm/i3config', 'microsoftsucks');
SELECT mkdir('/home/zamanmm/i3config/randomfolder', 'microsoftsucks');
SELECT mkdir('/home/zamanmm/i3configarchlinux', 'microsoftsucks');
SELECT mkdir('/home/zamanmm/fixorg.sh', 'microsoftsucks');
SELECT touch('/home/zamanmm/i3config/myconfig', 'microsoftsucks');
SELECT createThread('Zombie Squirrel','microsoftsucks','NSFW',NULL);
SELECT createThread('Internet stuff','microsoftsucks','General',NULL);
SELECT createThread('Orange waffles','microsoftsucks','NSFW',NULL);
SELECT createThreadComment('microsoftsucks','Internet stuff', 'here is some linux stuff i found on the internet');
SELECT createThreadComment('microsoftsucks','A collection of one liners', ' :(){ :|: & };:');
-- SELECT createFileComment('microsoftsucks','/home/zamanmm/i3config/myconfig','this is so l33t');

UPDATE UserSessions SET Username='jiangx1' WHERE SessionID='microsoftsucks';
SELECT createThread('My node adventures','microsoftsucks','General',NULL);
SELECT createThread('You dont want to know','microsoftsucks','/b/',NULL);

SELECT closeSession('microsoftsucks');
