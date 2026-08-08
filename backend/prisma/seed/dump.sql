-- Seed dump for devops_cli (truncate + sample data)
-- Applied via: npm run db:seed
SET search_path TO devops_cli;

TRUNCATE TABLE
  copy_history,
  command_templates,
  command_properties,
  commands,
  feature_requests,
  categories
RESTART IDENTITY CASCADE;

INSERT INTO categories (name, description, icon, color) VALUES
('MySQL', 'MySQL database commands and utilities', 'database', '#00758F'),
('PostgreSQL', 'PostgreSQL database commands and utilities', 'database', '#336791'),
('MongoDB', 'MongoDB NoSQL database commands', 'leaf', '#13AA52'),
('Redis', 'Redis cache and key-value store commands', 'zap', '#DC382D'),
('Docker', 'Docker container and image commands', 'box', '#2496ED'),
('Kubernetes', 'Kubernetes cluster orchestration commands', 'compass', '#326CE5'),
('AWS', 'Amazon Web Services CLI commands', 'cloud', '#FF9900'),
('GCP', 'Google Cloud Platform commands', 'cloud', '#4285F4'),
('Azure', 'Microsoft Azure CLI commands', 'cloud', '#0078D4'),
('Git', 'Git version control commands', 'gitbranch', '#F1502F'),
('Linux', 'Linux system and network commands', 'terminal', '#000000'),
('Monitoring', 'Monitoring, logging, and observability tools', 'activity', '#FF6B6B');

-- ============================================
-- SAMPLE DATA - COMMANDS
-- ============================================

-- MySQL Dump
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysqldump',
  'Export MySQL database to SQL file for backup or migration',
  'mysqldump -h {{host}} -u {{username}} -p{{password}} -P {{port}} {{additional_options}} {{database}} > {{output_file}}',
  'MySQL',
  ARRAY['backup', 'dump', 'export', 'database', 'sql'],
  'mysqldump -h prod-db-01 -u admin -ppassword123 -P 3306 --single-transaction customer_db > backup_2024.sql',
  'Exports complete database structure and data. Use --single-transaction for InnoDB to avoid locking.'
);

-- MySQL Restore
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-restore',
  'Import MySQL database from SQL file',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} {{database}} < {{input_file}}',
  'MySQL',
  ARRAY['restore', 'import', 'database', 'sql'],
  'mysql -h localhost -u admin -ppassword -P 3306 mydb < backup.sql',
  'Restores a database from exported SQL file.'
);

-- PostgreSQL Dump
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg_dump',
  'Export PostgreSQL database to SQL file',
  'pg_dump -h {{host}} -U {{username}} -d {{database}} -p {{port}} {{additional_options}} > {{output_file}}',
  'PostgreSQL',
  ARRAY['backup', 'dump', 'export', 'database'],
  'pg_dump -h localhost -U postgres -d mydb -p 5432 --verbose > backup.sql',
  'Creates SQL script backup of PostgreSQL database. Use -F c for custom binary format.'
);

-- PostgreSQL Restore
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg_restore',
  'Restore PostgreSQL database from backup',
  'pg_restore -h {{host}} -U {{username}} -d {{database}} -p {{port}} {{additional_options}} {{backup_file}}',
  'PostgreSQL',
  ARRAY['restore', 'import', 'database'],
  'pg_restore -h localhost -U postgres -d mydb -p 5432 -v backup.dump',
  'Restores database from pg_dump custom format backup.'
);

-- MongoDB Dump
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mongodump',
  'Create binary backup of MongoDB database',
  'mongodump --uri="mongodb://{{username}}:{{password}}@{{host}}:{{port}}/{{database}}" {{additional_options}} --out {{output_dir}}',
  'MongoDB',
  ARRAY['backup', 'dump', 'export', 'database'],
  'mongodump --uri="mongodb://admin:pass@localhost:27017/mydb" --out ./backups/db_2024',
  'Creates binary backup of MongoDB. Use --archive for single file backup.'
);

-- MongoDB Restore
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mongorestore',
  'Restore MongoDB from backup',
  'mongorestore --uri="mongodb://{{username}}:{{password}}@{{host}}:{{port}}" {{additional_options}} {{backup_path}}',
  'MongoDB',
  ARRAY['restore', 'import', 'database'],
  'mongorestore --uri="mongodb://admin:pass@localhost:27017" ./backups/db_2024',
  'Restores collections from mongodump backup.'
);

-- Redis Backup
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'redis-cli-save',
  'Create Redis database backup',
  'redis-cli -h {{host}} -p {{port}} {{authentication}} BGSAVE',
  'Redis',
  ARRAY['backup', 'redis', 'save'],
  'redis-cli -h localhost -p 6379 -a password123 BGSAVE',
  'BGSAVE creates background save without blocking. Use SAVE for synchronous backup.'
);

-- Docker PS
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-ps',
  'List all Docker containers',
  'docker ps {{options}}',
  'Docker',
  ARRAY['container', 'list', 'ps', 'docker'],
  'docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"',
  'Lists containers. Add -a for all (including stopped). Use --format for custom output.'
);

-- Docker Logs
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-logs',
  'View Docker container logs',
  'docker logs {{options}} {{container_id}}',
  'Docker',
  ARRAY['container', 'logs', 'debug', 'docker'],
  'docker logs --tail 100 -f container_name',
  'View logs. -f for follow (stream), --tail for last N lines.'
);

-- Kubernetes Get Pods
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'kubectl-get-pods',
  'List Kubernetes pods',
  'kubectl get pods -n {{namespace}} {{options}}',
  'Kubernetes',
  ARRAY['pod', 'list', 'kubernetes'],
  'kubectl get pods -n default -o wide',
  'Lists pods. Use -n for namespace, -o wide for extra details.'
);

-- Kubernetes Describe Pod
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'kubectl-describe-pod',
  'Describe Kubernetes pod details',
  'kubectl describe pod {{pod_name}} -n {{namespace}}',
  'Kubernetes',
  ARRAY['pod', 'debug', 'kubernetes'],
  'kubectl describe pod app-pod-1 -n production',
  'Shows detailed information about a pod, useful for troubleshooting.'
);

-- AWS S3 List
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-s3-ls',
  'List AWS S3 buckets or bucket contents',
  'aws s3 ls {{bucket_path}} {{options}}',
  'AWS',
  ARRAY['s3', 'list', 'aws'],
  'aws s3 ls s3://my-bucket/path/ --recursive',
  'Lists S3 buckets or contents. Use --recursive for full listing.'
);

-- AWS EC2 List Instances
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-ec2-instances',
  'List AWS EC2 instances',
  'aws ec2 describe-instances {{options}}',
  'AWS',
  ARRAY['ec2', 'instance', 'aws'],
  'aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output table',
  'Lists EC2 instances with details. Use --query to filter results.'
);

-- Linux Find Files
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'find-files',
  'Find files in Linux filesystem',
  'find {{directory}} -name {{pattern}} {{options}}',
  'Linux',
  ARRAY['find', 'search', 'linux'],
  'find /var/log -name "*.log" -type f -mtime -7',
  'Search for files. -mtime for modified time, -type f for files only.'
);

-- ============================================
-- SAMPLE DATA - COMMAND PROPERTIES
-- ============================================

-- mysqldump properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (1, 'host', 'text', 'localhost', true, '192.168.1.1 or db.example.com', 'Database host address or IP', 1),
  (1, 'username', 'text', 'root', true, 'db_user', 'Database username', 2),
  (1, 'password', 'password', '', false, 'your_password', 'Database password (leave empty if no password)', 3),
  (1, 'port', 'number', '3306', false, '3306', 'MySQL port number', 4),
  (1, 'database', 'text', '', true, 'database_name', 'Database name to dump', 5),
  (1, 'output_file', 'text', 'backup.sql', true, 'backup_2024.sql', 'Output SQL file path and name', 6),
  (1, 'additional_options', 'text', '--single-transaction --lock-tables=false', false, '--single-transaction', 'Additional mysqldump options', 7);

-- mysql-restore properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (2, 'host', 'text', 'localhost', true, '192.168.1.1', 'Database host', 1),
  (2, 'username', 'text', 'root', true, 'db_user', 'Database username', 2),
  (2, 'password', 'password', '', false, 'password', 'Database password', 3),
  (2, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (2, 'database', 'text', '', true, 'database_name', 'Target database', 5),
  (2, 'input_file', 'text', 'backup.sql', true, 'backup.sql', 'SQL file to import', 6);

-- pg_dump properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (3, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (3, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (3, 'database', 'text', '', true, 'database_name', 'Database to backup', 3),
  (3, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 4),
  (3, 'output_file', 'text', 'backup.sql', true, 'backup.sql', 'Output file', 5),
  (3, 'additional_options', 'text', '--verbose', false, '--verbose, -F c, -Z 9', 'Additional options', 6);

-- pg_restore properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (4, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (4, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (4, 'database', 'text', '', true, 'database_name', 'Target database', 3),
  (4, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 4),
  (4, 'backup_file', 'text', 'backup.dump', true, 'backup.dump', 'Backup file to restore', 5),
  (4, 'additional_options', 'text', '-v', false, '-v, -j 4', 'Additional options', 6);

-- mongodump properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (5, 'username', 'text', 'admin', false, 'mongo_user', 'MongoDB username', 1),
  (5, 'password', 'password', '', false, 'password', 'MongoDB password', 2),
  (5, 'host', 'text', 'localhost', true, '192.168.1.1', 'MongoDB host', 3),
  (5, 'port', 'number', '27017', false, '27017', 'MongoDB port', 4),
  (5, 'database', 'text', '', false, 'database_name', 'Database to backup (omit for all)', 5),
  (5, 'output_dir', 'text', './backups', true, './backups/db_2024', 'Output directory', 6),
  (5, 'additional_options', 'text', '', false, '--gzip, --archive filename', 'Additional options', 7);

-- mongorestore properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (6, 'username', 'text', 'admin', false, 'mongo_user', 'MongoDB username', 1),
  (6, 'password', 'password', '', false, 'password', 'MongoDB password', 2),
  (6, 'host', 'text', 'localhost', true, '192.168.1.1', 'MongoDB host', 3),
  (6, 'port', 'number', '27017', false, '27017', 'MongoDB port', 4),
  (6, 'backup_path', 'text', './backups', true, './backups/db_2024', 'Backup directory or archive', 5),
  (6, 'additional_options', 'text', '', false, '--drop, --gzip', 'Additional options', 6);

-- redis-cli-save properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (7, 'host', 'text', 'localhost', true, '192.168.1.1', 'Redis host', 1),
  (7, 'port', 'number', '6379', false, '6379', 'Redis port', 2),
  (7, 'authentication', 'text', '', false, '-a password123', 'Redis password/auth string', 3);

-- docker-ps properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (8, 'options', 'text', '-a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"', false, '-a, --no-trunc, --filter', 'Docker ps options', 1);

-- docker-logs properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (9, 'options', 'text', '--tail 100 -f', false, '--tail 50, --since, --until', 'Log options', 1),
  (9, 'container_id', 'text', '', true, 'container_name or id', 'Container name or ID', 2);

-- kubectl-get-pods properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (10, 'namespace', 'text', 'default', true, 'namespace_name', 'Kubernetes namespace', 1),
  (10, 'options', 'text', '-o wide', false, '-o wide, -o json, --all-namespaces', 'Kubectl options', 2);

-- kubectl-describe-pod properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (11, 'pod_name', 'text', '', true, 'pod-name', 'Pod name to describe', 1),
  (11, 'namespace', 'text', 'default', true, 'namespace_name', 'Kubernetes namespace', 2);

-- aws-s3-ls properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (12, 'bucket_path', 'text', 's3://', true, 's3://bucket-name/path', 'S3 bucket path', 1),
  (12, 'options', 'text', '--recursive', false, '--recursive, --human-readable', 'AWS CLI options', 2);

-- aws-ec2-instances properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (13, 'options', 'text', '--query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output table', false, 'AWS query options', 'Filter and output options', 1);

-- find-files properties
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (14, 'directory', 'text', '/var/log', true, '/home, /var, /etc', 'Directory to search in', 1),
  (14, 'pattern', 'text', '*.log', true, '*.log, *.txt', 'File name pattern', 2),
  (14, 'options', 'text', '-type f -mtime -7', false, '-type f, -mtime -7, -size +10M', 'Find options', 3);

-- ============================================
-- LINUX TROUBLESHOOTING (HIGH CPU / MEMORY / DISK)
-- ============================================

-- HIGH CPU
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'top',
  'Real-time process view for high CPU troubleshooting',
  'top {{options}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'process', 'monitoring', 'linux'],
  'top',
  'Look for processes with high %CPU and load average above CPU core count.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'htop',
  'Interactive process viewer for CPU and memory',
  'htop {{options}}',
  'Linux',
  ARRAY['cpu', 'memory', 'troubleshooting', 'process', 'monitoring', 'linux'],
  'htop',
  'Interactive alternative to top. Sort by CPU or MEM to find heavy processes.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'ps-top-cpu',
  'List top CPU-consuming processes',
  'ps aux --sort=-%cpu | head -n {{count}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'process', 'ps', 'linux'],
  'ps aux --sort=-%cpu | head -n 10',
  'Shows highest CPU processes. Useful when top is not available.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pidstat-cpu',
  'Per-process CPU usage over time',
  'pidstat -u {{interval}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'pidstat', 'monitoring', 'linux'],
  'pidstat -u 1',
  'Reports CPU usage by process at each interval (seconds).'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'uptime',
  'Show system load average',
  'uptime',
  'Linux',
  ARRAY['cpu', 'load', 'troubleshooting', 'monitoring', 'linux'],
  'uptime',
  'Load average > number of CPU cores often indicates CPU pressure.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mpstat',
  'CPU usage per core',
  'mpstat -P ALL {{interval}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'mpstat', 'monitoring', 'linux'],
  'mpstat -P ALL 1',
  'Check high %user or %system time across cores.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'sar-cpu',
  'CPU usage report over samples',
  'sar -u {{interval}} {{count}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'sar', 'monitoring', 'linux'],
  'sar -u 1 5',
  'Historical/sampled CPU report. Requires sysstat package.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'kill-process',
  'Force-kill a high CPU or memory process by PID',
  'kill -9 {{pid}}',
  'Linux',
  ARRAY['cpu', 'memory', 'troubleshooting', 'kill', 'process', 'linux'],
  'kill -9 1234',
  'Use after identifying the PID. Prefer kill <PID> before kill -9 when possible.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pgrep',
  'Find process IDs by name',
  'pgrep -f {{process_name}}',
  'Linux',
  ARRAY['cpu', 'memory', 'troubleshooting', 'process', 'linux'],
  'pgrep -f nginx',
  'Locate PIDs before kill, renice, or pmap.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'nice',
  'Run a command with lower CPU priority',
  'nice -n {{priority}} {{command}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'nice', 'priority', 'linux'],
  'nice -n 10 backup.sh',
  'Positive nice value lowers priority (less CPU contention).'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'renice',
  'Change priority of a running process',
  'renice {{priority}} -p {{pid}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'renice', 'priority', 'linux'],
  'renice 10 -p 1234',
  'Adjust niceness of an existing PID to reduce CPU impact.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'stress-cpu',
  'Generate CPU load for stress testing',
  'stress --cpu {{cores}}',
  'Linux',
  ARRAY['cpu', 'troubleshooting', 'stress', 'test', 'linux'],
  'stress --cpu 4',
  'Test CPU capacity and monitoring. Stop with Ctrl+C when done.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'vmstat',
  'System summary including CPU, memory, and I/O',
  'vmstat {{interval}}',
  'Linux',
  ARRAY['cpu', 'memory', 'disk', 'troubleshooting', 'vmstat', 'monitoring', 'linux'],
  'vmstat 1',
  'Watch r/b queues, swap activity (si/so), and CPU idle/wait.'
);

-- HIGH MEMORY
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'free-memory',
  'Check RAM and swap usage',
  'free -h',
  'Linux',
  ARRAY['memory', 'swap', 'troubleshooting', 'monitoring', 'linux'],
  'free -h',
  'Look for high used memory and heavy swap usage.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'ps-top-mem',
  'List top memory-consuming processes',
  'ps aux --sort=-%mem | head -n {{count}}',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'process', 'ps', 'linux'],
  'ps aux --sort=-%mem | head -n 10',
  'Identify processes with high %MEM before killing or limiting them.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'smem',
  'Detailed per-process memory usage',
  'smem -r {{options}}',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'smem', 'monitoring', 'linux'],
  'smem -r',
  'Shows USS/PSS/RSS style breakdown. Requires smem package.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'swapon-show',
  'Show active swap devices and usage',
  'swapon --show',
  'Linux',
  ARRAY['memory', 'swap', 'troubleshooting', 'linux'],
  'swapon --show',
  'Confirm swap is enabled and how much is in use.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'dmesg-oom',
  'Check kernel logs for OOM killer events',
  'dmesg | grep -i oom',
  'Linux',
  ARRAY['memory', 'oom', 'troubleshooting', 'dmesg', 'linux'],
  'dmesg | grep -i oom',
  'OOM Killer messages mean the system ran out of memory.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'proc-meminfo',
  'Detailed memory information from /proc',
  'cat /proc/meminfo',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'proc', 'linux'],
  'cat /proc/meminfo',
  'Inspect MemAvailable, SwapFree, and related counters.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'sar-memory',
  'Memory usage report over samples',
  'sar -r {{interval}} {{count}}',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'sar', 'monitoring', 'linux'],
  'sar -r 1 5',
  'Sampled memory report. Requires sysstat package.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'drop-caches',
  'Clear page cache, dentries, and inodes',
  'sync; echo 3 > /proc/sys/vm/drop_caches',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'cache', 'linux'],
  'sync; echo 3 > /proc/sys/vm/drop_caches',
  'Requires root. Use carefully; only frees reclaimable cache.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'create-swapfile',
  'Create and enable a swap file',
  'fallocate -l {{size}} {{swapfile}} && mkswap {{swapfile}} && swapon {{swapfile}}',
  'Linux',
  ARRAY['memory', 'swap', 'troubleshooting', 'linux'],
  'fallocate -l 2G /swapfile && mkswap /swapfile && swapon /swapfile',
  'Temporary relief for memory pressure. Persist in /etc/fstab if needed.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pmap',
  'Memory map of a process',
  'pmap -x {{pid}}',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'pmap', 'process', 'linux'],
  'pmap -x 1234',
  'Inspect address space and mapped sizes for a PID.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'numastat',
  'NUMA memory statistics',
  'numastat {{options}}',
  'Linux',
  ARRAY['memory', 'numa', 'troubleshooting', 'linux'],
  'numastat',
  'Useful on multi-node NUMA hosts with uneven memory use.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'proc-status',
  'Memory details for a specific process',
  'cat /proc/{{pid}}/status',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'proc', 'process', 'linux'],
  'cat /proc/1234/status',
  'Check VmRSS, VmSize, and related fields for the PID.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'sysctl-overcommit',
  'Check memory overcommit setting',
  'sysctl vm.overcommit_memory',
  'Linux',
  ARRAY['memory', 'troubleshooting', 'sysctl', 'linux'],
  'sysctl vm.overcommit_memory',
  'Shows how the kernel handles memory overcommit.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'journalctl-oom',
  'Find OOM events in kernel journal logs',
  'journalctl -k | grep -i oom',
  'Linux',
  ARRAY['memory', 'oom', 'troubleshooting', 'journalctl', 'linux'],
  'journalctl -k | grep -i oom',
  'Alternative to dmesg for OOM Killer history via systemd journal.'
);

