#!/bin/bash
set -euo pipefail

h(){ echo -e "\n==== $1 ===="; }

host(){ h "HOST & OS"; hostname; uname -sr; }
up(){ h "UPTIME"; uptime -p; }
disk(){ h "TOP 5 DISK USAGE"; du -ah / 2>/dev/null | sort -rh | head -5; }
mem(){ h "MEMORY"; free -h; }
cpu(){ h "TOP 5 CPU"; ps -eo pid,cmd,%cpu --sort=-%cpu | head -6; }

main(){
  host
  up
  disk
  mem
  cpu
}

main

