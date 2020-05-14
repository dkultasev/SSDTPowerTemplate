CREATE PROCEDURE ImportantTable.[test that when you insert to EquallyImportantTable it simply works]
AS
    BEGIN
        IF NOT EXISTS (   SELECT 1
                            FROM sys.tables AS t
                           WHERE OBJECT_ID('dbo.EquallyImportantTable') = t.object_id)
            BEGIN
                RAISERROR('Table doesn''t exist', 16, 1);
            END
    END
GO