SELECT
    database_name,
    physical_device_name,
    backup_start_date,
    backup_finish_date
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.type = 'I' -- I = Differential
ORDER BY backup_finish_date DESC;
