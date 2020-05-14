CREATE PROCEDURE ImportantTable.setup
AS
    BEGIN
        EXEC tSQLt.FakeTable @TableName = 'dbo.EquallyImportantTable';
        INSERT INTO dbo.EquallyImportantTable(Id) VALUES (0);
    END
GO