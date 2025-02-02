-- =============================================
-- SQL Server Stored Procedure Performance Diagnostics
-- Glenn Berry’s Diagnostic Information Queries (SQL Server 2014)
-- =============================================

-- Analyzes execution count, CPU usage, memory consumption, and disk I/O activity 
-- to identify stored procedures that may need optimization.

-- =============================================
-- 1. Top Cached Stored Procedures by Execution Count
-- =============================================
SELECT TOP(100) 
    p.name AS [Stored Procedure Name], 
    qs.execution_count,
    ISNULL(qs.execution_count / DATEDIFF(Minute, qs.cached_time, GETDATE()), 0) AS [Calls per Minute],
    qs.total_worker_time / qs.execution_count AS [Avg Worker Time (ms)], 
    qs.total_worker_time AS [Total Worker Time (ms)],  
    qs.total_elapsed_time,
    qs.total_elapsed_time / qs.execution_count AS [Avg Elapsed Time (ms)],
    qs.cached_time
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
    ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY qs.execution_count DESC 
OPTION (RECOMPILE);

-- =============================================
-- 2. Top Cached Stored Procedures by Average Elapsed Time
-- =============================================
SELECT TOP(25) 
    p.name AS [Stored Procedure Name], 
    qs.min_elapsed_time, 
    qs.total_elapsed_time / qs.execution_count AS [Avg Elapsed Time (ms)], 
    qs.max_elapsed_time, 
    qs.last_elapsed_time, 
    qs.total_elapsed_time, 
    qs.execution_count, 
    ISNULL(qs.execution_count / DATEDIFF(Minute, qs.cached_time, GETDATE()), 0) AS [Calls per Minute], 
    qs.total_worker_time / qs.execution_count AS [Avg Worker Time (ms)], 
    qs.total_worker_time AS [Total Worker Time (ms)], 
    qs.cached_time
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
    ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY [Avg Elapsed Time (ms)] DESC 
OPTION (RECOMPILE);

-- =============================================
-- 3. Top Cached Stored Procedures by Total Worker Time (CPU Cost)
-- =============================================
SELECT TOP(25) 
    p.name AS [Stored Procedure Name], 
    qs.total_worker_time AS [Total Worker Time (ms)], 
    qs.total_worker_time / qs.execution_count AS [Avg Worker Time (ms)], 
    qs.execution_count, 
    ISNULL(qs.execution_count / DATEDIFF(Minute, qs.cached_time, GETDATE()), 0) AS [Calls per Minute],
    qs.total_elapsed_time, 
    qs.total_elapsed_time / qs.execution_count AS [Avg Elapsed Time (ms)], 
    qs.cached_time
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
    ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_worker_time DESC 
OPTION (RECOMPILE);

-- =============================================
-- 4. Top Cached Stored Procedures by Total Logical Reads (Memory Pressure)
-- =============================================
SELECT TOP(25) 
    p.name AS [Stored Procedure Name], 
    qs.total_logical_reads AS [Total Logical Reads], 
    qs.total_logical_reads / qs.execution_count AS [Avg Logical Reads], 
    qs.execution_count, 
    ISNULL(qs.execution_count / DATEDIFF(Minute, qs.cached_time, GETDATE()), 0) AS [Calls per Minute], 
    qs.total_elapsed_time, 
    qs.total_elapsed_time / qs.execution_count AS [Avg Elapsed Time (ms)], 
    qs.cached_time
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
    ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
ORDER BY qs.total_logical_reads DESC 
OPTION (RECOMPILE);

-- =============================================
-- 5. Top Cached Stored Procedures by Total Physical Reads (Disk Read I/O)
-- =============================================
SELECT TOP(25) 
    p.name AS [Stored Procedure Name], 
    qs.total_physical_reads AS [Total Physical Reads], 
    qs.total_physical_reads / qs.execution_count AS [Avg Physical Reads], 
    qs.execution_count, 
    qs.total_logical_reads, 
    qs.total_elapsed_time, 
    qs.total_elapsed_time / qs.execution_count AS [Avg Elapsed Time (ms)], 
    qs.cached_time 
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
    ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
AND qs.total_physical_reads > 0
ORDER BY qs.total_physical_reads DESC, qs.total_logical_reads DESC 
OPTION (RECOMPILE);

-- =============================================
-- 6. Top Cached Stored Procedures by Total Logical Writes (Write I/O Pressure)
-- =============================================
SELECT TOP(25) 
    p.name AS [Stored Procedure Name], 
    qs.total_logical_writes AS [Total Logical Writes], 
    qs.total_logical_writes / qs.execution_count AS [Avg Logical Writes], 
    qs.execution_count, 
    ISNULL(qs.execution_count / DATEDIFF(Minute, qs.cached_time, GETDATE()), 0) AS [Calls per Minute], 
    qs.total_elapsed_time, 
    qs.total_elapsed_time / qs.execution_count AS [Avg Elapsed Time (ms)], 
    qs.cached_time
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
    ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
AND qs.total_logical_writes > 0
ORDER BY qs.total_logical_writes DESC 
OPTION (RECOMPILE);

-- =============================================
-- End of Script
-- =============================================