-- DISK FULL
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'df-disk',
  'Check filesystem disk space usage',
  'df -h {{options}}',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'df', 'monitoring', 'linux'],
  'df -h',
  'Disk usage at 90%+ needs cleanup or expansion.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'du-root',
  'Find largest directories from filesystem root',
  'du -sh {{path}}/* | sort -hr',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'du', 'linux'],
  'du -sh /* | sort -hr',
  'Identify which top-level paths consume the most space.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'du-var',
  'Check large directories under /var',
  'du -sh /var/* | sort -hr',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'du', 'logs', 'linux'],
  'du -sh /var/* | sort -hr',
  'Logs and package caches under /var often fill disks.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'lsblk',
  'List block devices and mount points',
  'lsblk {{options}}',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'lsblk', 'linux'],
  'lsblk',
  'Confirm disks, partitions, and mount layout.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'iostat',
  'Check disk I/O utilization and wait',
  'iostat -xh {{interval}}',
  'Linux',
  ARRAY['disk', 'io', 'troubleshooting', 'iostat', 'monitoring', 'linux'],
  'iostat -xh 1',
  'High %util or await can explain slow disks even before full capacity.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'df-inodes',
  'Check inode usage on filesystems',
  'df -i {{options}}',
  'Linux',
  ARRAY['disk', 'inode', 'troubleshooting', 'df', 'linux'],
  'df -i',
  'Disk can be "full" from inode exhaustion even with free bytes.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'lsof-deleted',
  'Find deleted files still held open by processes',
  'lsof | grep deleted',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'lsof', 'linux'],
  'lsof | grep deleted',
  'Space is freed only after the holding process closes or restarts.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'journalctl-vacuum',
  'Clean old systemd journal logs',
  'journalctl --vacuum-time={{days}}d',
  'Linux',
  ARRAY['disk', 'logs', 'troubleshooting', 'journalctl', 'linux'],
  'journalctl --vacuum-time=7d',
  'Reclaim space from journald while keeping recent logs.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'logrotate-force',
  'Force log rotation now',
  'logrotate -f {{config}}',
  'Linux',
  ARRAY['disk', 'logs', 'troubleshooting', 'logrotate', 'linux'],
  'logrotate -f /etc/logrotate.conf',
  'Rotate oversized logs immediately using the system config.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'apt-clean',
  'Remove downloaded package cache (Debian/Ubuntu)',
  'apt clean',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'apt', 'cleanup', 'linux'],
  'apt clean',
  'Frees package cache under /var/cache/apt.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'yum-clean',
  'Remove package cache (RHEL/CentOS)',
  'yum clean all',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'yum', 'cleanup', 'linux'],
  'yum clean all',
  'Clears yum metadata and package caches.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'clean-tmp',
  'Remove files under /tmp',
  'rm -rf /tmp/*',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'cleanup', 'tmp', 'linux'],
  'rm -rf /tmp/*',
  'Destructive. Ensure nothing important is using /tmp first.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'find-large-files',
  'Find files larger than a given size',
  'find {{path}} -xdev -type f -size +{{size}} -exec ls -lh {} \;',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'find', 'linux'],
  'find / -xdev -type f -size +1G -exec ls -lh {} \;',
  'Locate huge files that fill the disk.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'ncdu',
  'Interactive disk usage explorer',
  'ncdu {{path}}',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'ncdu', 'linux'],
  'ncdu /',
  'Interactive alternative to du for drilling into large paths.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'watch-df',
  'Watch disk usage refresh periodically',
  'watch -n {{interval}} df -h',
  'Linux',
  ARRAY['disk', 'troubleshooting', 'monitoring', 'df', 'linux'],
  'watch -n 5 df -h',
  'Monitor free space while cleaning or expanding disk.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'tune2fs-inodes',
  'Show inode count for an ext filesystem',
  'tune2fs -l {{device}} | grep "Inode count"',
  'Linux',
  ARRAY['disk', 'inode', 'troubleshooting', 'tune2fs', 'linux'],
  'tune2fs -l /dev/sda1 | grep "Inode count"',
  'Inspect inode capacity on ext2/3/4 filesystems.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'fstrim',
  'Discard unused blocks on SSDs',
  'fstrim -av',
  'Linux',
  ARRAY['disk', 'ssd', 'troubleshooting', 'fstrim', 'linux'],
  'fstrim -av',
  'TRIM unused blocks on mounted SSD filesystems.'
);

