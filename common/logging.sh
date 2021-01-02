#!/bin/bash
TIMESTAMP=$(date "+%T")

# If you need to save logs somewhere, use logger or tee. For example:
# logger -p local7.debug "${TIMESTAMP} ERROR: non zero return code from line: $line -- $@"

function __init () {
  case $1 in
      '--debug')
        DEBUG_MODE=1
        __debugging_info
        # set -o xtrace       # Trace the execution of the script (debug)
        ;;
      '--help')
      cat << EOF
Usage:
        --help           Displays this help
        --debug          Displays verbose output
EOF
      exit 0
      ;;
    esac
}
function __debugging_info {
  echo "About this system"
  hostnamectl
  timedatectl
  echo "Users online:"
  w -h
  echo "Memory usage:"
  free -h
  echo "Storage usage:"
  df -hP
  df -i
  du -Sh / -d 1 2> /dev/null | grep -wv 0
  echo "uptime + load-average"
  uptime
  echo "Cpu:"
  echo "Cores $(grep "model name" /proc/cpuinfo | wc -l)"
  ps axo user,pid,ppid,cmd,%cpu --sort=%cpu
}

function __msg_debug() {
  [[ "${DEBUG_MODE}" == "1" ]] && echo -e "${TIMESTAMP} [DEBUG]: $*"
}
# Usage
# __mms_debug "This error will be displayed if --debug enabled"

function __error_exit() {
  line=$1
  shift 1
  echo "${TIMESTAMP} ERROR: non zero return code from line: $line -- $@"
  exit 1
}
# Usage:
# let a++ || error_exit "$LINENO" "let operation returned non-zero code
