CREATE PROCEDURE [dbo].[usp_SSCreate]
	@Debug			BIT = 0
AS
SET NOCOUNT ON;

DECLARE
	@database				SYSNAME,
	@sql					NVARCHAR(MAX);

DECLARE database_snapshots CURSOR FAST_FORWARD FOR
	SELECT
		DBName
	FROM
		dbo.DBSnapshot
	WHERE
		IsActive = 1;
OPEN database_snapshots;
FETCH NEXT FROM database_snapshots INTO @database;
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Sql = null;
		SELECT
			@sql = COALESCE(@sql+','+CHAR(10)+I.FileInfo,I.FileInfo)
		FROM
			(
				SELECT
					CONCAT('(Name=''',f.name,''',FileName=''',f.physical_name,'.ss'')') AS FileInfo
				FROM
					master.sys.master_files AS f
				WHERE
					f.database_id			= DB_ID(@database)
				AND f.type_desc				= 'ROWS'
			) AS I;
		
		SET @sql = CONCAT('CREATE DATABASE [',@database,'_Snapshot] ON ',CHAR(10),@sql,' AS SNAPSHOT OF ',@database,';');
		IF @Debug = 1
			EXEC dbo.usp_Print @sql;
		ELSE
			EXEC (@sql);
		FETCH NEXT FROM database_snapshots INTO @database;
	END;
CLOSE database_snapshots;
DEALLOCATE database_snapshots;
RETURN 0;