-- ============================================
-- DOCKER (containers, images, network, volume, system, compose)
-- ============================================

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-run',
  'Create and start a new container',
  'docker run {{options}} {{image}} {{command}}',
  'Docker',
  ARRAY['container', 'run', 'start', 'docker'],
  'docker run -d --name web -p 8080:80 nginx:latest',
  'Common options: -d detach, --name, -p publish ports, -v volumes, -e env, --rm.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-start',
  'Start one or more stopped containers',
  'docker start {{options}} {{container}}',
  'Docker',
  ARRAY['container', 'start', 'docker'],
  'docker start web',
  'Starts existing containers by name or ID.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-stop',
  'Stop one or more running containers',
  'docker stop {{options}} {{container}}',
  'Docker',
  ARRAY['container', 'stop', 'docker'],
  'docker stop web',
  'Sends SIGTERM then SIGKILL after timeout. Use -t to change wait time.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-restart',
  'Restart one or more containers',
  'docker restart {{options}} {{container}}',
  'Docker',
  ARRAY['container', 'restart', 'docker'],
  'docker restart web',
  'Stops then starts the container(s).'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-kill',
  'Force kill a running container',
  'docker kill {{options}} {{container}}',
  'Docker',
  ARRAY['container', 'kill', 'stop', 'docker'],
  'docker kill web',
  'Sends SIGKILL by default. Prefer docker stop for graceful shutdown.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-rm',
  'Remove one or more containers',
  'docker rm {{options}} {{container}}',
  'Docker',
  ARRAY['container', 'remove', 'cleanup', 'docker'],
  'docker rm -f web',
  'Use -f to force remove a running container. Use -v to remove anonymous volumes.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-exec',
  'Run a command inside a running container',
  'docker exec {{options}} {{container}} {{command}}',
  'Docker',
  ARRAY['container', 'exec', 'shell', 'debug', 'docker'],
  'docker exec -it web /bin/bash',
  'Use -it for interactive shell. Use -u to run as a specific user.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-inspect',
  'Show low-level information on Docker objects',
  'docker inspect {{options}} {{name}}',
  'Docker',
  ARRAY['inspect', 'debug', 'container', 'image', 'docker'],
  'docker inspect web',
  'Works for containers, images, networks, and volumes. Use --format for specific fields.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-stats',
  'Live resource usage statistics for containers',
  'docker stats {{options}} {{container}}',
  'Docker',
  ARRAY['stats', 'cpu', 'memory', 'monitoring', 'container', 'docker'],
  'docker stats',
  'Shows CPU, memory, network, and block I/O. Omit container to watch all.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-top',
  'Display running processes inside a container',
  'docker top {{container}} {{options}}',
  'Docker',
  ARRAY['container', 'process', 'debug', 'docker'],
  'docker top web',
  'Like ps inside the container namespace.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-cp',
  'Copy files between container and host',
  'docker cp {{source}} {{destination}}',
  'Docker',
  ARRAY['container', 'copy', 'files', 'docker'],
  'docker cp web:/var/log/nginx/access.log ./access.log',
  'Format: container:path or host path for source/destination.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-rename',
  'Rename an existing container',
  'docker rename {{old_name}} {{new_name}}',
  'Docker',
  ARRAY['container', 'rename', 'docker'],
  'docker rename web web-old',
  'Changes the container name without recreating it.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-pause',
  'Pause all processes in a container',
  'docker pause {{container}}',
  'Docker',
  ARRAY['container', 'pause', 'docker'],
  'docker pause web',
  'Freezes processes using cgroups freezer. Resume with docker unpause.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-unpause',
  'Unpause all processes in a container',
  'docker unpause {{container}}',
  'Docker',
  ARRAY['container', 'unpause', 'docker'],
  'docker unpause web',
  'Resumes a previously paused container.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-attach',
  'Attach local stdin/stdout to a running container',
  'docker attach {{options}} {{container}}',
  'Docker',
  ARRAY['container', 'attach', 'debug', 'docker'],
  'docker attach web',
  'Detach with CTRL-p CTRL-q by default (does not stop container).'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-images',
  'List local Docker images',
  'docker images {{options}}',
  'Docker',
  ARRAY['image', 'list', 'docker'],
  'docker images',
  'Shows repository, tag, image ID, created, and size. Alias: docker image ls.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-pull',
  'Download an image from a registry',
  'docker pull {{options}} {{image}}',
  'Docker',
  ARRAY['image', 'pull', 'registry', 'docker'],
  'docker pull nginx:latest',
  'Pulls image layers from Docker Hub or configured registry.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-push',
  'Upload an image to a registry',
  'docker push {{options}} {{image}}',
  'Docker',
  ARRAY['image', 'push', 'registry', 'docker'],
  'docker push myuser/myapp:1.0',
  'Requires docker login and a properly tagged image.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-build',
  'Build an image from a Dockerfile',
  'docker build {{options}} -t {{tag}} {{context}}',
  'Docker',
  ARRAY['image', 'build', 'dockerfile', 'docker'],
  'docker build -t myapp:1.0 .',
  'Use -f to set Dockerfile path, --no-cache to rebuild without cache.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-rmi',
  'Remove one or more images',
  'docker rmi {{options}} {{image}}',
  'Docker',
  ARRAY['image', 'remove', 'cleanup', 'docker'],
  'docker rmi nginx:old',
  'Use -f to force remove. Remove dependent containers first if needed.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-tag',
  'Create a tag that refers to an image',
  'docker tag {{source_image}} {{target_image}}',
  'Docker',
  ARRAY['image', 'tag', 'registry', 'docker'],
  'docker tag myapp:latest myuser/myapp:1.0',
  'Used before pushing to a registry with the correct name.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-history',
  'Show the history of an image',
  'docker history {{options}} {{image}}',
  'Docker',
  ARRAY['image', 'history', 'debug', 'docker'],
  'docker history nginx:latest',
  'Lists layers and created-by commands for the image.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-save',
  'Save one or more images to a tar archive',
  'docker save {{options}} -o {{output_file}} {{image}}',
  'Docker',
  ARRAY['image', 'save', 'backup', 'export', 'docker'],
  'docker save -o nginx.tar nginx:latest',
  'Useful for transferring images without a registry.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-load',
  'Load an image from a tar archive',
  'docker load {{options}} -i {{input_file}}',
  'Docker',
  ARRAY['image', 'load', 'import', 'backup', 'docker'],
  'docker load -i nginx.tar',
  'Restores images previously created with docker save.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-commit',
  'Create a new image from a container filesystem',
  'docker commit {{options}} {{container}} {{repository}}',
  'Docker',
  ARRAY['image', 'commit', 'container', 'docker'],
  'docker commit web myapp:debug',
  'Prefer Dockerfile builds for reproducible images.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-export',
  'Export a container filesystem as a tar archive',
  'docker export {{options}} -o {{output_file}} {{container}}',
  'Docker',
  ARRAY['container', 'export', 'backup', 'docker'],
  'docker export -o web-fs.tar web',
  'Exports filesystem only (no history/layers). Pair with docker import.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-import',
  'Import a filesystem tarball as an image',
  'docker import {{options}} {{file}} {{repository}}',
  'Docker',
  ARRAY['image', 'import', 'docker'],
  'docker import web-fs.tar myapp:imported',
  'Creates a flat image from a tar of a filesystem.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-login',
  'Log in to a Docker registry',
  'docker login {{options}} {{registry}}',
  'Docker',
  ARRAY['registry', 'auth', 'login', 'docker'],
  'docker login',
  'Omit registry for Docker Hub. Use -u/-p carefully (prefer interactive).'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-logout',
  'Log out from a Docker registry',
  'docker logout {{registry}}',
  'Docker',
  ARRAY['registry', 'auth', 'logout', 'docker'],
  'docker logout',
  'Removes stored credentials for the registry.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-network-ls',
  'List Docker networks',
  'docker network ls {{options}}',
  'Docker',
  ARRAY['network', 'list', 'docker'],
  'docker network ls',
  'Shows bridge, host, none, and custom networks.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-network-create',
  'Create a Docker network',
  'docker network create {{options}} {{name}}',
  'Docker',
  ARRAY['network', 'create', 'docker'],
  'docker network create --driver bridge app-net',
  'Common drivers: bridge, overlay, macvlan. Use --subnet for custom CIDR.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-network-inspect',
  'Display detailed information on a network',
  'docker network inspect {{options}} {{network}}',
  'Docker',
  ARRAY['network', 'inspect', 'debug', 'docker'],
  'docker network inspect bridge',
  'Shows connected containers, IPAM config, and options.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-network-connect',
  'Connect a container to a network',
  'docker network connect {{options}} {{network}} {{container}}',
  'Docker',
  ARRAY['network', 'connect', 'container', 'docker'],
  'docker network connect app-net web',
  'Attaches a running or stopped container to the network.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-network-disconnect',
  'Disconnect a container from a network',
  'docker network disconnect {{options}} {{network}} {{container}}',
  'Docker',
  ARRAY['network', 'disconnect', 'container', 'docker'],
  'docker network disconnect app-net web',
  'Use -f to force disconnect.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-network-rm',
  'Remove one or more networks',
  'docker network rm {{network}}',
  'Docker',
  ARRAY['network', 'remove', 'cleanup', 'docker'],
  'docker network rm app-net',
  'Network must have no connected containers.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-network-prune',
  'Remove all unused networks',
  'docker network prune {{options}}',
  'Docker',
  ARRAY['network', 'prune', 'cleanup', 'docker'],
  'docker network prune -f',
  'Deletes networks not used by at least one container.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-port',
  'List port mappings for a container',
  'docker port {{container}} {{private_port}}',
  'Docker',
  ARRAY['network', 'port', 'container', 'docker'],
  'docker port web',
  'Shows public host ports mapped to container ports.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-volume-ls',
  'List Docker volumes',
  'docker volume ls {{options}}',
  'Docker',
  ARRAY['volume', 'list', 'storage', 'docker'],
  'docker volume ls',
  'Lists named and anonymous volumes on the host.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-volume-create',
  'Create a Docker volume',
  'docker volume create {{options}} {{name}}',
  'Docker',
  ARRAY['volume', 'create', 'storage', 'docker'],
  'docker volume create app-data',
  'Creates a named volume managed by Docker.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-volume-inspect',
  'Display detailed information on a volume',
  'docker volume inspect {{options}} {{volume}}',
  'Docker',
  ARRAY['volume', 'inspect', 'storage', 'docker'],
  'docker volume inspect app-data',
  'Shows mountpoint path and driver options.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-volume-rm',
  'Remove one or more volumes',
  'docker volume rm {{options}} {{volume}}',
  'Docker',
  ARRAY['volume', 'remove', 'cleanup', 'storage', 'docker'],
  'docker volume rm app-data',
  'Volume must not be in use by a container.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-volume-prune',
  'Remove all unused local volumes',
  'docker volume prune {{options}}',
  'Docker',
  ARRAY['volume', 'prune', 'cleanup', 'storage', 'docker'],
  'docker volume prune -f',
  'Deletes volumes not referenced by any container.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-system-df',
  'Show Docker disk usage',
  'docker system df {{options}}',
  'Docker',
  ARRAY['system', 'disk', 'cleanup', 'monitoring', 'docker'],
  'docker system df -v',
  'Reports space used by images, containers, volumes, and build cache.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-system-prune',
  'Remove unused Docker data',
  'docker system prune {{options}}',
  'Docker',
  ARRAY['system', 'prune', 'cleanup', 'disk', 'docker'],
  'docker system prune -af --volumes',
  'Cleans stopped containers, unused networks, dangling images; add --volumes carefully.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-info',
  'Display system-wide Docker information',
  'docker info {{options}}',
  'Docker',
  ARRAY['system', 'info', 'debug', 'docker'],
  'docker info',
  'Shows daemon config, storage driver, runtime, and resource limits.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-version',
  'Show Docker client and server versions',
  'docker version {{options}}',
  'Docker',
  ARRAY['system', 'version', 'docker'],
  'docker version',
  'Useful when diagnosing API version mismatches.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-events',
  'Get real-time events from the Docker daemon',
  'docker events {{options}}',
  'Docker',
  ARRAY['system', 'events', 'monitoring', 'docker'],
  'docker events --since 10m',
  'Stream create/start/die/pull events for debugging.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-up',
  'Create and start Compose services',
  'docker compose -f {{file}} up {{options}}',
  'Docker',
  ARRAY['compose', 'up', 'start', 'docker'],
  'docker compose -f docker-compose.yml up -d',
  'Use -d for detached mode. Builds images if needed unless --no-build.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-down',
  'Stop and remove Compose services',
  'docker compose -f {{file}} down {{options}}',
  'Docker',
  ARRAY['compose', 'down', 'stop', 'cleanup', 'docker'],
  'docker compose down -v',
  'Removes containers and networks; -v also removes named volumes declared in the file.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-ps',
  'List containers for a Compose project',
  'docker compose -f {{file}} ps {{options}}',
  'Docker',
  ARRAY['compose', 'ps', 'list', 'docker'],
  'docker compose ps',
  'Shows service status for the current Compose project.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-logs',
  'View logs from Compose services',
  'docker compose -f {{file}} logs {{options}} {{service}}',
  'Docker',
  ARRAY['compose', 'logs', 'debug', 'docker'],
  'docker compose logs -f --tail=100 api',
  'Follow with -f. Omit service to show all services.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-build',
  'Build or rebuild Compose service images',
  'docker compose -f {{file}} build {{options}} {{service}}',
  'Docker',
  ARRAY['compose', 'build', 'image', 'docker'],
  'docker compose build --no-cache api',
  'Rebuilds images defined with build: in the Compose file.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-restart',
  'Restart Compose services',
  'docker compose -f {{file}} restart {{options}} {{service}}',
  'Docker',
  ARRAY['compose', 'restart', 'docker'],
  'docker compose restart api',
  'Restarts running service containers.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-exec',
  'Execute a command in a running Compose service',
  'docker compose -f {{file}} exec {{options}} {{service}} {{command}}',
  'Docker',
  ARRAY['compose', 'exec', 'shell', 'debug', 'docker'],
  'docker compose exec -it api sh',
  'Like docker exec but scoped to a Compose service name.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-pull',
  'Pull service images defined in Compose',
  'docker compose -f {{file}} pull {{options}} {{service}}',
  'Docker',
  ARRAY['compose', 'pull', 'image', 'docker'],
  'docker compose pull',
  'Updates local images for services that use image:.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-stop',
  'Stop Compose services without removing them',
  'docker compose -f {{file}} stop {{options}} {{service}}',
  'Docker',
  ARRAY['compose', 'stop', 'docker'],
  'docker compose stop',
  'Containers remain and can be started again with docker compose start.'
);

INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'docker-compose-start',
  'Start existing Compose service containers',
  'docker compose -f {{file}} start {{options}} {{service}}',
  'Docker',
  ARRAY['compose', 'start', 'docker'],
  'docker compose start',
  'Starts previously created/stopped service containers.'
);

-- ============================================
-- PROPERTIES - LINUX TROUBLESHOOTING
-- ============================================

-- top (15)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (15, 'options', 'text', '', false, '-d 1, -p PID', 'Optional top flags', 1);

-- htop (16)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (16, 'options', 'text', '', false, '-d 10, --sort-key=PERCENT_CPU', 'Optional htop flags', 1);

-- ps-top-cpu (17)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (17, 'count', 'number', '10', true, '10', 'Number of top processes to show', 1);

-- pidstat-cpu (18)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (18, 'interval', 'number', '1', true, '1', 'Sampling interval in seconds', 1);

-- mpstat (20)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (20, 'interval', 'number', '1', true, '1', 'Sampling interval in seconds', 1);

-- sar-cpu (21)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (21, 'interval', 'number', '1', true, '1', 'Sampling interval in seconds', 1),
  (21, 'count', 'number', '5', true, '5', 'Number of samples', 2);

-- kill-process (22)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (22, 'pid', 'number', '', true, '1234', 'Process ID to kill', 1);

-- pgrep (23)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (23, 'process_name', 'text', '', true, 'nginx, java, node', 'Process name pattern', 1);

-- nice (24)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (24, 'priority', 'number', '10', true, '10', 'Nice value (higher = lower priority)', 1),
  (24, 'command', 'text', '', true, 'backup.sh', 'Command to run', 2);

-- renice (25)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (25, 'priority', 'number', '10', true, '10', 'New nice value', 1),
  (25, 'pid', 'number', '', true, '1234', 'Process ID', 2);

-- stress-cpu (26)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (26, 'cores', 'number', '4', true, '4', 'Number of CPU workers', 1);

-- vmstat (27)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (27, 'interval', 'number', '1', true, '1', 'Sampling interval in seconds', 1);

-- ps-top-mem (29)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (29, 'count', 'number', '10', true, '10', 'Number of top processes to show', 1);

-- smem (30)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (30, 'options', 'text', '', false, '-k, -u', 'Optional smem flags', 1);

-- sar-memory (34)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (34, 'interval', 'number', '1', true, '1', 'Sampling interval in seconds', 1),
  (34, 'count', 'number', '5', true, '5', 'Number of samples', 2);

-- create-swapfile (36)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (36, 'size', 'text', '2G', true, '2G, 4G', 'Swap file size', 1),
  (36, 'swapfile', 'text', '/swapfile', true, '/swapfile', 'Swap file path', 2);

-- pmap (37)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (37, 'pid', 'number', '', true, '1234', 'Process ID', 1);

-- numastat (38)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (38, 'options', 'text', '', false, '-p PID', 'Optional numastat flags', 1);

-- proc-status (39)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (39, 'pid', 'number', '', true, '1234', 'Process ID', 1);

-- df-disk (42)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (42, 'options', 'text', '', false, '-T, /', 'Optional df flags or mount path', 1);

-- du-root (43)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (43, 'path', 'text', '/', true, '/, /home, /var', 'Parent path to scan', 1);

-- lsblk (45)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (45, 'options', 'text', '', false, '-f, -o NAME,SIZE,MOUNTPOINT', 'Optional lsblk flags', 1);

-- iostat (46)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (46, 'interval', 'number', '1', true, '1', 'Sampling interval in seconds', 1);

