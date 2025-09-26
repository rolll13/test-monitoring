#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
MONITOR_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test"
RESTART_THRESHOLD=60

while true; do
    PID=$(pgrep -x "$PROCESS_NAME")
    if [ -n "$PID" ]; then
        # check process restarting 
        ELAPSED=$(ps -o etimes= -p "$PID" | tr -d ' ')
        if [ "$ELAPSED" -lt "$RESTART_THRESHOLD" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Process $PROCESS_NAME was recently restarted (uptime: ${ELAPSED}s)" >> "$LOG_FILE"
        fi
        # check server availability
        if ! curl -fsS -m 5 "$MONITOR_URL" -o /dev/null; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Monitoring server not reachable" >> "$LOG_FILE"
        fi
    fi
    sleep "$RESTART_THRESHOLD"
done