CREATE PROCEDURE BoombastikProcedure.[test that it doesn't matter what you pass to function you are still cool]
AS
BEGIN
    DECLARE @expected INT = 1
           ,@actual INT = -1
    CREATE TABLE #expected (
        ImportantResult INT NOT NULL
    );

    INSERT INTO #expected (ImportantResult)
        VALUES (@expected);

    EXEC tSQLt.FakeFunction @FunctionName = 'dbo.ImportantFunction'
                           ,@FakeDataSource = 'select 1 as ImportantResult';

    SELECT
        @actual = ImportantResult
    FROM dbo.ImportantFunction(100, 100);

    EXEC tSQLt.AssertEquals @Actual = @actual
                           ,@Expected = @expected;
END
GO