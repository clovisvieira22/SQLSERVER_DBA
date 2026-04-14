USE [master]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BackupLog_ComRetencao]
AS
BEGIN

    DECLARE @name VARCHAR(100);
    DECLARE @DATE DATETIME = SYSDATETIME();

    DECLARE @PASTA NVARCHAR(300) = N'E:\Backups\Log\';

    ----------------------------------------
    -- 🔁 BACKUP DOS LOGS
    ----------------------------------------

    DECLARE db_cursor CURSOR READ_ONLY FOR  
        SELECT name
        FROM master.sys.databases 
        WHERE state = 0
          AND is_in_standby = 0
          AND name <> 'tempdb'
          AND recovery_model IN (1, 2) -- FULL e BULK_LOGGED

    OPEN db_cursor   
    FETCH NEXT FROM db_cursor INTO @name   

    WHILE @@FETCH_STATUS = 0   
    BEGIN   

        DECLARE @NOME1 NVARCHAR(300);
        DECLARE @NOME2 NVARCHAR(300);

        -- 🔥 SEM SEGUNDOS (yyyyMMddHHmm)
        SET @NOME1 = N'L_' + FORMAT(@DATE, 'yyyyMMddHHmm') + N'_' + @name + '_01.trn';
        SET @NOME2 = N'L_' + FORMAT(@DATE, 'yyyyMMddHHmm') + N'_' + @name + '_02.trn';

        DECLARE @FULL1 NVARCHAR(500) = @PASTA + @NOME1;
        DECLARE @FULL2 NVARCHAR(500) = @PASTA + @NOME2;

        DECLARE @DESC NVARCHAR(1000) = @name + N' - Transaction Log Backup';

        BACKUP LOG @name
        TO  DISK = @FULL1,
            DISK = @FULL2
        WITH 
            COMPRESSION,
            NAME = @DESC;

        FETCH NEXT FROM db_cursor INTO @name
    END   

    CLOSE db_cursor   
    DEALLOCATE db_cursor

    ----------------------------------------
    -- 🧹 RETENÇÃO (15 DIAS)
    ----------------------------------------

    DECLARE @CMD NVARCHAR(1000);

    -- Deleta arquivos .trn com mais de 15 dias
    SET @CMD = 'forfiles /p "' + @PASTA + '" /s /m *.trn /d -15 /c "cmd /c del @path"';

    EXEC xp_cmdshell @CMD;

END
GO
