SELECT t.*, 
       @rownum := @rownum + 1 AS rank
  FROM YOUR_TABLE t, 
       (SELECT @rownum := 0) r
	   
	   
-- PARTITION BY
SELECT id, crew_id, amount, type,
       (CASE type 
        WHEN @curType 
        THEN @curRow := @curRow + 1 
        ELSE @curRow := 1 AND @curType := type END) AS rank
FROM Table1 p,(SELECT @curRow := 0, @curType := '') r
ORDER BY crew_id,type asc;   