####
# dotdepot core commands
####

####
# COMMAND: help
##

COMMANDS="${COMMANDS} help"

cmd_help() {

  if [ $# -eq 0 ]; then
    cmd_help_usage

    list_commands
    exit 0
  fi

  cmd=$1; shift

  type "cmd_${cmd}_usage" 1>/dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "unknown command: ${cmd}"
    echo "available commands: ${COMMANDS}"
    exit 1;
  fi;

  cmd_${cmd}_usage
  exit 0;
}

cmd_help_usage() {
  echo "$0 [options] help command"
}

cmd_help_description="Help"


####
# COMMAND: link
##


# take user's home (target) dir as parameter, default to ~
# take template (source) directory as parameter

COMMANDS="${COMMANDS} link"


cmd_link_MODE_PROMPT=0
cmd_link_MODE_FORCE=1
cmd_link_MODE_SKIP=2

RUN_OR_DRY=

cmd_link() {
  # mode can be prompt (0), force (1), or skip (2)
  cmd_link_mode=${cmd_link_MODE_PROMPT};

  while getopts fid OPT; do
    case "${OPT}" in
      f)
        cmd_link_mode=${cmd_link_MODE_FORCE}
        ;;
      i)
        cmd_link_mode=${cmd_link_MODE_SKIP}
        ;;
      d)
        RUN_OR_DRY=echo
        ;;
      \?)
        echo "invalid argument"
        exit 1;
    esac
  done

  link_files "${SOURCE_DIR}" "${TARGET_DIR}" ${cmd_link_mode}
}

cmd_link_usage() {
  echo "$0 [options] link [-f|i] [-d]"
}

cmd_link_description="
Links files in target directory with the ones from skeleton directory.

If a file in target directory already exists, $0 will by default prompt for
action. This can be overriden with:

-f    If file in target directory exists, overwrite it
-i    If file in target directory exists, ignore (skip) it

-d    Dry run. Show actions, but don't execute them
"

link_files() {
  local src=$1
  local dst=$2
  local mode=$3
  maxargs 'link_files' 3 "$@" || return 1

  # Holds user input
  local user_in=""

  # Open a new file descriptor for user input
  exec 3<&0

  while read file; do
    local filename=$(basename ${file})
    local removed=0
    local target="${dst}/${filename}"

    echo ${target}

    if [ -d "${target}" ]; then
      local confirm=0

      if [ ${mode} -ne ${cmd_link_MODE_FORCE} ]; then
        ${ECHO} -n "Is a directory. Remove? [y/n]: "
        read user_in <&3

        case "${user_in}" in
          [Yy]) confirm=1 ;;
          *) echo "Skipping removal of ${target} directory"; continue ;;
        esac
      else
        confirm=1
      fi

      if [ ${confirm} -eq 1 ]; then
        removed=1
        ${RUN_OR_DRY} ${RM} -rf "${target}"
      fi

    fi

    local ln_opts="-sh"

    if [ -L "${target}" ] || [ -e "${target}" ] && [ ${removed} -eq 0 ]; then

      if [ ${mode} -eq ${cmd_link_MODE_SKIP} ]; then
        echo "Skipping file ${filename}, because it exists"
        continue

      elif [ ${mode} -eq ${cmd_link_MODE_FORCE} ]; then
        ln_opts="${ln_opts}fF"

      else
        ${ECHO} -n "File exists, overwrite? [y/n]: "
        read user_in <&3

        case "${user_in}" in
          [Yy]) ln_opts="${ln_opts}fF" ;;
          *) echo "Skipping ${target}"; continue ;;
        esac
      fi

    fi

    ${RUN_OR_DRY} ${LN} ${ln_opts} "$file" "${target}"

  done <<- EOF
    $(${FIND} "${src}" -mindepth 1 -maxdepth 1)
EOF

  return 0
}


