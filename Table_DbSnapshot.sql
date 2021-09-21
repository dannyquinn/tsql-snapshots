CREATE TABLE [dbo].[DBSnapshot](
	[ID] 		[int]  		NOT NULL	IDENTITY(1,1),
	[DBName] 	[sysname] 	NOT NULL,
	[IsActive] 	[bit] 		NOT NULL,
	CONSTRAINT [PK_DBSnapshot] PRIMARY KEY CLUSTERED
	(
		[DBName] ASC
	)
);
