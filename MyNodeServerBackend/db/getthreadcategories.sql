select t.title as ThreadTitle, c.title as CategoryTitle from thread t, category c, threadhascategory thc where t.title=thc.ttitle and c.title=thc.ctitle;
