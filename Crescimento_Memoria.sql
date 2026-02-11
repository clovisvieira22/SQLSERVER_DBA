SELECT 
    total_physical_memory_kb / 1024 AS TotalRAM_MB,
    available_physical_memory_kb / 1024 AS FreeRAM_MB,
    process_physical_memory_low,
    physical_memory_in_use_kb / 1024 AS SQLUsedRAM_MB
FROM sys.dm_os_process_memory;
