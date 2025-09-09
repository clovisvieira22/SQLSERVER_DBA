/********************************************************************************************************
  Script for checking index fragmentation in SQL Server and generating reorganize/rebuild commands.

  Actions:
  1. Connect in database in SSMS.
  2. Execute this script.
  3. Copy commands from 'ComandoSQL' column and run them in a new query window to apply maintenance.

********************************************************************************************************/

SELECT 
    OBJECT_SCHEMA_NAME(ips.object_id) AS 'Schema',
    OBJECT_NAME(ips.object_id) AS 'Table',
    i.name AS 'Index',
    ips.avg_fragmentation_in_percent AS 'Fragmentation (%)',
    CASE 
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'REBUILD'
        ELSE 'REORGANIZE'
    END AS 'Recommended Action',
    -- Gera o comando SQL correspondente à ação recomendada
    'ALTER INDEX [' + i.name + '] ON [' + OBJECT_SCHEMA_NAME(ips.object_id) + '].[' + OBJECT_NAME(ips.object_id) + '] ' + 
    CASE 
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'REBUILD'
        ELSE 'REORGANIZE'
    END + ';' AS 'SQLCommand'
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') AS ips
INNER JOIN 
    sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    ips.avg_fragmentation_in_percent > 5.0 -- Filtra apenas índices que precisam de atenção
    AND i.name IS NOT NULL -- Ignora heaps (tabelas sem clustered index)
ORDER BY 
    'Fragmentation (%)' DESC;