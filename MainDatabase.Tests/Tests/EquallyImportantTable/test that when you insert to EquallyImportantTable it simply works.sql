﻿CREATE PROCEDURE EquallyImportantTable.[test that when you insert to EquallyImportantTable it simply works]
AS
    BEGIN
        DECLARE @expected INT = 0
              , @actual   INT = -1;

        EXEC tSQLt.FakeTable @TableName = 'dbo.EquallyImportantTable';
        INSERT INTO dbo.EquallyImportantTable(Id) VALUES (0);

        select @actual = Id from dbo.EquallyImportantTable;
        EXEC tSQLt.AssertEquals @Expected = @expected, @Actual = @actual;
    END
GO