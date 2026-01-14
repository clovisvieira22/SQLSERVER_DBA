SELECT
    database_name,
    physical_device_name,
    backup_start_date,
    backup_finish_date
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.type = 'I' -- I = Differential
                    -- D	Full (Completo)	Backup completo do banco
                    -- I	Differential	Backup diferencial
                    -- L	Log	Backup do transaction log
                    -- F	File ou Filegroup	Backup de arquivo ou filegroup
                    -- G	Differential File	Backup diferencial de arquivo/filegroup
                    -- P	Partial	Backup parcial (somente filegroups read-write)
                    -- Q	Differential Partial	Diferencial de backup parcial
ORDER BY backup_finish_date DESC;
