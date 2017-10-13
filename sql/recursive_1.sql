select 
a.CategoryID
,if(a.ParentCategoryID = 0,@varw:=concat(a.CategoryID,','),@varw:=concat(a.CategoryID,',',@varw)) as list 
from 
(select * 
 from category 
 order by if(ParentCategoryID=0,CategoryID,ParentCategoryID) asc) a 
 left join category b on (a.CategoryID = b.ParentCategoryID),(select @varw:='') as c  
 #having list like '%19,%';