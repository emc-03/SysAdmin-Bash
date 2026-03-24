====================================================
LINUX SYSTEM ADMINISTRATION SCRIPTS
====================================================

PROJECT DESCRIPTION:
A collection of bash scripts for Linux system administration,
user management, file operations, and monitoring.

====================================================
REPOSITORY STRUCTURE:
====================================================

/monitoring/
  - system_info.sh          Display CPU, RAM, disk usage, and OS details
  - cpu_memory_monitor.sh   Real-time CPU and memory usage logging

/users/*In Progress
  - create_user.sh          Create new users with error checking
  - list_users.sh           List all users and their groups

/files/*In Progress
  - backup.sh               Compress and backup directories with timestamps
  - cleanup.sh              Delete files older than N days

/networking/*In Progress
  - network_info.sh         Display IP addresses and open ports

/automation/* In Progress
  - cron_setup.sh           Automate scheduling of tasks

====================================================
REQUIREMENTS:
====================================================

- Linux/Unix-based OS (Ubuntu, CentOS, Debian, etc.)
- Bash shell (version 4.0+)
- sudo privileges for user management scripts
- curl (for public IP in network_info.sh)
- Common utilities: grep, awk, sed, find, tar

Installation:
  https://www.linux.org/pages/download/
  Ubuntu/Debian: sudo apt-get update && sudo apt-get install curl
  CentOS/RHEL:   sudo yum install curl

====================================================
QUICK START:
====================================================

1. Clone the repository:
   git clone https://github.com/YOUR_USERNAME/linux-scripts.git
   cd linux-scripts

2. Make scripts executable:
   chmod +x */*.sh

3. Run a script:
   ./monitoring/system_info.sh
   ./users/create_user.sh
   ./files/backup.sh /source/path /backup/path

====================================================
SCRIPT USAGE EXAMPLES:
====================================================

MONITORING:
  ./monitoring/system_info.sh
    - Shows system information (hostname, OS, CPU, RAM, disk)

  ./monitoring/cpu_memory_monitor.sh
    - Logs CPU and memory usage every 5 seconds (press Ctrl+C to stop)

USERS:
  ./users/create_user.sh
    - Creates a new user with home directory and password
    - Includes duplicate user detection and validation

  ./users/list_users.sh
    - Lists all non-system users and their group memberships

FILES:
  ./files/backup.sh /home/user /mnt/backups
    - Creates timestamped compressed backup of /home/user
    - Saves to /mnt/backups/backup_YYYYMMDD_HHMMSS.tar.gz

  ./files/cleanup.sh /tmp
    - Removes files in /tmp older than 30 days

NETWORKING:
  ./networking/network_info.sh
    - Displays local IP, public IP, and listening ports

AUTOMATION:
  ./automation/cron_setup.sh
    - Adds automated backup task to crontab (runs daily at 2 AM)

====================================================
ERROR HANDLING:
====================================================

All scripts include error checking for:
- Empty or invalid input
- Duplicate/existing users
- Failed command execution
- Missing files or directories
- Permission issues

Scripts use color-coded output:
- GREEN   = Success
- RED     = Error
- YELLOW  = Warning

====================================================
FEATURES:
====================================================

- Beginner-friendly with inline comments
- Input validation and error handling
- Color-coded output for clarity
- Automatic cleanup on failures
- Timestamp support for backups
- Sudo privilege handling
- Cross-platform Linux compatibility

====================================================
TROUBLESHOOTING:
====================================================

Permission Denied:
  chmod +x script_name.sh

Sudo Password Required:
  Some scripts need sudo. Enter your password when prompted.

Command Not Found:
  Ensure you're in the correct directory: cd linux-scripts/

Script Fails to Run:
  Check shebang line: #!/bin/bash (should be first line)
  Verify Bash version: bash --version

====================================================
LEARNING RESOURCES:
====================================================

- Linux Command Line Basics: man bash
- Bash Scripting Guide: https://www.gnu.org/software/bash/manual/
- ShellCheck (Bash linter): https://www.shellcheck.net/
- Linux System Administration: https://linux.die.net/

====================================================
FUTURE IMPROVEMENTS : 
====================================================
- Log Rotation Script, archve and compress old logs
- Create Service Status Monitor
- Add Disk Space Alert
- Automated Security Updates
- Database Backup Automation
- System Health Dashboard
- Email Notifications for Critical Alerts
- Performance Tuning, optimize settings I/O scheduler
- Automated System Report Generator 

===================================================
AUTHOR NOTES: 
====================================================

Created for Linux system administration learning and portfolio building.

For questions or issues, please open a GitHub Issue.

====================================================
CHANGELOG:
====================================================
v1.0 (Initial Release)
  - Added system monitoring scripts
  - Added user management scripts with error checking
  - Added file backup and cleanup scripts
  - Added networking information script
  - Added cron automation setup

====================================================