
# usage: maxargs LOC MAX "${@}"
#
# Print and error and return 1 if there are more than MAX arguments.
maxargs() {
	LOC="${1}"
	MAX="${2}"
	shift 2
	if [ "$#" -gt "$MAX" ]; then
		echo "ERROR: too many arguments (${#} > ${MAX}) in ${LOC}" >&2
		return 1
	fi
}

