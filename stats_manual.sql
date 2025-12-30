DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql +=
    'UPDATE STATISTICS ' 
    + QUOTENAME(OBJECT_SCHEMA_NAME(s.object_id)) + '.' 
    + QUOTENAME(OBJECT_NAME(s.object_id)) + ' [' + s.name + '];' + CHAR(13)
FROM sys.stats s
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
WHERE sp.modification_counter > 0;

PRINT @sql;
-- EXEC sp_executesql @sql;
