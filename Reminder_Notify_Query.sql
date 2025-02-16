 --Addition all Renimder notification module required table structures are as shown below:
	---> TABLE REMAINDER_NOTIFY_MST
	----------- Table createion structure  -------------------
	--DROP TABLE [REMAINDER_NOTIFY_MST];
	CREATE TABLE [dbo].[REMAINDER_NOTIFY_MST](
		[CMP_CD] [varchar](10) NOT NULL,
		[ULOGIN_ID] [varchar](20) NOT NULL,
		[OFF_CD] [varchar](20) NOT NULL,
		[REM_ID] [bigint] IDENTITY(1,1) NOT NULL,
		[REM_TITLE] [varchar](100) NOT NULL,
		[REM_DESC] [varchar](250) NOT NULL,
		[SYS_DATE] [DATETIME] DEFAULT GETDATE() NOT NULL,
		[REM_EXPIRY] [datetime] NOT NULL,
		[UPDATED_ON] [datetime] NULL,
		[IS_STATUS] [varchar](1) NULL,
		PRIMARY KEY CLUSTERED([CMP_CD],[REM_TITLE])
	)
	-----------------------------------------------------------
	---> TABLE REMD_NOTIFY_DTLS
	----------- Table createion structure ---------------------
	CREATE TABLE [dbo].[REMD_NOTIFY_DTLS](
		[CMP_CD] [varchar](10) NOT NULL,
		[ULOGIN_ID] [varchar](20) NOT NULL,
		[OFF_CD] [varchar](20) NOT NULL,
		[ID] [bigint] IDENTITY(10001,1) NOT NULL,
		[REM_ID] [bigint] NOT NULL,
		[NOTIFY_PERSON_NAME] [varchar](50) NOT NULL,
		[NOTIFY_EMAIL] [varchar](30) NOT NULL,
		[SYS_DATETIME] [datetime] DEFAULT GETDATE() NOT NULL,
		PRIMARY KEY CLUSTERED([CMP_CD],[REM_ID],[NOTIFY_PERSON_NAME]
	);
	-----------------------------------------------------------
	---> TABLE NOTIFICATIONS
	-------------- Table createion structure ------------------
	CREATE TABLE [dbo].[NOTIFICATIONS](
		[CMP_CD] [varchar](10) NOT NULL,
		[ULOGIN_ID] [varchar](30) NULL,
		[OFF_CD] [varchar](30) NULL,
		[NOTIFICATION_ID] [bigint] IDENTITY(1000001,1) NOT NULL,
		[REM_ID] [int] NULL,
		[REM_TITLE] [varchar](50) NULL,
		[SENT_DATE] [DATETIME] DEFAULT GETDATE() NOT NULL,
		[MESSAGE] [nvarchar](500) NOT NULL,
		PRIMARY KEY CLUSTERED([CMP_CD],[SENT_DATE]
	);
	----------------------------------------------------------
	---> TABLE REMD_LOGS
	--------------- Table createion structure ----------------
	CREATE TABLE [dbo].[REMD_LOGS](
		[CMP_CD] [varchar](10) NOT NULL,
		[ULOGIN_ID] [varchar](30) NOT NULL,
		[OFF_CD] [varchar](30) NOT NULL,
		[LOG_ID] [bigint] IDENTITY(100001,1) NOT NULL,
		[REMD_ID] [bigint] NOT NULL,
		[NOTIFY_TITLE] [varchar](50) NOT NULL,
		[CURRENT_DUE_DATE] [datetime] NULL,
		[NEXT_DUE_DATE] [datetime] NULL,
		[REMARKS] [varchar](250) NULL,
		[CREATED_BY] [varchar](30) NULL,
		[UPDATED_BY] [varchar](30) NULL
	);

	----------------------11-02-2025----------------
	USE BioAS_MT_RB;
	