#!/bin/bash
set -euo pipefail

check_disk() {
    echo "Disk Usage (/):"
    df -h /
}

check_memory() {
    echo "Memory Usage:"
    free -h
}

main() {
    echo "===== SYSTEM RESOURCE CHECK ====="
    check_disk
    echo
    check_memory
}

main