-- df-inodes (47)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (47, 'options', 'text', '', false, '/', 'Optional df flags or mount path', 1);

-- journalctl-vacuum (49)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (49, 'days', 'number', '7', true, '7', 'Keep journals newer than this many days', 1);

-- logrotate-force (50)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (50, 'config', 'text', '/etc/logrotate.conf', true, '/etc/logrotate.conf', 'Logrotate config path', 1);

-- find-large-files (54)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (54, 'path', 'text', '/', true, '/, /var, /home', 'Search root path', 1),
  (54, 'size', 'text', '1G', true, '1G, 500M', 'Minimum file size', 2);

-- ncdu (55)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (55, 'path', 'text', '/', true, '/, /var', 'Path to explore', 1);

-- watch-df (56)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (56, 'interval', 'number', '5', true, '5', 'Refresh interval in seconds', 1);

-- tune2fs-inodes (57)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (57, 'device', 'text', '/dev/sda1', true, '/dev/sda1, /dev/nvme0n1p1', 'Block device path', 1);

-- ============================================
-- PROPERTIES - DOCKER
-- ============================================

-- docker-run (59)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (59, 'options', 'text', '-d --name web -p 8080:80', false, '-d --name app -p 8080:80 -v data:/data', 'Run options', 1),
  (59, 'image', 'text', 'nginx:latest', true, 'nginx:latest, redis:7', 'Image name', 2),
  (59, 'command', 'text', '', false, '/bin/sh, nginx -g "daemon off;"', 'Optional command override', 3);

-- docker-start (60)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (60, 'options', 'text', '', false, '-a, -i', 'Start options', 1),
  (60, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 2);

-- docker-stop (61)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (61, 'options', 'text', '', false, '-t 10', 'Stop options', 1),
  (61, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 2);

-- docker-restart (62)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (62, 'options', 'text', '', false, '-t 10', 'Restart options', 1),
  (62, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 2);

-- docker-kill (63)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (63, 'options', 'text', '', false, '-s SIGTERM', 'Kill options', 1),
  (63, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 2);

-- docker-rm (64)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (64, 'options', 'text', '-f', false, '-f, -v', 'Remove options', 1),
  (64, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 2);

-- docker-exec (65)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (65, 'options', 'text', '-it', false, '-it, -u root, -e KEY=val', 'Exec options', 1),
  (65, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 2),
  (65, 'command', 'text', '/bin/bash', true, '/bin/bash, /bin/sh, ls -la', 'Command to run', 3);

-- docker-inspect (66)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (66, 'options', 'text', '', false, '--format "{{.State.Status}}"', 'Inspect options', 1),
  (66, 'name', 'text', '', true, 'web, nginx:latest, bridge', 'Object name or ID', 2);

-- docker-stats (67)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (67, 'options', 'text', '', false, '--no-stream, --format table', 'Stats options', 1),
  (67, 'container', 'text', '', false, 'web', 'Optional container name or ID', 2);

-- docker-top (68)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (68, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 1),
  (68, 'options', 'text', '', false, 'aux', 'Optional ps arguments', 2);

-- docker-cp (69)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (69, 'source', 'text', '', true, 'web:/var/log/app.log, ./file.txt', 'Source path', 1),
  (69, 'destination', 'text', '', true, './app.log, web:/tmp/file.txt', 'Destination path', 2);

-- docker-rename (70)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (70, 'old_name', 'text', '', true, 'web', 'Current container name', 1),
  (70, 'new_name', 'text', '', true, 'web-old', 'New container name', 2);

-- docker-pause (71)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (71, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 1);

-- docker-unpause (72)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (72, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 1);

-- docker-attach (73)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (73, 'options', 'text', '', false, '--no-stdin, --sig-proxy=false', 'Attach options', 1),
  (73, 'container', 'text', '', true, 'web, container_id', 'Container name or ID', 2);

-- docker-images (74)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (74, 'options', 'text', '', false, '-a, --digests, --filter dangling=true', 'Images list options', 1);

-- docker-pull (75)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (75, 'options', 'text', '', false, '--platform linux/amd64, -q', 'Pull options', 1),
  (75, 'image', 'text', '', true, 'nginx:latest, redis:7', 'Image to pull', 2);

-- docker-push (76)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (76, 'options', 'text', '', false, '-q, --disable-content-trust', 'Push options', 1),
  (76, 'image', 'text', '', true, 'myuser/myapp:1.0', 'Image to push', 2);

-- docker-build (77)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (77, 'options', 'text', '', false, '--no-cache, -f Dockerfile.prod', 'Build options', 1),
  (77, 'tag', 'text', 'myapp:latest', true, 'myapp:1.0', 'Image tag (-t)', 2),
  (77, 'context', 'text', '.', true, '., ./app', 'Build context path', 3);

-- docker-rmi (78)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (78, 'options', 'text', '', false, '-f', 'Remove options', 1),
  (78, 'image', 'text', '', true, 'nginx:old, image_id', 'Image name or ID', 2);

-- docker-tag (79)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (79, 'source_image', 'text', '', true, 'myapp:latest', 'Source image', 1),
  (79, 'target_image', 'text', '', true, 'myuser/myapp:1.0', 'Target image tag', 2);

-- docker-history (80)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (80, 'options', 'text', '', false, '--no-trunc, -H', 'History options', 1),
  (80, 'image', 'text', '', true, 'nginx:latest', 'Image name', 2);

-- docker-save (81)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (81, 'options', 'text', '', false, '', 'Save options', 1),
  (81, 'output_file', 'text', 'image.tar', true, 'nginx.tar', 'Output tar file', 2),
  (81, 'image', 'text', '', true, 'nginx:latest', 'Image to save', 3);

-- docker-load (82)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (82, 'options', 'text', '', false, '-q', 'Load options', 1),
  (82, 'input_file', 'text', 'image.tar', true, 'nginx.tar', 'Input tar file', 2);

-- docker-commit (83)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (83, 'options', 'text', '', false, '-m "message", -a "author"', 'Commit options', 1),
  (83, 'container', 'text', '', true, 'web', 'Container name or ID', 2),
  (83, 'repository', 'text', '', true, 'myapp:debug', 'New image repository:tag', 3);

-- docker-export (84)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (84, 'options', 'text', '', false, '', 'Export options', 1),
  (84, 'output_file', 'text', 'container-fs.tar', true, 'web-fs.tar', 'Output tar file', 2),
  (84, 'container', 'text', '', true, 'web', 'Container name or ID', 3);

-- docker-import (85)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (85, 'options', 'text', '', false, '-m "message", --change "CMD /bin/sh"', 'Import options', 1),
  (85, 'file', 'text', '', true, 'web-fs.tar, -', 'Tar file or URL', 2),
  (85, 'repository', 'text', '', false, 'myapp:imported', 'Optional repository:tag', 3);

-- docker-login (86)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (86, 'options', 'text', '', false, '-u username', 'Login options', 1),
  (86, 'registry', 'text', '', false, 'ghcr.io, registry.example.com', 'Registry host (blank = Docker Hub)', 2);

-- docker-logout (87)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (87, 'registry', 'text', '', false, 'ghcr.io, registry.example.com', 'Registry host (blank = Docker Hub)', 1);

-- docker-network-ls (88)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (88, 'options', 'text', '', false, '--filter driver=bridge, -q', 'Network list options', 1);

-- docker-network-create (89)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (89, 'options', 'text', '--driver bridge', false, '--driver bridge --subnet 172.20.0.0/16', 'Create options', 1),
  (89, 'name', 'text', '', true, 'app-net', 'Network name', 2);

-- docker-network-inspect (90)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (90, 'options', 'text', '', false, '-f "{{json .IPAM}}"', 'Inspect options', 1),
  (90, 'network', 'text', '', true, 'bridge, app-net', 'Network name', 2);

-- docker-network-connect (91)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (91, 'options', 'text', '', false, '--alias api, --ip 172.20.0.10', 'Connect options', 1),
  (91, 'network', 'text', '', true, 'app-net', 'Network name', 2),
  (91, 'container', 'text', '', true, 'web', 'Container name or ID', 3);

-- docker-network-disconnect (92)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (92, 'options', 'text', '', false, '-f', 'Disconnect options', 1),
  (92, 'network', 'text', '', true, 'app-net', 'Network name', 2),
  (92, 'container', 'text', '', true, 'web', 'Container name or ID', 3);

-- docker-network-rm (93)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (93, 'network', 'text', '', true, 'app-net', 'Network name', 1);

-- docker-network-prune (94)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (94, 'options', 'text', '-f', false, '-f, --filter until=24h', 'Prune options', 1);

-- docker-port (95)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (95, 'container', 'text', '', true, 'web', 'Container name or ID', 1),
  (95, 'private_port', 'text', '', false, '80, 80/tcp', 'Optional private port filter', 2);

-- docker-volume-ls (96)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (96, 'options', 'text', '', false, '-q, --filter dangling=true', 'Volume list options', 1);

-- docker-volume-create (97)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (97, 'options', 'text', '', false, '--driver local, -o type=nfs', 'Create options', 1),
  (97, 'name', 'text', '', true, 'app-data', 'Volume name', 2);

-- docker-volume-inspect (98)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (98, 'options', 'text', '', false, '-f "{{.Mountpoint}}"', 'Inspect options', 1),
  (98, 'volume', 'text', '', true, 'app-data', 'Volume name', 2);

-- docker-volume-rm (99)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (99, 'options', 'text', '', false, '-f', 'Remove options', 1),
  (99, 'volume', 'text', '', true, 'app-data', 'Volume name', 2);

-- docker-volume-prune (100)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (100, 'options', 'text', '-f', false, '-f, --filter label=keep!=true', 'Prune options', 1);

-- docker-system-df (101)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (101, 'options', 'text', '-v', false, '-v, --format json', 'df options', 1);

-- docker-system-prune (102)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (102, 'options', 'text', '-f', false, '-af, -af --volumes', 'Prune options', 1);

-- docker-info (103)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (103, 'options', 'text', '', false, '-f "{{.ServerVersion}}"', 'Info options', 1);

-- docker-version (104)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (104, 'options', 'text', '', false, '-f "{{.Client.Version}}"', 'Version options', 1);

-- docker-events (105)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (105, 'options', 'text', '--since 10m', false, '--since 1h, --filter type=container', 'Events options', 1);

-- docker-compose-up (106)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (106, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml, compose.yaml', 'Compose file path', 1),
  (106, 'options', 'text', '-d', false, '-d, --build, --force-recreate', 'Up options', 2);

-- docker-compose-down (107)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (107, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (107, 'options', 'text', '', false, '-v, --rmi local, --remove-orphans', 'Down options', 2);

-- docker-compose-ps (108)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (108, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (108, 'options', 'text', '', false, '-a, --format json', 'ps options', 2);

-- docker-compose-logs (109)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (109, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (109, 'options', 'text', '-f --tail=100', false, '-f, --tail=100, --no-color', 'Logs options', 2),
  (109, 'service', 'text', '', false, 'api, web, db', 'Optional service name', 3);

-- docker-compose-build (110)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (110, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (110, 'options', 'text', '', false, '--no-cache, --pull', 'Build options', 2),
  (110, 'service', 'text', '', false, 'api, web', 'Optional service name', 3);

-- docker-compose-restart (111)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (111, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (111, 'options', 'text', '', false, '-t 10', 'Restart options', 2),
  (111, 'service', 'text', '', false, 'api, web', 'Optional service name', 3);

-- docker-compose-exec (112)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (112, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (112, 'options', 'text', '-it', false, '-it, -u root, -e KEY=val', 'Exec options', 2),
  (112, 'service', 'text', '', true, 'api, web', 'Service name', 3),
  (112, 'command', 'text', 'sh', true, 'sh, bash, ls -la', 'Command to run', 4);

-- docker-compose-pull (113)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (113, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (113, 'options', 'text', '', false, '--ignore-buildable, -q', 'Pull options', 2),
  (113, 'service', 'text', '', false, 'api, db', 'Optional service name', 3);

-- docker-compose-stop (114)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (114, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (114, 'options', 'text', '', false, '-t 10', 'Stop options', 2),
  (114, 'service', 'text', '', false, 'api, web', 'Optional service name', 3);

-- docker-compose-start (115)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (115, 'file', 'text', 'docker-compose.yml', true, 'docker-compose.yml', 'Compose file path', 1),
  (115, 'options', 'text', '', false, '', 'Start options', 2),
  (115, 'service', 'text', '', false, 'api, web', 'Optional service name', 3);

-- ============================================
-- GIT VERSION CONTROL
-- ============================================

-- git-init (116)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-init',
  'Create a new Git repository',
  'git init {{options}} {{directory}}',
  'Git',
  ARRAY['init', 'setup', 'repository', 'git'],
  'git init',
  'Initializes a new .git directory. Use --bare for a bare repo, or pass a path to create elsewhere.'
);

-- git-clone (117)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-clone',
  'Clone a remote repository',
  'git clone {{options}} {{repository}} {{directory}}',
  'Git',
  ARRAY['clone', 'remote', 'download', 'git'],
  'git clone git@github.com:org/repo.git',
  'Copies a remote repo locally. Use --depth 1 for a shallow clone, -b to pick a branch.'
);

-- git-status (118)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-status',
  'Show working tree status',
  'git status {{options}}',
  'Git',
  ARRAY['status', 'working-tree', 'git'],
  'git status -sb',
  'Shows staged, unstaged, and untracked files. -sb is a short branch summary.'
);

-- git-add (119)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-add',
  'Stage files for commit',
  'git add {{options}} {{pathspec}}',
  'Git',
  ARRAY['add', 'stage', 'index', 'git'],
  'git add .',
  'Adds file contents to the index. Use -p to stage hunks interactively, -u for tracked files only.'
);

-- git-commit (120)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-commit',
  'Record staged changes to the repository',
  'git commit {{options}} -m "{{message}}"',
  'Git',
  ARRAY['commit', 'save', 'history', 'git'],
  'git commit -m "Fix login validation"',
  'Creates a new commit from staged changes. Use --amend carefully to rewrite the last commit.'
);

-- git-push (121)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-push',
  'Upload local commits to a remote',
  'git push {{options}} {{remote}} {{branch}}',
  'Git',
  ARRAY['push', 'remote', 'publish', 'git'],
  'git push -u origin main',
  'Sends commits to the remote. -u sets upstream tracking. Avoid --force on shared branches.'
);

-- git-pull (122)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-pull',
  'Fetch and integrate remote changes',
  'git pull {{options}} {{remote}} {{branch}}',
  'Git',
  ARRAY['pull', 'remote', 'sync', 'git'],
  'git pull --rebase origin main',
  'Fetches then merges (or rebases with --rebase) remote commits into the current branch.'
);

-- git-fetch (123)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-fetch',
  'Download remote refs without merging',
  'git fetch {{options}} {{remote}}',
  'Git',
  ARRAY['fetch', 'remote', 'sync', 'git'],
  'git fetch --all --prune',
  'Updates remote-tracking branches only. Safer than pull when you want to inspect first.'
);

-- git-branch-list (124)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-branch-list',
  'List local or remote branches',
  'git branch {{options}}',
  'Git',
  ARRAY['branch', 'list', 'git'],
  'git branch -vv',
  'Lists branches. -a shows remotes, -vv shows tracking and last commit.'
);

