CREATE PROCEDURE [dbo].[usp_SSRevert]
	@Debug		BIT = 0
AS
SET NOCOUNT ON;

DECLARE @TSql NVARCHAR(MAX);
SELECT
	@TSql = COALESCE(@Tsql+RevertStmt,RevertStmt)
FROM
	(
		SELECT
			CONCAT('ALTER DATABASE [',DBName,'] SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE;',CHAR(10),'RESTORE DATABASE [',DBName,'] FROM DATABASE_SNAPSHOT = ''',DBName,'_Snapshot'';',CHAR(10)) AS RevertStmt
		FROM
			dbo.DBSnapshot
		WHERE
			IsActive = 1
	) AS I;
IF @Debug = 1
	EXEC dbo.usp_Print @Tsql;
ELSE
	EXEC (@TSql);
RETURN 0;
