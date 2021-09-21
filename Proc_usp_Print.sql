CREATE PROCEDURE [dbo].[usp_Print]
	@String		NVARCHAR(MAX)
AS
DECLARE
	@CurrentEnd BIGINT,
	@Offset		TINYINT,
	@Local		NVARCHAR(MAX);
SET @Local = @String;
WHILE LEN(@Local)>1
	BEGIN
		IF CHARINDEX(CHAR(10),@Local) BETWEEN 1 AND 4000
			SELECT
				@CurrentEnd		= CHARINDEX(CHAR(10),@Local)-1,
				@Offset			= 2;
		ELSE
			SELECT
				@CurrentEnd		= 4000,
				@Offset			= 1;
		PRINT SUBSTRING(@Local,1,@CurrentEnd);
		SET @Local = SUBSTRING(@Local,@CurrentEnd + @Offset,LEN(@Local));
	END;
RETURN 0;
