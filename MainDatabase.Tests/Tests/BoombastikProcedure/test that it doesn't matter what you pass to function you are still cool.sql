CREATE PROCEDURE BoombastikProcedure.[test that it doesn't matter what you pass to function you are still cool]
AS
    BEGIN
    declare @expected int = 1,
@actual int = -1
       CREATE TABLE #expected
       (
           ImportantResult int not null
       );
       
       insert into #expected  (ImportantResult) values (@expected);

       exec tsqlt.fakefunction @FunctionName = 'dbo.ImportantFunction', @FakeDataSource = 'select 1 as ImportantResult';

        select @actual = ImportantResult FROM  dbo.ImportantFunction(100,100);

        exec tsqlt.assertequals @Actual = @actual, @Expected = @expected;
    END
GO