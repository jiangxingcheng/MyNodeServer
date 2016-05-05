select t.title, t.username, t.timeofcreation from category c, thread t,CategoryHasThread cht where c.title=$1 and c.title=cht.ctitle and t.title=cht.ttitle;
