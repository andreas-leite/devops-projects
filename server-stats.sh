#!/bin/bash

# Function to display a separator line for readability
separator() {
    echo "-------------------------------------------"
}

# Get total CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Get memory usage
MEMORY_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEMORY_USED=$(free -m | awk '/Mem:/ {print $3}')
MEMORY_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEMORY_USAGE_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($MEMORY_USED/$MEMORY_TOTAL)*100}")

# Get disk usage for root (/) filesystem
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_AVAILABLE=$(df -h / | awk 'NR==2 {print $4}')
DISK_USAGE_PERCENT=$(df -h / | awk 'NR==2 {print $5}')

# Top 5 processes by CPU usage
TOP_CPU_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)

# Top 5 processes by memory usage
TOP_MEM_PROCESSES=$(ps -eo pid,comm,%mem --sort=-%mem | head -n 6)

# Stretch stats
OS_VERSION=$(lsb_release -d | awk -F"\t" '{print $2}')
UPTIME=$(uptime -p)
LOAD_AVERAGE=$(uptime | awk -F'load average: ' '{print $2}')
LOGGED_IN_USERS=$(who | wc -l)
FAILED_LOGINS=$(journalctl _SYSTEMD_UNIT=sshd.service | grep 'Failed password' | wc -l)

# Display the collected data
separator
echo "Total CPU Usage: $CPU_USAGE"
separator
echo "Memory Usage: $MEMORY_USED MB / $MEMORY_TOTAL MB ($MEMORY_USAGE_PERCENT%)"
echo "Memory Free: $MEMORY_FREE MB"
separator
echo "Disk Usage (Root /): Used $DISK_USED of $DISK_TOTAL ($DISK_USAGE_PERCENT)"
echo "Disk Available: $DISK_AVAILABLE"
separator
echo "Top 5 Processes by CPU Usage:"
echo "$TOP_CPU_PROCESSES"
separator
echo "Top 5 Processes by Memory Usage:"
echo "$TOP_MEM_PROCESSES"
separator
echo "OS Version: $OS_VERSION"
echo "System Uptime: $UPTIME"
echo "Load Average: $LOAD_AVERAGE"
echo "Logged-in Users: $LOGGED_IN_USERS"
echo "Failed Login Attempts: $FAILED_LOGINS"
separator
