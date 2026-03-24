#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/backup_$TIMESTAMP.log"
EMAIL="your-email@example.com"
BACKUP_RETENTION_DAYS=30

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to send email notification
send_notification() {
    local STATUS="$1"
    local MESSAGE="$2"
    
    if command -v mail &> /dev/null; then
        echo "$MESSAGE" | mail -s "Backup $STATUS: $SOURCE - $TIMESTAMP" "$EMAIL"
        log_message "Email notification sent to $EMAIL"
    else
        log_message " Mail command not available. Skipping email notification."
    fi
}

# Function to cleanup on error
cleanup_on_error() {
    log_message " Backup failed. Cleaning up incomplete files..."
    if [ -f "$DEST/backup_$TIMESTAMP.tar.gz" ]; then
        rm -f "$DEST/backup_$TIMESTAMP.tar.gz"
        log_message "Incomplete backup file removed."
    fi
}

# Trap errors and cleanup
trap cleanup_on_error EXIT

# INPUT VALIDATION

# Check if arguments are provided
if [ $# -lt 2 ]; then
    echo -e "${RED}Error: Missing arguments${NC}"
    echo "Usage: $0 <SOURCE_PATH> <DESTINATION_PATH>"
    echo "Example: $0 /home/user /mnt/backups"
    exit 1
fi

SOURCE="$1"
DEST="$2"

# Validate source exists
if [ ! -e "$SOURCE" ]; then
    log_message " ERROR: Source path does not exist: $SOURCE"
    send_notification "FAILED" "Source path does not exist: $SOURCE"
    exit 1
fi

# Validate source is readable
if [ ! -r "$SOURCE" ]; then
    log_message " ERROR: Source path is not readable: $SOURCE"
    send_notification "FAILED" "Source path is not readable: $SOURCE"
    exit 1
fi

# Validate destination exists
if [ ! -d "$DEST" ]; then
    log_message " Destination directory does not exist. Creating: $DEST"
    if ! mkdir -p "$DEST"; then
        log_message " ERROR: Failed to create destination directory: $DEST"
        send_notification "FAILED" "Failed to create destination directory: $DEST"
        exit 1
    fi
fi

# Validate destination is writable
if [ ! -w "$DEST" ]; then
    log_message " ERROR: Destination directory is not writable: $DEST"
    send_notification "FAILED" "Destination directory is not writable: $DEST"
    exit 1
fi

# DISK SPACE VALIDATION

# Get source size
SOURCE_SIZE=$(du -sb "$SOURCE" 2>/dev/null | awk '{print $1}')
if [ -z "$SOURCE_SIZE" ]; then
    log_message " ERROR: Could not determine source size"
    send_notification "FAILED" "Could not determine source size"
    exit 1
fi

# Get available space in destination
AVAILABLE_SPACE=$(df "$DEST" | tail -1 | awk '{print $4 * 1024}')
REQUIRED_SPACE=$((SOURCE_SIZE * 2)) # Account for compression overhead

if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
    log_message " ERROR: Insufficient disk space"
    log_message "   Required: $(numfmt --to=iec $REQUIRED_SPACE 2>/dev/null || echo $REQUIRED_SPACE bytes)"
    log_message "   Available: $(numfmt --to=iec $AVAILABLE_SPACE 2>/dev/null || echo $AVAILABLE_SPACE bytes)"
    send_notification "FAILED" "Insufficient disk space for backup"
    exit 1
fi

# PERFORM BACKUP

log_message "ℹ Starting backup..."
log_message "Source: $SOURCE"
log_message "Destination: $DEST"
log_message "Source Size: $(numfmt --to=iec $SOURCE_SIZE 2>/dev/null || echo $SOURCE_SIZE bytes)"

# Create backup with error checking
if tar -czf "$DEST/backup_$TIMESTAMP.tar.gz" "$SOURCE" 2>> "$LOG_FILE"; then
    BACKUP_FILE="$DEST/backup_$TIMESTAMP.tar.gz"
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')
    
    log_message " Backup completed successfully"
    log_message "Backup file: $BACKUP_FILE"
    log_message "Backup size: $BACKUP_SIZE"
    
    # Verify backup integrity
    log_message "ℹ Verifying backup integrity..."
    if tar -tzf "$BACKUP_FILE" &> /dev/null; then
        log_message " Backup integrity verified"
        BACKUP_SUCCESS=true
    else
        log_message " ERROR: Backup integrity check failed"
        send_notification "FAILED" "Backup integrity check failed"
        rm -f "$BACKUP_FILE"
        exit 1
    fi
else
    log_message " ERROR: Backup creation failed"
    send_notification "FAILED" "Backup creation failed. Check logs: $LOG_FILE"
    exit 1
fi

# CLEANUP OLD BACKUPS

log_message "Cleaning up backups older than $BACKUP_RETENTION_DAYS days..."
OLD_BACKUPS=$(find "$DEST" -name "backup_*.tar.gz" -mtime +$BACKUP_RETENTION_DAYS 2>/dev/null)

if [ -n "$OLD_BACKUPS" ]; then
    echo "$OLD_BACKUPS" | while read old_backup; do
        if rm -f "$old_backup"; then
            log_message "🗑️  Removed old backup: $(basename $old_backup)"
        else
            log_message "  Failed to remove old backup: $(basename $old_backup)"
        fi
    done
else
    log_message "No old backups to remove"
fi

# SUCCESS NOTIFICATION

echo -e "${GREEN} Backup completed successfully!${NC}"
echo -e "${BLUE}Backup file: $BACKUP_FILE${NC}"
echo -e "${BLUE}Backup size: $BACKUP_SIZE${NC}"
echo -e "${BLUE}Log file: $LOG_FILE${NC}"

send_notification "SUCCESS" "Backup completed successfully\n\nFile: $BACKUP_FILE\nSize: $BACKUP_SIZE\nLog: $LOG_FILE"

# Disable trap on successful exit
trap - EXIT

exit 0