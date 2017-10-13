select * from posting;
select * from postingimage;


SELECT A.PostingID,A.CategoryID,A.PostingText,A.Title,A.Price,B.FileName
FROM posting A
LEFT JOIN (SELECT ImageID, PostingID, FileName FROM postingimage
GROUP BY PostingID) b ON B.PostingID = A.PostingID

