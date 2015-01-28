####
# dotdepot core commands
####

####
# COMMAND: help
##

COMMANDS+=" help"

cmd_help() {

  if [ $# -eq 0 ]; then
    cmd_help_usage

    list_commands
    exit 0
  fi

  cmd=$1; shift

  type "cmd_${cmd}_usage" 1>/dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "unknown command: $cmd"
    echo "available commands: $COMMANDS"
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

COMMANDS+=" link"


cmd_link_MODE_PROMPT=0
cmd_link_MODE_FORCE=1
cmd_link_MODE_SKIP=2

cmd_link() {
  # mode can be prompt (0), force (1), or skip (2)
  mode=$cmd_link_MODE_PROMPT;

  while getopts fi OPT; do
    case "$OPT" in
      f)
        mode=$cmd_link_MODE_FORCE
        ;;
      i)
        mode=$cmd_link_MODE_SKIP
        ;;
      \?)
        echo "invalid argument"
        exit 1;
    esac
  done

  link_files $SOURCE_DIR $TARGET_DIR $mode
}

cmd_link_usage() {
  echo "$0 [options] link [-f|i]"
}

cmd_link_description="
Links files in target directory with the ones from skeleton directory.

If a file in target directory already exists, $0 will by default prompt for
action. This can be overriden with:

-f    If file in target directory exists, overwrite it
-i    If file in target directory exists, ignore (skip) it
"

link_files() {
  src=$1
  dst=$2
  mode=$3
  maxargs 'link_files' 3 "$@" || return 1
  echo $@

  while read file; do
    filename=$(basename $file)

    if [ -f $dst/$filename ] || [ -d $dst/$filename ]; then
      echo "$dst/$filename"

      if [ $mode -eq $cmd_link_MODE_SKIP ]; then
        echo "skipping file $filename, because it exists"

      elif [ $mode -eq $cmd_link_MODE_FORCE ]; then
        ln -sfFh $file $dst/$filename

      else
        echo "file exists, overwrite or skip?"
      fi

    else
      ln -sh $file $dst/$filename
    fi

  done <<- EOF
    $(find $src -mindepth 1 -maxdepth 1)
EOF
  
  return 0
}


