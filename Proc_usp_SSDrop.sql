CREATE PROCEDURE [dbo].[usp_SSDrop]
	@Debug		BIT = 0
AS
DECLARE
	@TSql		NVARCHAR(MAX);

SELECT
	@TSql = COALESCE(@TSql+CHAR(10)+I.DbInfo,I.DbInfo)
FROM
	(
		SELECT
			CONCAT('DROP DATABASE IF EXISTS [',DBName,'_Snapshot];') AS DbInfo
		FROM
			dbo.DBSnapshot
		WHERE
			IsActive = 1
	) AS I;
IF @Debug = 1
	EXEC dbo.usp_Print @TSql;
ELSE
	EXEC (@TSql);
RETURN 0;
