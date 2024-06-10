
use database;
go

SET NOCOUNT ON;

DECLARE @rowcount INT;
SET @rowcount = 1;

WHILE @rowcount > 0
 BEGIN
    BEGIN TRANSACTION;
    
    DELETE TOP (500000) database.dbo.table(x)
        WHERE column <= DATEADD(mm,-13,GETDATE()) 
    OPTION (MAXDOP 1);
    
    SET @rowcount = @@ROWCOUNT;
    
    COMMIT TRANSACTION; 
END
GO