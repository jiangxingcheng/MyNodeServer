INSERT INTO UserAccount VALUES('dbsetup','asdfasdf','salty','A',current_timestamp,current_timestamp);
INSERT INTO UserSessions VALUES('microsoftsucks','dbsetup',current_timestamp,current_timestamp);

PERFORM createUser('schafezp','changething');
PERFORM createUser('zamanmm','otherthing');
PERFORM createUser('jiangx1','otherthing');
PERFORM createUser('vanpelwc','asdfasdf');
PERFORM setUserLevel('schafezp','A','microsoftsucks');
PERFORM setUserLevel('zamanmm','M','microsoftsucks');
PERFORM setUserLevel('jiangx1','U','microsoftsucks');
PERFORM setUserLevel('vanpelwc','A','microsoftsucks');

PERFORM createCategory('General','microsoftsucks',NULL);
PERFORM createCategory('Help','microsoftsucks',NULL);
PERFORM createCategory('NSFW','microsoftsucks',NULL);
PERFORM createCategory('/b/','microsoftsucks',NULL);
PERFORM createCategory('Pirated Software','microsoftsucks',NULL);
PERFORM mkdir('/home/', 'microsoftsucks');


UPDATE UserSessions SET Username='vanpelwc' WHERE SessionID='microsoftsucks';
PERFORM mkdir('/home/wesley/', 'microsoftsucks');
PERFORM touch('/home/meh','microsoftsucks');
PERFORM touch('/home/wesley/.bash_profile', 'microsoftsucks');
PERFORM touch('/home/wesley/.bashrc', 'microsoftsucks');
PERFORM createThread('Microsoft''s Overpriced Shit','microsoftsucks','Pirated Software','Fuck Microsoft');
PERFORM createThreadComment('microsoftsucks','Microsoft''s Overpriced Shit', 'They really suck');

UPDATE UserSessions SET Username='schafezp' WHERE SessionID='microsoftsucks';
PERFORM mkdir('/home/schafezp/', 'microsoftsucks');
PERFORM mkdir('/home/schafezp/csse333', 'microsoftsucks');
PERFORM mkdir('/home/schafezp/csse564', 'microsoftsucks');
PERFORM createThread('Intro to threads','microsoftsucks','Help',NULL);
PERFORM createThread('General','microsoftsucks','General',NULL);
PERFORM createThreadComment('microsoftsucks','A collection of one liners', ' :(){ :|: & };:');

UPDATE UserSessions SET Username='zamanmm' WHERE SessionID='microsoftsucks';
PERFORM mkdir('/home/zamanmm/', 'microsoftsucks');
PERFORM mkdir('/home/zamanmm/i3config', 'microsoftsucks');
PERFORM mkdir('/home/zamanmm/i3config/randomfolder', 'microsoftsucks');
PERFORM mkdir('/home/zamanmm/i3configarchlinux', 'microsoftsucks');
PERFORM mkdir('/home/zamanmm/fixorg.sh', 'microsoftsucks');
PERFORM touch('/home/zamanmm/i3config/myconfig', 'microsoftsucks');
PERFORM createThread('A collection of one liners','microsoftsucks','General',NULL);
PERFORM createThread('Zombie Squirrel','microsoftsucks','NSFW',NULL);
PERFORM createThread('Internet stuff','microsoftsucks','General',NULL);
PERFORM createThread('Orange waffles','microsoftsucks','NSFW',NULL);
PERFORM createThreadComment('microsoftsucks','Internet stuff', 'here is some linux stuff i found on the internet');
PERFORM createFileComment('microsoftsucks','/home/zamanmm/i3config/myconfig','this is so l33t');

UPDATE UserSessions SET Username='jiangx1' WHERE SessionID='microsoftsucks';
PERFORM createThread('My node adventures','microsoftsucks','General',NULL);
PERFORM createThread('You dont want to know','microsoftsucks','/b/',NULL);

PERFORM closeSession('microsoftsucks');
