SELECT 
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    c.client_net_address,
    s.status
FROM sys.dm_exec_sessions s
JOIN sys.dm_exec_connections c ON s.session_id = c.session_id;

SELECT 
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.login_time,
    s.status,
    d.name AS DatabaseName
FROM 
    sys.dm_exec_sessions s
JOIN 
    sys.dm_exec_connections c ON s.session_id = c.session_id
JOIN 
    sys.databases d ON s.database_id = d.database_id
WHERE 
    d.name = 'dbMarinUniorkaTemp'; 


kill 99;
