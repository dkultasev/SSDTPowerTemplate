CREATE PROCEDURE ImportantTable.[test that ImportantTable exists]
AS
    BEGIN
        IF NOT EXISTS (   SELECT 1
                            FROM sys.tables AS t
                           WHERE OBJECT_ID('dbo.ImportantTable') = t.object_id)
            BEGIN
                RAISERROR('Table doesn''t exist', 16, 1);
            END
    END
GO