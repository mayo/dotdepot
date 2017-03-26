
# usage: maxargs LOC MAX "$@"
#
# Print and error and return 1 if there are more than MAX arguments.
maxargs() {
	LOC="$1"
	MAX="$2"
	shift 2
	if [ "$#" -gt "${MAX}" ]; then
		echo "ERROR: too many arguments ($# > ${MAX}) in ${LOC}" >&2
		return 1
	fi
}

argisset() {
  local loc
  local arg
  local fname
  local value
  loc="$1"
  arg="$2"
  fname="$3"
  value="$4"
  maxargs "argisset" 4 "$@" || return 1
  if [ -z "${value}" ]; then
    echo "ERROR: ${loc} argument $arg ($fname) is required."
    return 1
  fi
}

# Tests if give path starts with /.
is_absolute_path() {
  path=$1
  maxargs "is_absolute_path" 1 "$@" || return 1

  $(echo ${path} | grep '^/' > /dev/null)
  res=$?
  echo ${res}
  return ${res}
}

# Returns absolute path to a given directory
resolve_path() {
  path="$1"
  maxargs "resolve_path" 1 "$@" || return 1

  if [ -z "${path}" ]; then
    return 0
  fi

  absolute=$(is_absolute_path ${path})
  test_path="${SWD}/${path}"

  if [ ${absolute} -eq 0 ]; then
    test_path=${path}
  fi

  if [ ! -d $test_path ]; then
    echo "${test_path}"
    return 1
  fi

  echo $(cd "${test_path}" && pwd)
}