-- git-branch-create (125)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-branch-create',
  'Create a new branch',
  'git branch {{options}} {{branch_name}}',
  'Git',
  ARRAY['branch', 'create', 'git'],
  'git branch feature/login',
  'Creates a branch pointer without switching. Prefer git switch -c to create and check out.'
);

-- git-branch-delete (126)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-branch-delete',
  'Delete a local branch',
  'git branch {{options}} {{branch_name}}',
  'Git',
  ARRAY['branch', 'delete', 'cleanup', 'git'],
  'git branch -d feature/login',
  'Use -d for safe delete (merged only), -D to force delete unmerged branches.'
);

-- git-checkout (127)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-checkout',
  'Switch branches or restore files',
  'git checkout {{options}} {{target}}',
  'Git',
  ARRAY['checkout', 'switch', 'branch', 'git'],
  'git checkout -b feature/login',
  'Legacy switch/restore command. Prefer git switch and git restore for clarity.'
);

-- git-switch (128)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-switch',
  'Switch to another branch',
  'git switch {{options}} {{branch_name}}',
  'Git',
  ARRAY['switch', 'branch', 'checkout', 'git'],
  'git switch -c feature/login',
  'Modern branch switching. -c creates and switches; - for previous branch.'
);

-- git-restore (129)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-restore',
  'Restore working tree or staged files',
  'git restore {{options}} {{pathspec}}',
  'Git',
  ARRAY['restore', 'discard', 'unstage', 'git'],
  'git restore --staged file.js',
  'Discards working changes or unstages with --staged. Safer replacement for checkout --.'
);

-- git-merge (130)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-merge',
  'Merge another branch into the current branch',
  'git merge {{options}} {{branch_name}}',
  'Git',
  ARRAY['merge', 'integrate', 'branch', 'git'],
  'git merge feature/login',
  'Combines histories. Use --no-ff to always create a merge commit, --abort to cancel.'
);

-- git-rebase (131)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-rebase',
  'Reapply commits on top of another base',
  'git rebase {{options}} {{upstream}}',
  'Git',
  ARRAY['rebase', 'history', 'rewrite', 'git'],
  'git rebase main',
  'Replays commits onto upstream. Use -i for interactive rebase. Avoid on shared published history.'
);

-- git-log (132)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-log',
  'Show commit history',
  'git log {{options}}',
  'Git',
  ARRAY['log', 'history', 'commits', 'git'],
  'git log --oneline --graph --decorate -n 20',
  'Browse history. Common flags: --oneline, --graph, -p, --author, --since.'
);

-- git-diff (133)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-diff',
  'Show changes between commits, index, and working tree',
  'git diff {{options}} {{revision}}',
  'Git',
  ARRAY['diff', 'changes', 'compare', 'git'],
  'git diff --staged',
  'Unstaged by default. --staged shows index vs HEAD; pass two refs to compare commits.'
);

-- git-show (134)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-show',
  'Show a commit, tag, or object',
  'git show {{options}} {{object}}',
  'Git',
  ARRAY['show', 'commit', 'inspect', 'git'],
  'git show HEAD',
  'Displays metadata and diff for a commit or tag. Useful after log to inspect a SHA.'
);

-- git-stash (135)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-stash',
  'Stash local modifications temporarily',
  'git stash {{options}}',
  'Git',
  ARRAY['stash', 'wip', 'temporary', 'git'],
  'git stash push -m "wip: form validation"',
  'Saves dirty work and cleans the tree. Use push -u to include untracked files.'
);

-- git-stash-list (136)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-stash-list',
  'List saved stashes',
  'git stash list {{options}}',
  'Git',
  ARRAY['stash', 'list', 'git'],
  'git stash list',
  'Shows stash@{n} entries. Use git stash show -p stash@{0} to inspect.'
);

-- git-stash-pop (137)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-stash-pop',
  'Apply and remove a stash',
  'git stash pop {{options}} {{stash}}',
  'Git',
  ARRAY['stash', 'pop', 'apply', 'git'],
  'git stash pop',
  'Applies the latest stash and drops it. Use apply to keep the stash entry.'
);

-- git-remote-add (138)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-remote-add',
  'Add a remote repository',
  'git remote add {{name}} {{url}}',
  'Git',
  ARRAY['remote', 'add', 'origin', 'git'],
  'git remote add origin git@github.com:org/repo.git',
  'Registers a remote URL under a short name, usually origin.'
);

-- git-remote-v (139)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-remote-v',
  'List remotes with fetch and push URLs',
  'git remote -v',
  'Git',
  ARRAY['remote', 'list', 'url', 'git'],
  'git remote -v',
  'Shows configured remotes. Use git remote set-url to change a URL.'
);

-- git-reset-soft (140)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-reset-soft',
  'Move HEAD but keep index and working tree',
  'git reset --soft {{commit}}',
  'Git',
  ARRAY['reset', 'soft', 'undo', 'git'],
  'git reset --soft HEAD~1',
  'Undo commit(s) while keeping all changes staged. Safe way to rewrite the last commit message/content.'
);

-- git-reset-mixed (141)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-reset-mixed',
  'Move HEAD and unstage, keep working tree',
  'git reset {{options}} {{commit}}',
  'Git',
  ARRAY['reset', 'mixed', 'unstage', 'undo', 'git'],
  'git reset HEAD~1',
  'Default reset mode. Undoes commits and unstages files but keeps file contents.'
);

-- git-reset-hard (142)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-reset-hard',
  'Reset HEAD, index, and working tree (destructive)',
  'git reset --hard {{commit}}',
  'Git',
  ARRAY['reset', 'hard', 'discard', 'destructive', 'git'],
  'git reset --hard HEAD',
  'Discards all uncommitted changes. Destructive and usually irreversible—use with care.'
);

-- git-revert (143)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-revert',
  'Create a new commit that undoes a previous commit',
  'git revert {{options}} {{commit}}',
  'Git',
  ARRAY['revert', 'undo', 'safe', 'git'],
  'git revert HEAD',
  'Safe undo for published history. Adds a reverse commit instead of rewriting history.'
);

-- git-cherry-pick (144)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-cherry-pick',
  'Apply a commit from another branch',
  'git cherry-pick {{options}} {{commit}}',
  'Git',
  ARRAY['cherry-pick', 'commit', 'patch', 'git'],
  'git cherry-pick abc1234',
  'Copies a specific commit onto the current branch. Use -x to record the source SHA.'
);

-- git-tag (145)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-tag',
  'Create, list, or delete tags',
  'git tag {{options}} {{tag_name}} {{commit}}',
  'Git',
  ARRAY['tag', 'release', 'version', 'git'],
  'git tag -a v1.0.0 -m "Release 1.0.0"',
  'Annotated tags (-a) are preferred for releases. Push with git push origin --tags.'
);

-- git-blame (146)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-blame',
  'Show who last modified each line of a file',
  'git blame {{options}} {{file}}',
  'Git',
  ARRAY['blame', 'author', 'history', 'git'],
  'git blame src/app.js',
  'Line-by-line authorship. Use -L to limit line range.'
);

-- git-config-user (147)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-config-user',
  'Set Git user name and email',
  'git config {{scope}} user.name "{{name}}" && git config {{scope}} user.email "{{email}}"',
  'Git',
  ARRAY['config', 'user', 'identity', 'git'],
  'git config --global user.name "Ada Lovelace" && git config --global user.email "ada@example.com"',
  'Sets commit identity. Use --global for all repos or omit for local repo only.'
);

-- git-clean (148)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-clean',
  'Remove untracked files from the working tree',
  'git clean {{options}}',
  'Git',
  ARRAY['clean', 'untracked', 'cleanup', 'destructive', 'git'],
  'git clean -fd',
  'Deletes untracked files/dirs. Always preview with -n first. -x also removes ignored files.'
);

-- git-reflog (149)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-reflog',
  'Show history of HEAD movements',
  'git reflog {{options}}',
  'Git',
  ARRAY['reflog', 'recovery', 'history', 'git'],
  'git reflog -n 20',
  'Lifesaver after bad resets. Recover lost commits with git reset --hard HEAD@{n}.'
);

-- git-bisect (150)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-bisect',
  'Binary search to find a bad commit',
  'git bisect {{subcommand}} {{revision}}',
  'Git',
  ARRAY['bisect', 'debug', 'regression', 'git'],
  'git bisect start && git bisect bad && git bisect good v1.0.0',
  'Marks good/bad commits to locate the first regression. End with git bisect reset.'
);

-- git-squash-last (151)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-squash-last',
  'Soft-reset and recommit to squash recent commits',
  'git reset --soft HEAD~{{count}} && git commit -m "{{message}}"',
  'Git',
  ARRAY['squash', 'rebase', 'cleanup', 'git'],
  'git reset --soft HEAD~3 && git commit -m "Add auth flow"',
  'Combines the last N commits into one while keeping all changes staged.'
);

-- git-push-upstream (152)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-push-upstream',
  'Push current branch and set upstream tracking',
  'git push -u {{remote}} HEAD',
  'Git',
  ARRAY['push', 'upstream', 'tracking', 'git'],
  'git push -u origin HEAD',
  'Pushes the current branch name to remote and sets tracking so later pushes can be git push.'
);

-- git-pull-rebase (153)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-pull-rebase',
  'Pull with rebase instead of merge',
  'git pull --rebase {{options}} {{remote}} {{branch}}',
  'Git',
  ARRAY['pull', 'rebase', 'sync', 'git'],
  'git pull --rebase origin main',
  'Replays local commits on top of remote. Keeps a linear history.'
);

-- git-diff-branches (154)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-diff-branches',
  'Compare two branches',
  'git diff {{base}}...{{compare}}',
  'Git',
  ARRAY['diff', 'branch', 'compare', 'git'],
  'git diff main...feature/login',
  'Triple-dot shows changes introduced on compare since it diverged from base.'
);

-- git-commit-amend (155)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'git-commit-amend',
  'Amend the previous commit',
  'git commit --amend {{options}} -m "{{message}}"',
  'Git',
  ARRAY['commit', 'amend', 'rewrite', 'git'],
  'git commit --amend -m "Fix typo in login validation"',
  'Rewrites the last commit. Do not amend commits already pushed to a shared branch.'
);

-- ============================================
-- GIT COMMAND PROPERTIES
-- ============================================

-- git-init (116)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (116, 'options', 'text', '', false, '--bare, --initial-branch=main', 'Init options', 1),
  (116, 'directory', 'text', '', false, '., ./my-project', 'Optional target directory', 2);

-- git-clone (117)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (117, 'options', 'text', '', false, '--depth 1, -b main, --recurse-submodules', 'Clone options', 1),
  (117, 'repository', 'text', '', true, 'git@github.com:org/repo.git', 'Remote repository URL', 2),
  (117, 'directory', 'text', '', false, 'repo, ./apps/repo', 'Optional local directory name', 3);

-- git-status (118)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (118, 'options', 'text', '-sb', false, '-sb, --ignored, --porcelain', 'Status options', 1);

-- git-add (119)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (119, 'options', 'text', '', false, '-p, -u, -A, -n', 'Add options', 1),
  (119, 'pathspec', 'text', '.', true, '., src/, file.js', 'Files or paths to stage', 2);

-- git-commit (120)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (120, 'options', 'text', '', false, '--no-verify, -a, --signoff', 'Commit options', 1),
  (120, 'message', 'text', '', true, 'Fix bug, Add feature', 'Commit message', 2);

-- git-push (121)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (121, 'options', 'text', '', false, '-u, --tags, --force-with-lease', 'Push options', 1),
  (121, 'remote', 'text', 'origin', true, 'origin, upstream', 'Remote name', 2),
  (121, 'branch', 'text', 'HEAD', true, 'main, feature/login, HEAD', 'Branch to push', 3);

-- git-pull (122)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (122, 'options', 'text', '', false, '--rebase, --ff-only, --no-edit', 'Pull options', 1),
  (122, 'remote', 'text', 'origin', false, 'origin, upstream', 'Remote name', 2),
  (122, 'branch', 'text', '', false, 'main, develop', 'Remote branch', 3);

-- git-fetch (123)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (123, 'options', 'text', '--all --prune', false, '--all, --prune, --tags', 'Fetch options', 1),
  (123, 'remote', 'text', '', false, 'origin, upstream', 'Optional remote (blank = default)', 2);

-- git-branch-list (124)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (124, 'options', 'text', '-vv', false, '-a, -r, -vv, --merged', 'Branch list options', 1);

-- git-branch-create (125)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (125, 'options', 'text', '', false, '', 'Branch options', 1),
  (125, 'branch_name', 'text', '', true, 'feature/login, bugfix/123', 'New branch name', 2);

-- git-branch-delete (126)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (126, 'options', 'text', '-d', true, '-d, -D, -r --delete', 'Delete options (-d safe, -D force)', 1),
  (126, 'branch_name', 'text', '', true, 'feature/login', 'Branch to delete', 2);

