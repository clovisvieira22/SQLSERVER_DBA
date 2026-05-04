SELECT wait_type, wait_time_ms / 1000.0 AS wait_time_s,
       100.0 * wait_time_ms / SUM(wait_time_ms) OVER() AS percentage
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
    'SLEEP_TASK', 'BROKER_RECEIVE_WAITFOR', 'CHECKPOINT_QUEUE',
    'DISPATCHER_QUEUE_SEMAPHORE', 'SOS_WORK_DISPATCHER', 
    'CLR_AUTO_EVENT', 'DIRTY_PAGE_POLL', 'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
    'LAZYWRITER_SLEEP', 'XE_TIMER_EVENT', 'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP'
)
ORDER BY wait_time_ms DESC;


-- Zerar estatísticas
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR);

-- Locked Pages?

SELECT locked_page_allocations_kb 
FROM sys.dm_os_process_memory;

SELECT wait_type, wait_time_ms / 1000.0 AS wait_time_s,
       100.0 * wait_time_ms / SUM(wait_time_ms) OVER() AS percentage
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
    'SLEEP_TASK', 'BROKER_RECEIVE_WAITFOR', 'CHECKPOINT_QUEUE',
    'DISPATCHER_QUEUE_SEMAPHORE', 'SOS_WORK_DISPATCHER', 
    'CLR_AUTO_EVENT', 'DIRTY_PAGE_POLL', 'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
    'LAZYWRITER_SLEEP', 'XE_TIMER_EVENT', 'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP'
)
ORDER BY wait_time_ms DESC;


-- Zerar estatísticas
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR);

-- Locked Pages?

SELECT locked_page_allocations_kb 
FROM sys.dm_os_process_memory;

SELECT @@VERSION;

ALTER DATABASE [PortalMega] 
SET TARGET_RECOVERY_TIME = 60 SECONDS;

ALTER DATABASE [PortalTVSD] 
SET TARGET_RECOVERY_TIME = 60 SECONDS;

ALTER DATABASE [mega_ofc] 
SET TARGET_RECOVERY_TIME = 60 SECONDS;

ALTER DATABASE [tvsd_ofc] 
SET TARGET_RECOVERY_TIME = 60 SECONDS;

DBCC FREEPROCCACHE;
