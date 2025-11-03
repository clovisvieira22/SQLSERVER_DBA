/*
  =========================================================================
  Script for checking index fragmentation in SQL Server

  Recommended actions based on fragmentation levels:
  - Fragmentation > 30%: REBUILD the index
  - Fragmentation between 5% and 30%: REORGANIZE the index
  - Fragmentation <= 5%: No action needed
  1. Connect to database in SSMS.
  2. Execute this script.

  The result print index fragmentation above 5%
    with the recommended action (REORGANIZE or REBUILD).
  
  =========================================================================
*/

SELECT 
    OBJECT_NAME(ips.object_id) AS 'Table',
    i.name AS 'Index',
    ips.index_type_desc AS 'Index Type',
    ips.avg_fragmentation_in_percent AS 'Fragmentation (%)',
    ips.page_count AS 'Total Pages',
    CASE 
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'REBUILD'
        WHEN ips.avg_fragmentation_in_percent > 5 AND ips.avg_fragmentation_in_percent <= 30 THEN 'REORGANIZE'
        ELSE 'No need action!'
    END AS 'Needed Action'
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') AS ips
INNER JOIN 
    sys.indexes AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    ips.avg_fragmentation_in_percent > 5.0 -- Only show indexes with fragmentation above 5%
    AND i.name IS NOT NULL
ORDER BY 
    'Fragmentation (%)' DESC;


