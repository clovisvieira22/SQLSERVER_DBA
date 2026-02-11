SELECT 
    total_physical_memory_kb / 1024 AS total_physical_memory_MB,
    available_physical_memory_kb / 1024 AS available_physical_memory_MB,
    total_page_file_kb / 1024 AS total_page_file_MB,
    available_page_file_kb / 1024 AS available_page_file_MB,
    system_memory_state_desc
FROM sys.dm_os_sys_memory;

SELECT 
    physical_memory_in_use_kb / 1024 AS physical_memory_MB,
    large_page_allocations_kb / 1024 AS large_page_MB,
    locked_page_allocations_kb / 1024 AS locked_page_MB,
    page_fault_count,
    memory_utilization_percentage,
    available_commit_limit_kb / 1024 AS available_commit_limit_MB,
    process_physical_memory_low,
    process_virtual_memory_low
FROM sys.dm_os_process_memory;

SELECT 
    type,
    SUM(virtual_memory_committed_kb) / 1024 AS vm_committed_MB,
    SUM(virtual_memory_reserved_kb) / 1024 AS vm_reserved_MB,
    SUM(awe_allocated_kb) / 1024 AS awe_allocated_MB,
    SUM(shared_memory_committed_kb) / 1024 AS shared_memory_committed_MB
FROM sys.dm_os_memory_clerks
GROUP BY type
ORDER BY vm_committed_MB DESC;
