CREATE FUNCTION dbo.ImportantFunction
(
	@param1 int,
	@param2 int
)
RETURNS TABLE AS RETURN
(
	SELECT @param1  + @param2 AS ImportantResult
)
