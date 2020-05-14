:r .\..\..\MainDatabase\Scripts\Script.PostDeployment.sql

    RAISERROR('<--------------> Running unit tests <----------------->',1,0) WITH NOWAIT;

EXEC tSQLt.RunAll;
