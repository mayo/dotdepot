#!/bin/sh

SCRIPT_BASE=$(dirname $0)

# System commands used throughout the scripts
LN="/bin/ln"
ECHO="/bin/echo"
RM="/bin/rm"
FIND="/usr/bin/find"

# Script Working Directory. Used to determine absolute paths to source and target.
# This should never be modified throughout the script
SWD=$(pwd)

# Holds all supported commands, separated by space
COMMANDS=""

# Load supported commands
. $SCRIPT_BASE/lib/common.sh
. $SCRIPT_BASE/lib/commands.sh

usage() {
  USAGE="Usage: `basename $0` [-hv] [-s source] [-t target] command"
  echo $USAGE
}

main() {

  while getopts hvs:t: OPT; do
    case "$OPT" in
      h)
        usage
        exit 0
        ;;
      v)
        echo `basename $0`
        exit 0
        ;;
      s)
        SOURCE_DIR=$OPTARG
        ;;
      t)
        TARGET_DIR=$OPTARG
        ;;
      \?)
        echo "Invalid argument" >&2
        usage >&2
        exit 1
        ;;
    esac
  done

  SOURCE_DIR=$(resolve_path $SOURCE_DIR)
  if [ $? -eq 1 ]; then
    echo "Invalid directory: $SOURCE_DIR"
  fi

  TARGET_DIR=$(resolve_path $TARGET_DIR)
  if [ $? -eq 1 ]; then
    echo "Invalid directory: $TARGET_DIR" >&2
    exit 1
  fi

  # Remove the switches we parsed above.
  shift `expr $OPTIND - 1`

  # Get the non-option command argument
  if [ $# -eq 0 ]; then
    echo "Please provide a command" >&2
    usage >&2
    echo
    list_commands >&2
    exit 1
  fi

  COMMAND=$1
  shift

  # Make sure the command exists
  type "cmd_${COMMAND}" 1>/dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "Invalid command: ${COMMAND}" >&2
    usage >&2
    exit 1
  fi

  # After processing all options, reset OPTIND, in case commands are doing their
  # own additional processing
  OPTIND=0

  "cmd_${COMMAND}" "$@"

 # Access additional arguments as usual through 
 # variables $@, $*, $1, $2, etc. or using this loop:
 #for PARAM in "$@"; do
 #  echo $PARAM
 #done
}

list_commands() {
  echo "Available commands are:"
  echo

  for cmd in $COMMANDS; do
    eval description=\${"cmd_${cmd}_description"}

    usage_cmd=cmd_${cmd}_usage
    usage=$($usage_cmd)

    echo "$cmd: $usage"
    echo "${description}"
    echo
  done
}

main "${@}" || exit 1

