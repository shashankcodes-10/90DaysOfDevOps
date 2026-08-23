# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

## Objective

Today I applied the shell scripting concepts from Days 16–18 to practical DevOps automation tasks.

- Log rotation
- Server backups
- Cron scheduling
- Combining maintenance tasks into one script

---

# Task 1 – Log Rotation Script

## Objective

Create `log_rotate.sh` that:
- Accepts a log directory as an argument
- Compresses `.log` files older than 7 days
- Deletes `.gz` files older than 30 days
- Displays the number of compressed and deleted files
- Exits if the directory does not exist

## Script: `log_rotate.sh`

```bash
#!/bin/bash

LOG_DIR=$1

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory does not exist"
    exit 1
fi

compressed=0
deleted=0

while IFS= read -r file
do
    gzip "$file"
    ((compressed++))
done < <(find "$LOG_DIR" -name "*.log" -mtime +7 -type f)

while IFS= read -r file
do
    rm "$file"
    ((deleted++))
done < <(find "$LOG_DIR" -name "*.gz" -mtime +30 -type f)

echo "Files compressed: $compressed"
echo "Files deleted: $deleted"
```

## Commands

```bash
chmod +x log_rotate.sh
./log_rotate.sh /var/log/myapp
```

## Key commands

```bash
find /path -name "*.log" -mtime +7 -type f
gzip file.log
find /path -name "*.gz" -mtime +30 -type f
rm file.gz
```

---

# Task 2 – Server Backup Script

## Script: `backup.sh`

```bash
#!/bin/bash

SOURCE_DIR=$1
BACKUP_DIR=$2

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

DATE=$(date +%Y-%m-%d)
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [ $? -eq 0 ] && [ -f "$BACKUP_FILE" ]; then
    echo "Backup created successfully"
    echo "Archive: $BACKUP_FILE"
    du -h "$BACKUP_FILE"
else
    echo "Backup failed"
    exit 1
fi

find "$BACKUP_DIR" -name "*.tar.gz" -mtime +14 -type f -delete

echo "Old backups cleaned successfully"
```

## Commands

```bash
chmod +x backup.sh
./backup.sh /path/to/source /path/to/backup
```

```bash
date +%Y-%m-%d
tar -czf backup.tar.gz /source/dir
du -h backup.tar.gz
find /path -name "*.tar.gz" -mtime +14 -type f -delete
```

---

# Task 3 – Crontab

## Check Existing Cron Jobs

```bash
crontab -l
```

## Cron Syntax

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

## Log Rotation – Every Day at 2 AM

```cron
0 2 * * * /path/to/log_rotate.sh /var/log/myapp
```

## Backup – Every Sunday at 3 AM

```cron
0 3 * * 0 /path/to/backup.sh /path/to/source /path/to/backup
```

## Health Check – Every 5 Minutes

```cron
*/5 * * * * /path/to/health_check.sh
```

---

# Task 4 – Combined Maintenance Script

## Script: `maintenance.sh`

```bash
#!/bin/bash

LOG_DIR="/var/log/myapp"
SOURCE_DIR="/path/to/source"
BACKUP_DIR="/path/to/backup"
LOG_FILE="/var/log/maintenance.log"

echo "$(date): Maintenance started" >> "$LOG_FILE"

echo "$(date): Starting log rotation" >> "$LOG_FILE"
./log_rotate.sh "$LOG_DIR" >> "$LOG_FILE" 2>&1

echo "$(date): Starting backup" >> "$LOG_FILE"
./backup.sh "$SOURCE_DIR" "$BACKUP_DIR" >> "$LOG_FILE" 2>&1

echo "$(date): Maintenance completed" >> "$LOG_FILE"
```

Make it executable:

```bash
chmod +x maintenance.sh
```

Run daily at 1 AM:

```cron
0 1 * * * /path/to/maintenance.sh
```

---

# Useful Commands Practiced

```bash
$1
$2
$?
```

- `$1` → first script argument
- `$2` → second script argument
- `$?` → exit status of the previous command

```bash
if [ ! -d "$SOURCE_DIR" ]; then
```

Checks whether a directory does not exist.

```bash
mkdir -p "$BACKUP_DIR"
```

Creates a directory if it does not exist.

```bash
find "$LOG_DIR" -name "*.log" -mtime +7 -type f
```

Finds regular `.log` files older than 7 days.

```bash
gzip file.log
```

Compresses a log file.

```bash
tar -czf backup.tar.gz /source
```

Creates a compressed tar archive.

```bash
du -h backup.tar.gz
```

Shows archive size in human-readable format.

```bash
crontab -l
```

Lists current user's cron jobs.

```bash
crontab -e
```

Opens the user's crontab for editing.

---

# Troubleshooting Flow

If the backup script fails:

```text
1. Check whether the source directory exists
             ↓
2. Check whether the backup directory exists
             ↓
3. Check script permissions
             ↓
4. Run the script manually
             ↓
5. Check whether the .tar.gz file was created
             ↓
6. Check the archive size
             ↓
7. Check the cron configuration
             ↓
8. Check maintenance logs
```

Useful commands:

```bash
ls -ld /path/to/source
ls -ld /path/to/backup
ls -lh /path/to/backup
crontab -l
cat /var/log/maintenance.log
```

---

# What I Learned

1. Shell scripts can automate repetitive DevOps tasks such as backups and log management.
2. `find`, `tar`, `gzip`, and cron can be combined to create automated maintenance workflows.
3. Error handling and verification are important because automation should not silently fail.

---

# Day 19 Takeaway

```text
Validate
   ↓
Perform Operation
   ↓
Verify Result
   ↓
Log Result
   ↓
Automate with Cron
```

These concepts can be reused for production server maintenance, automated backups, log management, and scheduled DevOps tasks.

---

# Submission Checklist

- [ ] `day-19-project.md`
- [ ] `log_rotate.sh`
- [ ] `backup.sh`
- [ ] `maintenance.sh`
- [ ] Health check script
- [ ] Cron entries documented
- [ ] Scripts tested
- [ ] Changes committed
- [ ] Changes pushed to GitHub

---

# Learn in Public

Today I practiced shell scripting by building automated log rotation, backup, and cron-based maintenance workflows.

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