-- git-checkout (127)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (127, 'options', 'text', '', false, '-b, -', 'Checkout options', 1),
  (127, 'target', 'text', '', true, 'main, feature/login, -- file.js', 'Branch, commit, or path', 2);

-- git-switch (128)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (128, 'options', 'text', '', false, '-c, -', 'Switch options (-c to create)', 1),
  (128, 'branch_name', 'text', '', true, 'main, feature/login', 'Branch to switch to', 2);

-- git-restore (129)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (129, 'options', 'text', '', false, '--staged, --source=HEAD~1', 'Restore options', 1),
  (129, 'pathspec', 'text', '', true, 'file.js, src/, .', 'Files to restore', 2);

-- git-merge (130)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (130, 'options', 'text', '', false, '--no-ff, --squash, --abort', 'Merge options', 1),
  (130, 'branch_name', 'text', '', true, 'feature/login, main', 'Branch to merge in', 2);

-- git-rebase (131)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (131, 'options', 'text', '', false, '-i, --continue, --abort, --onto', 'Rebase options', 1),
  (131, 'upstream', 'text', 'main', true, 'main, origin/main', 'Upstream base branch', 2);

-- git-log (132)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (132, 'options', 'text', '--oneline --graph --decorate -n 20', false, '--oneline, -p, --author=name', 'Log options', 1);

-- git-diff (133)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (133, 'options', 'text', '', false, '--staged, --stat, --name-only', 'Diff options', 1),
  (133, 'revision', 'text', '', false, 'HEAD~1, main...feature', 'Optional revision or range', 2);

-- git-show (134)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (134, 'options', 'text', '', false, '--stat, --name-only, -s', 'Show options', 1),
  (134, 'object', 'text', 'HEAD', true, 'HEAD, abc1234, v1.0.0', 'Commit, tag, or object', 2);

-- git-stash (135)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (135, 'options', 'text', 'push -m "wip"', false, 'push -u -m "msg", -k, -p', 'Stash options', 1);

-- git-stash-list (136)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (136, 'options', 'text', '', false, '--date=local', 'List options', 1);

-- git-stash-pop (137)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (137, 'options', 'text', '', false, '--index', 'Pop options', 1),
  (137, 'stash', 'text', '', false, 'stash@{0}, stash@{1}', 'Optional stash ref (default latest)', 2);

-- git-remote-add (138)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (138, 'name', 'text', 'origin', true, 'origin, upstream', 'Remote name', 1),
  (138, 'url', 'text', '', true, 'git@github.com:org/repo.git', 'Remote URL', 2);

-- git-reset-soft (140)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (140, 'commit', 'text', 'HEAD~1', true, 'HEAD~1, abc1234', 'Target commit (changes stay staged)', 1);

-- git-reset-mixed (141)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (141, 'options', 'text', '', false, '--mixed', 'Reset options (default is mixed)', 1),
  (141, 'commit', 'text', 'HEAD~1', true, 'HEAD~1, abc1234', 'Target commit (changes stay unstaged)', 2);

-- git-reset-hard (142)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (142, 'commit', 'text', 'HEAD', true, 'HEAD, origin/main, abc1234', 'Target commit (discards local changes)', 1);

-- git-revert (143)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (143, 'options', 'text', '', false, '--no-edit, -n, --continue', 'Revert options', 1),
  (143, 'commit', 'text', 'HEAD', true, 'HEAD, abc1234', 'Commit to revert', 2);

-- git-cherry-pick (144)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (144, 'options', 'text', '', false, '-x, -n, --continue, --abort', 'Cherry-pick options', 1),
  (144, 'commit', 'text', '', true, 'abc1234, main~2', 'Commit SHA or ref to apply', 2);

-- git-tag (145)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (145, 'options', 'text', '-a -m "Release"', false, '-a -m "msg", -d, -l', 'Tag options', 1),
  (145, 'tag_name', 'text', '', false, 'v1.0.0, release-2024', 'Tag name (omit to list)', 2),
  (145, 'commit', 'text', '', false, 'HEAD, abc1234', 'Optional commit to tag', 3);

-- git-blame (146)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (146, 'options', 'text', '', false, '-L 10,40, -w, --since=2024-01-01', 'Blame options', 1),
  (146, 'file', 'text', '', true, 'src/app.js, README.md', 'File to blame', 2);

-- git-config-user (147)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (147, 'scope', 'text', '--global', true, '--global, --local, --system', 'Config scope', 1),
  (147, 'name', 'text', '', true, 'Ada Lovelace', 'User name for commits', 2),
  (147, 'email', 'text', '', true, 'ada@example.com', 'User email for commits', 3);

-- git-clean (148)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (148, 'options', 'text', '-fdn', true, '-n (dry-run), -fd, -fdx', 'Clean options (preview with -n first)', 1);

-- git-reflog (149)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (149, 'options', 'text', '-n 20', false, '-n 20, --date=iso', 'Reflog options', 1);

-- git-bisect (150)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (150, 'subcommand', 'text', 'start', true, 'start, bad, good, reset, log', 'Bisect subcommand', 1),
  (150, 'revision', 'text', '', false, 'v1.0.0, abc1234', 'Optional revision for good/bad', 2);

-- git-squash-last (151)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (151, 'count', 'number', '2', true, '2, 3, 5', 'Number of recent commits to squash', 1),
  (151, 'message', 'text', '', true, 'Add auth flow', 'New squashed commit message', 2);

-- git-push-upstream (152)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (152, 'remote', 'text', 'origin', true, 'origin, upstream', 'Remote name', 1);

-- git-pull-rebase (153)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (153, 'options', 'text', '', false, '--autostash, --ff-only', 'Pull-rebase options', 1),
  (153, 'remote', 'text', 'origin', false, 'origin, upstream', 'Remote name', 2),
  (153, 'branch', 'text', '', false, 'main, develop', 'Remote branch', 3);

-- git-diff-branches (154)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (154, 'base', 'text', 'main', true, 'main, develop', 'Base branch', 1),
  (154, 'compare', 'text', '', true, 'feature/login, HEAD', 'Branch to compare', 2);

-- git-commit-amend (155)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (155, 'options', 'text', '', false, '--no-edit, --no-verify', 'Amend options (--no-edit keeps message)', 1),
  (155, 'message', 'text', '', true, 'Fix typo in login validation', 'New commit message', 2);


-- ============================================
-- POSTGRESQL - ADMIN & MONITORING QUERIES
-- ============================================

-- psql-connect (156)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'psql-connect',
  'Connect to a PostgreSQL server via the psql interactive shell',
  'psql -h {{host}} -U {{username}} -d {{database}} -p {{port}} {{options}}',
  'PostgreSQL',
  ARRAY['connect', 'psql', 'client', 'postgresql'],
  'psql -h localhost -U postgres -d mydb -p 5432',
  'Opens an interactive session. Use -c "SQL" to run one statement non-interactively without a shell.'
);

-- pg-db-size (157)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-db-size',
  'Check the on-disk size of a specific PostgreSQL database',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT pg_size_pretty(pg_database_size(''{{database}}''));"',
  'PostgreSQL',
  ARRAY['size', 'database', 'disk', 'postgresql', 'monitoring'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "SELECT pg_size_pretty(pg_database_size(''mydb''));"',
  'Returns a human-readable size (e.g. 245 MB) for the target database.'
);

-- pg-all-db-sizes (158)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-all-db-sizes',
  'List sizes of all PostgreSQL databases on the server',
  'psql -h {{host}} -U {{username}} -p {{port}} -d postgres -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) AS size FROM pg_database ORDER BY pg_database_size(datname) DESC;"',
  'PostgreSQL',
  ARRAY['size', 'database', 'disk', 'postgresql', 'monitoring'],
  'psql -h localhost -U postgres -p 5432 -d postgres -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) AS size FROM pg_database ORDER BY pg_database_size(datname) DESC;"',
  'Useful for spotting which database on the instance is consuming the most disk space.'
);

-- pg-table-sizes (159)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-table-sizes',
  'List the largest tables in a PostgreSQL database by total size',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT relname AS table, pg_size_pretty(pg_total_relation_size(relid)) AS size FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC LIMIT {{limit}};"',
  'PostgreSQL',
  ARRAY['size', 'table', 'disk', 'postgresql', 'monitoring'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "SELECT relname AS table, pg_size_pretty(pg_total_relation_size(relid)) AS size FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC LIMIT 20;"',
  'pg_total_relation_size includes indexes and TOAST data, not just the table heap.'
);

-- pg-active-connections (160)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-active-connections',
  'Show active (non-idle) PostgreSQL connections and their current query',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT pid, usename, datname, client_addr, state, query, query_start FROM pg_stat_activity WHERE state != ''idle'';"',
  'PostgreSQL',
  ARRAY['connection', 'monitoring', 'postgresql', 'pg_stat_activity'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "SELECT pid, usename, datname, state, query FROM pg_stat_activity WHERE state != ''idle'';"',
  'Remove the WHERE clause to include idle sessions too.'
);

-- pg-connection-count (161)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-connection-count',
  'Count current PostgreSQL connections grouped by database',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname ORDER BY count(*) DESC;"',
  'PostgreSQL',
  ARRAY['connection', 'count', 'monitoring', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "SELECT datname, count(*) FROM pg_stat_activity GROUP BY datname ORDER BY count(*) DESC;"',
  'Compare the total against max_connections (pg-max-connections) to see how close you are to the limit.'
);

-- pg-kill-connection (162)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-kill-connection',
  'Terminate a specific PostgreSQL backend/connection by PID',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT pg_terminate_backend({{pid}});"',
  'PostgreSQL',
  ARRAY['connection', 'kill', 'terminate', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "SELECT pg_terminate_backend(12345);"',
  'Use pg_cancel_backend(pid) instead to cancel just the running query without dropping the connection.'
);

-- pg-long-running-queries (163)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-long-running-queries',
  'Find PostgreSQL queries that have been running longer than a given duration',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT pid, now() - query_start AS duration, state, query FROM pg_stat_activity WHERE state != ''idle'' AND now() - query_start > interval ''{{threshold}}'' ORDER BY duration DESC;"',
  'PostgreSQL',
  ARRAY['query', 'performance', 'monitoring', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "SELECT pid, now() - query_start AS duration, query FROM pg_stat_activity WHERE now() - query_start > interval ''5 minutes'';"',
  'Pair with pg-kill-connection once you have identified an offending pid.'
);

-- pg-version (164)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-version',
  'Check the PostgreSQL server version',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT version();"',
  'PostgreSQL',
  ARRAY['version', 'info', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -d postgres -c "SELECT version();"',
  'Reports the full server version string including build platform.'
);

-- pg-list-databases (165)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-list-databases',
  'List all databases on a PostgreSQL server',
  'psql -h {{host}} -U {{username}} -p {{port}} -l {{options}}',
  'PostgreSQL',
  ARRAY['list', 'database', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -l',
  'Equivalent to running \l inside an interactive psql session.'
);

-- pg-list-tables (166)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-list-tables',
  'List tables in a PostgreSQL schema',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "\dt {{schema}}.*"',
  'PostgreSQL',
  ARRAY['list', 'table', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "\dt public.*"',
  'psql meta-commands like \dt work fine with -c, no need for an interactive session.'
);

-- pg-create-user (167)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-create-user',
  'Create a new PostgreSQL role/user with a login password',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "CREATE USER {{new_user}} WITH PASSWORD ''{{new_password}}'' {{options}};"',
  'PostgreSQL',
  ARRAY['user', 'role', 'create', 'postgresql', 'security'],
  'psql -h localhost -U postgres -p 5432 -d postgres -c "CREATE USER app_user WITH PASSWORD ''s3cret'' LOGIN;"',
  'Add options like LOGIN, CREATEDB, or SUPERUSER as needed. Avoid SUPERUSER for application accounts.'
);

-- pg-grant-privileges (168)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-grant-privileges',
  'Grant privileges on a database to a PostgreSQL user',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "GRANT {{privileges}} ON DATABASE {{target_database}} TO {{target_user}};"',
  'PostgreSQL',
  ARRAY['grant', 'privileges', 'user', 'postgresql', 'security'],
  'psql -h localhost -U postgres -p 5432 -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE mydb TO app_user;"',
  'Prefer the narrowest privilege set the application actually needs over ALL PRIVILEGES.'
);

-- pg-vacuum-analyze (169)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-vacuum-analyze',
  'Reclaim storage and refresh planner statistics for a PostgreSQL table or database',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "VACUUM (ANALYZE, VERBOSE) {{table}};"',
  'PostgreSQL',
  ARRAY['vacuum', 'maintenance', 'performance', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "VACUUM (ANALYZE, VERBOSE) orders;"',
  'Leave table empty to vacuum the whole database. Use VACUUM FULL sparingly - it takes an exclusive lock.'
);

-- pg-isready (170)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-isready',
  'Check whether a PostgreSQL server is up and accepting connections',
  'pg_isready -h {{host}} -p {{port}} -U {{username}} {{options}}',
  'PostgreSQL',
  ARRAY['health', 'connection', 'check', 'postgresql'],
  'pg_isready -h localhost -p 5432 -U postgres',
  'Exits 0 when accepting connections - handy in health checks and scripts.'
);

-- pg-locks (171)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'pg-locks',
  'Show PostgreSQL sessions currently waiting on a lock (blocked queries)',
  'psql -h {{host}} -U {{username}} -p {{port}} -d {{database}} -c "SELECT pid, relation::regclass, mode, granted, query FROM pg_locks JOIN pg_stat_activity USING (pid) WHERE NOT granted;"',
  'PostgreSQL',
  ARRAY['locks', 'blocking', 'monitoring', 'postgresql'],
  'psql -h localhost -U postgres -p 5432 -d mydb -c "SELECT pid, relation::regclass, mode, granted FROM pg_locks JOIN pg_stat_activity USING (pid) WHERE NOT granted;"',
  'Remove "WHERE NOT granted" to see every lock, not just the ones blocked waiting for one.'
);

