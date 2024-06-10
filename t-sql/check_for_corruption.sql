--create table variable 
declare @dbcc_physical Table (
     name varchar(50) not null
);

-- select database names who are under 1GB in size, and store in table variable 
INSERT INTO @dbcc_physical
SELECT name from sys.master_files
WHERE type = 0 
AND size < 1024
AND name != 'modeldev';

-- create dynamic sql to execute dbcc check 
DECLARE @tableCursor CURSOR,
@databaseName VARCHAR(100); 

SET @tableCursor = CURSOR FOR SELECT * FROM @dbcc_physical; 

OPEN @tableCursor; 
FETCH NEXT FROM @tableCursor INTO @databaseName; 
WHILE(@@FETCH_STATUS = 0) 
BEGIN 
  EXECUTE ('DBCC CHECKDB(' + @databaseName + ') WITH PHYSICAL_ONLY;'); 
  
  FETCH NEXT FROM @tableCursor INTO @databaseName 
END; 
CLOSE @tableCursor; 
DEALLOCATE @tableCursor;