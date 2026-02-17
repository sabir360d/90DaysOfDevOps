#!/bin/bash

# Usage: ./log_generator.sh <log_file_path> <num_lines>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <log_file_path> <num_lines>"
    exit 1
fi

log_file="$1"
num_lines="$2"

[ -e "$log_file" ] && { echo "Error: File exists at $log_file"; exit 1; }

# Define log levels and their messages
declare -A messages
messages[INFO]="System started successfully|User logged in|Configuration loaded"
messages[DEBUG]="Variable initialized|Entering function process_data|Connection object created"
messages[WARNING]="Memory usage high|CPU usage above threshold|Disk nearing capacity"
messages[ERROR]="Failed to connect|Disk full|Segmentation fault|Invalid input|Out of memory"
messages[CRITICAL]="Disk space below threshold|Database connection lost|Kernel panic detected|Service unavailable"

log_levels=(INFO DEBUG WARNING ERROR CRITICAL)

generate_log_line() {
    local level="${log_levels[RANDOM % ${#log_levels[@]}]}"
    local opts="${messages[$level]}"
    IFS='|' read -r -a arr <<< "$opts"
    local msg="${arr[RANDOM % ${#arr[@]}]}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $msg"
}

for ((i=0; i<num_lines; i++)); do
    generate_log_line >> "$log_file"
done

echo "Log file created at: $log_file with $num_lines lines."