-- ============================================
-- MYSQL - ADMIN & MONITORING QUERIES
-- ============================================

-- mysql-connect (172)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-connect',
  'Connect to a MySQL/MariaDB server via the CLI client',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} {{database}}',
  'MySQL',
  ARRAY['connect', 'client', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 mydb',
  'Omit -p{{password}} (leave it blank) to be prompted interactively instead - safer than inline passwords.'
);

-- mysql-db-size (173)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-db-size',
  'Check the size of a specific MySQL database',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SELECT table_schema AS db, ROUND(SUM(data_length+index_length)/1024/1024,2) AS size_mb FROM information_schema.tables WHERE table_schema = ''{{database}}'';"',
  'MySQL',
  ARRAY['size', 'database', 'disk', 'mysql', 'monitoring'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SELECT table_schema, ROUND(SUM(data_length+index_length)/1024/1024,2) AS size_mb FROM information_schema.tables WHERE table_schema=''mydb'';"',
  'Size is data + index length in MB for the given schema.'
);

-- mysql-all-db-sizes (174)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-all-db-sizes',
  'List sizes of all MySQL databases on the server',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SELECT table_schema AS db, ROUND(SUM(data_length+index_length)/1024/1024,2) AS size_mb FROM information_schema.tables GROUP BY table_schema ORDER BY size_mb DESC;"',
  'MySQL',
  ARRAY['size', 'database', 'disk', 'mysql', 'monitoring'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SELECT table_schema, ROUND(SUM(data_length+index_length)/1024/1024,2) AS size_mb FROM information_schema.tables GROUP BY table_schema ORDER BY size_mb DESC;"',
  'Useful for spotting which schema on the instance is consuming the most disk space.'
);

-- mysql-table-sizes (175)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-table-sizes',
  'List the largest tables in a MySQL database by size',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SELECT table_name, ROUND((data_length+index_length)/1024/1024,2) AS size_mb FROM information_schema.tables WHERE table_schema = ''{{database}}'' ORDER BY size_mb DESC LIMIT {{limit}};"',
  'MySQL',
  ARRAY['size', 'table', 'disk', 'mysql', 'monitoring'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SELECT table_name, ROUND((data_length+index_length)/1024/1024,2) AS size_mb FROM information_schema.tables WHERE table_schema=''mydb'' ORDER BY size_mb DESC LIMIT 20;"',
  'Includes index size alongside data size for a fuller picture of table footprint.'
);

-- mysql-show-processlist (176)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-show-processlist',
  'Show currently running MySQL connections and their queries',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SHOW FULL PROCESSLIST;"',
  'MySQL',
  ARRAY['connection', 'query', 'monitoring', 'mysql', 'processlist'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SHOW FULL PROCESSLIST;"',
  'SHOW FULL PROCESSLIST avoids truncating the Info column, unlike plain SHOW PROCESSLIST.'
);

-- mysql-connection-count (177)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-connection-count',
  'Count currently connected MySQL threads',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SHOW STATUS WHERE variable_name = ''Threads_connected'';"',
  'MySQL',
  ARRAY['connection', 'count', 'monitoring', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SHOW STATUS WHERE variable_name=''Threads_connected'';"',
  'Compare against max_connections (mysql-show-status with pattern max_connections) to check headroom.'
);

-- mysql-kill-process (178)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-kill-process',
  'Kill a specific MySQL connection or query by its process ID',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "KILL {{process_id}};"',
  'MySQL',
  ARRAY['kill', 'connection', 'terminate', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "KILL 482;"',
  'Find the process_id first via mysql-show-processlist.'
);

-- mysql-version (179)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-version',
  'Check the MySQL/MariaDB server version',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SELECT VERSION();"',
  'MySQL',
  ARRAY['version', 'info', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SELECT VERSION();"',
  'Reports the server version string, including any vendor suffix (e.g. -MariaDB).'
);

-- mysql-show-databases (180)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-show-databases',
  'List all databases on a MySQL server',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SHOW DATABASES;"',
  'MySQL',
  ARRAY['list', 'database', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SHOW DATABASES;"',
  'Lists every schema the connected user is permitted to see.'
);

-- mysql-show-tables (181)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-show-tables',
  'List all tables in a MySQL database',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -D {{database}} -e "SHOW TABLES;"',
  'MySQL',
  ARRAY['list', 'table', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 -D mydb -e "SHOW TABLES;"',
  'Use SHOW TABLE STATUS instead if you also want row counts and engine info.'
);

-- mysql-create-user-grant (182)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-create-user-grant',
  'Create a MySQL user and grant privileges on a database',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "CREATE USER ''{{new_user}}''@''{{new_host}}'' IDENTIFIED BY ''{{new_password}}''; GRANT {{privileges}} ON {{target_database}}.* TO ''{{new_user}}''@''{{new_host}}''; FLUSH PRIVILEGES;"',
  'MySQL',
  ARRAY['user', 'grant', 'privileges', 'create', 'mysql', 'security'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "CREATE USER ''app''@''%'' IDENTIFIED BY ''s3cret''; GRANT ALL ON mydb.* TO ''app''@''%''; FLUSH PRIVILEGES;"',
  'Prefer the narrowest privilege set over ALL, and scope new_host tighter than % when possible.'
);

-- mysql-optimize-table (183)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-optimize-table',
  'Reclaim unused space and defragment a MySQL table',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -D {{database}} -e "OPTIMIZE TABLE {{table}};"',
  'MySQL',
  ARRAY['optimize', 'maintenance', 'performance', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 -D mydb -e "OPTIMIZE TABLE orders;"',
  'On InnoDB this rebuilds the table - can be slow and briefly lock the table on large data sets.'
);

-- mysqladmin-ping (184)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysqladmin-ping',
  'Check whether a MySQL server is up and accepting connections',
  'mysqladmin -h {{host}} -u {{username}} -p{{password}} -P {{port}} ping',
  'MySQL',
  ARRAY['health', 'connection', 'check', 'mysql'],
  'mysqladmin -h localhost -u root -ppassword -P 3306 ping',
  'Prints "mysqld is alive" and exits 0 on success - handy in health checks and scripts.'
);

-- mysql-show-status (185)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'mysql-show-status',
  'Show global MySQL server status counters (uptime, queries, connections, etc.)',
  'mysql -h {{host}} -u {{username}} -p{{password}} -P {{port}} -e "SHOW GLOBAL STATUS LIKE ''{{pattern}}'';"',
  'MySQL',
  ARRAY['status', 'monitoring', 'mysql'],
  'mysql -h localhost -u root -ppassword -P 3306 -e "SHOW GLOBAL STATUS LIKE ''Threads%'';"',
  'Common patterns: Threads%, Uptime, Queries, Slow_queries, Connections.'
);

-- ============================================
-- AWS - IMPORTANT / OPERATIONAL COMMANDS
-- ============================================

-- aws-configure (186)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-configure',
  'Configure AWS CLI credentials and default region for a profile',
  'aws configure {{options}}',
  'AWS',
  ARRAY['config', 'credentials', 'setup', 'aws'],
  'aws configure --profile prod',
  'Prompts for Access Key ID, Secret Access Key, default region, and output format.'
);

-- aws-whoami (187)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-whoami',
  'Show the identity (account, user/role, ARN) behind the current AWS credentials',
  'aws sts get-caller-identity {{options}}',
  'AWS',
  ARRAY['identity', 'sts', 'credentials', 'aws'],
  'aws sts get-caller-identity --profile prod',
  'Quick sanity check for which account/role a profile or environment is actually using.'
);

-- aws-s3-cp (188)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-s3-cp',
  'Copy a file or object to or from AWS S3',
  'aws s3 cp {{source}} {{destination}} {{options}}',
  'AWS',
  ARRAY['s3', 'copy', 'upload', 'download', 'aws'],
  'aws s3 cp ./backup.sql s3://my-bucket/backups/backup.sql',
  'Works both directions - swap source/destination to download instead of upload.'
);

-- aws-s3-sync (189)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-s3-sync',
  'Sync a local directory with an S3 bucket (or vice versa)',
  'aws s3 sync {{source}} {{destination}} {{options}}',
  'AWS',
  ARRAY['s3', 'sync', 'aws'],
  'aws s3 sync ./dist s3://my-bucket/site --delete',
  '--delete removes destination files that no longer exist in the source - omit it for additive sync only.'
);

-- aws-s3-rm (190)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-s3-rm',
  'Delete object(s) from an S3 bucket',
  'aws s3 rm {{target}} {{options}}',
  'AWS',
  ARRAY['s3', 'delete', 'aws'],
  'aws s3 rm s3://my-bucket/old-logs/ --recursive',
  '--recursive is required to delete a whole prefix/folder rather than a single object.'
);

-- aws-ec2-start (191)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-ec2-start',
  'Start one or more stopped EC2 instances',
  'aws ec2 start-instances --instance-ids {{instance_ids}} {{options}}',
  'AWS',
  ARRAY['ec2', 'start', 'instance', 'aws'],
  'aws ec2 start-instances --instance-ids i-0123456789abcdef0',
  'Accepts multiple space-separated instance IDs in a single call.'
);

-- aws-ec2-stop (192)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-ec2-stop',
  'Stop one or more running EC2 instances',
  'aws ec2 stop-instances --instance-ids {{instance_ids}} {{options}}',
  'AWS',
  ARRAY['ec2', 'stop', 'instance', 'aws'],
  'aws ec2 stop-instances --instance-ids i-0123456789abcdef0',
  'Add --hibernate to hibernate instead of a plain stop, if the instance supports it.'
);

-- aws-ec2-security-groups (193)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-ec2-security-groups',
  'Describe EC2 security groups and their inbound/outbound rules',
  'aws ec2 describe-security-groups {{options}}',
  'AWS',
  ARRAY['ec2', 'security-group', 'network', 'aws'],
  'aws ec2 describe-security-groups --group-ids sg-0123456789abcdef0',
  'Omit --group-ids to list every security group in the region.'
);

-- aws-rds-describe (194)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-rds-describe',
  'Describe RDS database instances and their status',
  'aws rds describe-db-instances {{options}}',
  'AWS',
  ARRAY['rds', 'database', 'aws'],
  'aws rds describe-db-instances --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus]" --output table',
  'Use --db-instance-identifier to target a single instance instead of listing all of them.'
);

-- aws-rds-snapshot (195)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-rds-snapshot',
  'Create a manual snapshot of an RDS database instance',
  'aws rds create-db-snapshot --db-instance-identifier {{db_instance_id}} --db-snapshot-identifier {{snapshot_id}} {{options}}',
  'AWS',
  ARRAY['rds', 'snapshot', 'backup', 'aws'],
  'aws rds create-db-snapshot --db-instance-identifier prod-db --db-snapshot-identifier prod-db-2024-01-15',
  'Snapshot creation is asynchronous - poll aws-rds-describe to check when it completes.'
);

-- aws-logs-tail (196)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-logs-tail',
  'Tail/stream a CloudWatch Logs log group in near real time',
  'aws logs tail {{log_group}} {{options}}',
  'AWS',
  ARRAY['cloudwatch', 'logs', 'monitoring', 'aws'],
  'aws logs tail /aws/lambda/my-function --follow --since 1h',
  '--follow keeps streaming new events; --since accepts values like 1h, 30m, or an ISO timestamp.'
);

-- aws-cloudwatch-metrics (197)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-cloudwatch-metrics',
  'Fetch CloudWatch metric statistics for a namespace and metric',
  'aws cloudwatch get-metric-statistics --namespace {{namespace}} --metric-name {{metric_name}} --start-time {{start_time}} --end-time {{end_time}} --period {{period}} --statistics {{statistics}} {{options}}',
  'AWS',
  ARRAY['cloudwatch', 'metrics', 'monitoring', 'aws'],
  'aws cloudwatch get-metric-statistics --namespace AWS/RDS --metric-name CPUUtilization --start-time 2024-01-15T00:00:00Z --end-time 2024-01-15T01:00:00Z --period 300 --statistics Average',
  'Start/end times must be ISO 8601. Period is in seconds and must align with the metric''s resolution.'
);

-- aws-iam-list-users (198)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-iam-list-users',
  'List IAM users in the AWS account',
  'aws iam list-users {{options}}',
  'AWS',
  ARRAY['iam', 'users', 'security', 'aws'],
  'aws iam list-users --query "Users[*].[UserName,CreateDate]" --output table',
  'Combine with aws iam list-attached-user-policies to audit what each user can do.'
);

-- aws-lambda-invoke (199)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-lambda-invoke',
  'Invoke an AWS Lambda function and capture its response',
  'aws lambda invoke --function-name {{function_name}} --payload {{payload}} {{options}} {{output_file}}',
  'AWS',
  ARRAY['lambda', 'invoke', 'serverless', 'aws'],
  'aws lambda invoke --function-name my-func --payload ''{"key":"value"}'' response.json',
  'Add --cli-binary-format raw-in-base64-out when using AWS CLI v2 with a raw JSON payload.'
);

-- aws-ecs-update-service (200)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-ecs-update-service',
  'Force a new deployment or update settings of an ECS service',
  'aws ecs update-service --cluster {{cluster}} --service {{service}} {{options}}',
  'AWS',
  ARRAY['ecs', 'deploy', 'container', 'aws'],
  'aws ecs update-service --cluster prod --service api --force-new-deployment',
  '--force-new-deployment rolls containers with the same task definition, picking up a fresh image tag (e.g. :latest).'
);

-- aws-elb-describe (201)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-elb-describe',
  'Describe target group health behind an Application/Network Load Balancer',
  'aws elbv2 describe-target-health --target-group-arn {{target_group_arn}} {{options}}',
  'AWS',
  ARRAY['elb', 'load-balancer', 'health', 'aws'],
  'aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/api/abc123',
  'Use aws elbv2 describe-load-balancers first to find ARNs if you don''t have one handy.'
);

-- aws-sso-login (202)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-sso-login',
  'Authenticate an AWS CLI profile via IAM Identity Center (SSO)',
  'aws sso login --profile {{profile}} {{options}}',
  'AWS',
  ARRAY['sso', 'login', 'auth', 'aws'],
  'aws sso login --profile prod',
  'Opens a browser for authentication; the resulting session token is cached for the profile.'
);

-- aws-cloudformation-describe-stacks (203)
INSERT INTO commands (name, description, command_template, category, tags, example, syntax_help)
VALUES (
  'aws-cloudformation-describe-stacks',
  'Describe CloudFormation stacks and their current status',
  'aws cloudformation describe-stacks {{options}}',
  'AWS',
  ARRAY['cloudformation', 'stack', 'infrastructure', 'aws'],
  'aws cloudformation describe-stacks --stack-name prod-network --query "Stacks[*].StackStatus"',
  'Omit --stack-name to list every stack in the region.'
);

-- ============================================
-- COMMAND PROPERTIES - POSTGRESQL / MYSQL / AWS
-- ============================================

-- psql-connect (156)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (156, 'host', 'text', 'localhost', true, '192.168.1.1 or db.example.com', 'PostgreSQL host address or IP', 1),
  (156, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (156, 'database', 'text', 'postgres', false, 'database_name', 'Database to connect to', 3),
  (156, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 4),
  (156, 'options', 'text', '', false, '-c "SELECT 1;"', 'Additional psql options', 5);

-- pg-db-size (157)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (157, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (157, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (157, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (157, 'database', 'text', '', true, 'database_name', 'Database to check the size of', 4);

-- pg-all-db-sizes (158)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (158, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (158, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (158, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3);

-- pg-table-sizes (159)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (159, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (159, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (159, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (159, 'database', 'text', '', true, 'database_name', 'Database to inspect', 4),
  (159, 'limit', 'number', '20', false, '20', 'Number of tables to show', 5);

-- pg-active-connections (160)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (160, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (160, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (160, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (160, 'database', 'text', 'postgres', true, 'database_name', 'Database to connect to', 4);

-- pg-connection-count (161)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (161, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (161, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (161, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (161, 'database', 'text', 'postgres', true, 'database_name', 'Database to connect to', 4);

-- pg-kill-connection (162)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (162, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (162, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (162, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (162, 'database', 'text', 'postgres', true, 'database_name', 'Database to connect to', 4),
  (162, 'pid', 'number', '', true, '12345', 'Backend process ID to terminate', 5);

-- pg-long-running-queries (163)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (163, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (163, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (163, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (163, 'database', 'text', 'postgres', true, 'database_name', 'Database to connect to', 4),
  (163, 'threshold', 'text', '5 minutes', true, '5 minutes, 1 hour', 'Minimum query duration to flag', 5);

-- pg-version (164)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (164, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (164, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (164, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (164, 'database', 'text', 'postgres', false, 'database_name', 'Database to connect to', 4);

-- pg-list-databases (165)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (165, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (165, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (165, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (165, 'options', 'text', '', false, '--no-psqlrc', 'Additional psql options', 4);

-- pg-list-tables (166)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (166, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (166, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (166, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (166, 'database', 'text', '', true, 'database_name', 'Database to inspect', 4),
  (166, 'schema', 'text', 'public', false, 'public', 'Schema to list tables from', 5);

-- pg-create-user (167)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (167, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (167, 'username', 'text', 'postgres', true, 'db_user', 'Admin username to connect with', 2),
  (167, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (167, 'database', 'text', 'postgres', true, 'database_name', 'Database to connect to', 4),
  (167, 'new_user', 'text', '', true, 'app_user', 'Name of the role/user to create', 5),
  (167, 'new_password', 'password', '', true, 'strong_password', 'Password for the new role', 6),
  (167, 'options', 'text', 'LOGIN', false, 'LOGIN, CREATEDB, SUPERUSER', 'Additional role attributes', 7);

-- pg-grant-privileges (168)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (168, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (168, 'username', 'text', 'postgres', true, 'db_user', 'Admin username to connect with', 2),
  (168, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (168, 'database', 'text', 'postgres', true, 'database_name', 'Database to connect to', 4),
  (168, 'privileges', 'text', 'ALL PRIVILEGES', true, 'ALL PRIVILEGES, CONNECT, TEMP', 'Privileges to grant', 5),
  (168, 'target_database', 'text', '', true, 'database_name', 'Database to grant privileges on', 6),
  (168, 'target_user', 'text', '', true, 'app_user', 'Role/user receiving the privileges', 7);

-- pg-vacuum-analyze (169)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (169, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (169, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (169, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (169, 'database', 'text', '', true, 'database_name', 'Database to vacuum', 4),
  (169, 'table', 'text', '', false, 'orders', 'Specific table to vacuum (leave empty for whole database)', 5);

-- pg-isready (170)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (170, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (170, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 2),
  (170, 'username', 'text', 'postgres', false, 'db_user', 'PostgreSQL username', 3),
  (170, 'options', 'text', '', false, '-t 5 (timeout seconds)', 'Additional pg_isready options', 4);

-- pg-locks (171)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (171, 'host', 'text', 'localhost', true, '192.168.1.1', 'PostgreSQL host', 1),
  (171, 'username', 'text', 'postgres', true, 'db_user', 'PostgreSQL username', 2),
  (171, 'port', 'number', '5432', false, '5432', 'PostgreSQL port', 3),
  (171, 'database', 'text', '', true, 'database_name', 'Database to connect to', 4);

-- mysql-connect (172)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (172, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (172, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (172, 'password', 'password', '', false, 'your_password', 'MySQL password (leave empty for prompt)', 3),
  (172, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (172, 'database', 'text', '', false, 'database_name', 'Database to connect to', 5);

-- mysql-db-size (173)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (173, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (173, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (173, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (173, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (173, 'database', 'text', '', true, 'database_name', 'Database to check the size of', 5);

-- mysql-all-db-sizes (174)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (174, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (174, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (174, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (174, 'port', 'number', '3306', false, '3306', 'MySQL port', 4);

-- mysql-table-sizes (175)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (175, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (175, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (175, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (175, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (175, 'database', 'text', '', true, 'database_name', 'Database to inspect', 5),
  (175, 'limit', 'number', '20', false, '20', 'Number of tables to show', 6);

-- mysql-show-processlist (176)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (176, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (176, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (176, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (176, 'port', 'number', '3306', false, '3306', 'MySQL port', 4);

-- mysql-connection-count (177)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (177, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (177, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (177, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (177, 'port', 'number', '3306', false, '3306', 'MySQL port', 4);

-- mysql-kill-process (178)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (178, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (178, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (178, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (178, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (178, 'process_id', 'number', '', true, '482', 'Process/connection ID to kill', 5);

-- mysql-version (179)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (179, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (179, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (179, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (179, 'port', 'number', '3306', false, '3306', 'MySQL port', 4);

-- mysql-show-databases (180)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (180, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (180, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (180, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (180, 'port', 'number', '3306', false, '3306', 'MySQL port', 4);

-- mysql-show-tables (181)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (181, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (181, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (181, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (181, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (181, 'database', 'text', '', true, 'database_name', 'Database to inspect', 5);

-- mysql-create-user-grant (182)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (182, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (182, 'username', 'text', 'root', true, 'db_user', 'Admin username to connect with', 2),
  (182, 'password', 'password', '', false, 'your_password', 'Admin password', 3),
  (182, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (182, 'new_user', 'text', '', true, 'app', 'Name of the user to create', 5),
  (182, 'new_host', 'text', '%', true, '%, localhost, 10.0.%', 'Host pattern the new user connects from', 6),
  (182, 'new_password', 'password', '', true, 'strong_password', 'Password for the new user', 7),
  (182, 'privileges', 'text', 'ALL', true, 'ALL, SELECT, SELECT,INSERT,UPDATE', 'Privileges to grant', 8),
  (182, 'target_database', 'text', '', true, 'database_name', 'Database the privileges apply to', 9);

-- mysql-optimize-table (183)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (183, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (183, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (183, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (183, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (183, 'database', 'text', '', true, 'database_name', 'Database containing the table', 5),
  (183, 'table', 'text', '', true, 'orders', 'Table to optimize', 6);

-- mysqladmin-ping (184)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (184, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (184, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (184, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (184, 'port', 'number', '3306', false, '3306', 'MySQL port', 4);

-- mysql-show-status (185)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (185, 'host', 'text', 'localhost', true, '192.168.1.1', 'MySQL host', 1),
  (185, 'username', 'text', 'root', true, 'db_user', 'MySQL username', 2),
  (185, 'password', 'password', '', false, 'your_password', 'MySQL password', 3),
  (185, 'port', 'number', '3306', false, '3306', 'MySQL port', 4),
  (185, 'pattern', 'text', 'Threads%', true, 'Threads%, Uptime, Queries', 'LIKE pattern to filter status variables', 5);

-- aws-configure (186)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (186, 'options', 'text', '', false, '--profile prod', 'Profile or other aws configure options', 1);

-- aws-whoami (187)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (187, 'options', 'text', '', false, '--profile prod', 'Profile or output options', 1);

-- aws-s3-cp (188)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (188, 'source', 'text', '', true, './backup.sql or s3://bucket/key', 'Source file or S3 path', 1),
  (188, 'destination', 'text', '', true, 's3://bucket/key or ./local-path', 'Destination file or S3 path', 2),
  (188, 'options', 'text', '', false, '--recursive, --acl private', 'Additional s3 cp options', 3);

-- aws-s3-sync (189)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (189, 'source', 'text', '', true, './dist or s3://bucket/prefix', 'Source directory or S3 path', 1),
  (189, 'destination', 'text', '', true, 's3://bucket/prefix or ./local-dir', 'Destination directory or S3 path', 2),
  (189, 'options', 'text', '', false, '--delete, --exact-timestamps', 'Additional s3 sync options', 3);

-- aws-s3-rm (190)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (190, 'target', 'text', '', true, 's3://bucket/key or s3://bucket/prefix/', 'S3 object or prefix to delete', 1),
  (190, 'options', 'text', '', false, '--recursive, --dryrun', 'Additional s3 rm options', 2);

-- aws-ec2-start (191)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (191, 'instance_ids', 'text', '', true, 'i-0123456789abcdef0', 'Space-separated EC2 instance IDs', 1),
  (191, 'options', 'text', '', false, '--profile prod, --region us-east-1', 'Additional options', 2);

-- aws-ec2-stop (192)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (192, 'instance_ids', 'text', '', true, 'i-0123456789abcdef0', 'Space-separated EC2 instance IDs', 1),
  (192, 'options', 'text', '', false, '--hibernate, --force', 'Additional options', 2);

-- aws-ec2-security-groups (193)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (193, 'options', 'text', '', false, '--group-ids sg-0123456789abcdef0', 'Filter and output options', 1);

-- aws-rds-describe (194)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (194, 'options', 'text', '--query "DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus]" --output table', false, '--db-instance-identifier prod-db', 'Filter and output options', 1);

-- aws-rds-snapshot (195)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (195, 'db_instance_id', 'text', '', true, 'prod-db', 'RDS instance identifier', 1),
  (195, 'snapshot_id', 'text', '', true, 'prod-db-2024-01-15', 'Name for the new snapshot', 2),
  (195, 'options', 'text', '', false, '--profile prod', 'Additional options', 3);

-- aws-logs-tail (196)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (196, 'log_group', 'text', '', true, '/aws/lambda/my-function', 'CloudWatch Logs log group name', 1),
  (196, 'options', 'text', '--follow --since 1h', false, '--follow, --since 1h, --filter "ERROR"', 'Additional logs tail options', 2);

-- aws-cloudwatch-metrics (197)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (197, 'namespace', 'text', 'AWS/EC2', true, 'AWS/EC2, AWS/RDS, AWS/Lambda', 'CloudWatch metric namespace', 1),
  (197, 'metric_name', 'text', '', true, 'CPUUtilization', 'Metric name', 2),
  (197, 'start_time', 'text', '', true, '2024-01-15T00:00:00Z', 'Start time (ISO 8601)', 3),
  (197, 'end_time', 'text', '', true, '2024-01-15T01:00:00Z', 'End time (ISO 8601)', 4),
  (197, 'period', 'number', '300', true, '300', 'Granularity in seconds', 5),
  (197, 'statistics', 'text', 'Average', true, 'Average, Sum, Maximum, Minimum', 'Statistic to compute', 6),
  (197, 'options', 'text', '', false, '--dimensions Name=InstanceId,Value=i-0123456789abcdef0', 'Additional options (e.g. dimensions)', 7);

-- aws-iam-list-users (198)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (198, 'options', 'text', '--query "Users[*].[UserName,CreateDate]" --output table', false, '--path-prefix /app/', 'Filter and output options', 1);

-- aws-lambda-invoke (199)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (199, 'function_name', 'text', '', true, 'my-function', 'Lambda function name or ARN', 1),
  (199, 'payload', 'text', '{}', false, '{"key":"value"}', 'JSON payload to send', 2),
  (199, 'output_file', 'text', 'response.json', true, 'response.json', 'File to write the response to', 3),
  (199, 'options', 'text', '', false, '--cli-binary-format raw-in-base64-out', 'Additional invoke options', 4);

-- aws-ecs-update-service (200)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (200, 'cluster', 'text', '', true, 'prod', 'ECS cluster name', 1),
  (200, 'service', 'text', '', true, 'api', 'ECS service name', 2),
  (200, 'options', 'text', '--force-new-deployment', false, '--force-new-deployment, --desired-count 3', 'Additional update-service options', 3);

-- aws-elb-describe (201)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (201, 'target_group_arn', 'text', '', true, 'arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/api/abc123', 'Target group ARN', 1),
  (201, 'options', 'text', '', false, '--profile prod', 'Additional options', 2);

-- aws-sso-login (202)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (202, 'profile', 'text', '', true, 'prod', 'AWS CLI profile name configured for SSO', 1),
  (202, 'options', 'text', '', false, '--no-browser', 'Additional sso login options', 2);

-- aws-cloudformation-describe-stacks (203)
INSERT INTO command_properties (command_id, property_name, property_type, default_value, is_required, placeholder, description, display_order)
VALUES
  (203, 'options', 'text', '', false, '--stack-name prod-network', 'Filter and output options', 1);
