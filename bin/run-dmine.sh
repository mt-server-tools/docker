#!/bin/bash

### Run a Minetest-Docker image Usage:help
# 
# Usage:
# 
# 	run-dmine.sh IMAGE [ -d MINETESTDATA ] [ -p PORT ]
# 
# MINETESTDATA - a directory or Docker volume containing the minetest user data
#
# PORT - the port Minetest will listen on
# 
# See https://github.com/taikedz/minetest-docker
#
###/doc

#!/bin/bash

### printhelp Usage:bbuild
# Write your help as documentation comments in your script
#
# If you need to output the help from a running script, call the
# `printhelp` function and it will print the help documentation
# in the current script to stdout
#
# A help comment looks like this:
#
#	### <title> Usage:help
#	#
#	# <some content>
#	#
#	# end with "###/doc" on its own line (whitespaces before
#	# and after are OK)
#	#
#	###/doc
#
###/doc

CHAR='#'

function printhelp {
	local USAGESTRING=help
	local TARGETFILE=$0
	if [[ -n "$*" ]]; then USAGESTRING="$1" ; shift; fi
	if [[ -n "$*" ]]; then TARGETFILE="$1" ; shift; fi

        echo -e "\n$(basename "$TARGETFILE")\n===\n"
        local SECSTART='^\s*'"$CHAR$CHAR$CHAR"'\s+(.+?)\s+Usage:'"$USAGESTRING"'\s*$'
        local SECEND='^\s*'"$CHAR$CHAR$CHAR"'\s*/doc\s*$'
        local insec="$(mktemp --tmpdir)"; rm "$insec"
        cat "$TARGETFILE" | while read secline; do
                if [[ "$secline" =~ $SECSTART ]]; then
                        touch "$insec"
                        echo -e "\n${BASH_REMATCH[1]}\n---\n"
                elif [[ -f $insec ]]; then
                        if [[ "$secline" =~ $SECEND ]]; then
                                rm "$insec"
                        else
				echo "$secline" | sed -r "s/^\s*$CHAR//g"
                        fi
                fi
        done
        if [[ -f "$insec" ]]; then
                echo "WARNING: Non-terminated help block." 1>&2
		rm "$insec"
        fi
	echo ""
}

### automatic help Usage:main
#
# automatically call help if "--help" is detected in arguments
#
###/doc
if [[ "$@" =~ --help ]]; then
	cols="$(tput cols)"
	printhelp | fold -w "$cols" -s
	exit 0
fi
### notest FUNCTION ARGUMENTS Usage:bbuild
#
# This function performs a simple test to see if the "BBSETTESTMODE" variable is set to the string "test mode"
#
# If so, it does NOT call the function. In all other cases, the function is called with the arguments.
#
# The purpose of this function is to allow a simple method to encourage testability: source notest.sh in your test script, and set the BBTESTMODE variable to "test mode" to prevent the script from running.
#
# Example test target script, "test_target.sh":
#
#	#%include notest.sh
#
# 	function action1 { ... }
#
# 	function action2 { ... }
#
# 	function main {
# 		action1
# 		action2
# 	}
#
# 	notest main "$@"
#
# Example test script:
#
# 	. ~/.local/lib/bbuild/notest.sh
# 	BBTESTMODE="test mode"
#
# 	# main will not run
# 	. test_target.sh
#
# 	action1 || echo failed action1
#
# 	action2 || echo failed action2
#
# You can source a file with this kind of structure without the risk of triggering its runtime. This allows the file to be sourced and tested safely.
#
###/doc

function notest {
	local funcall="$1"; shift

	if [[ "${BBTESTMODE:-}" != "test mode" ]]; then
		"$funcall" "$@"
	fi
}
#!/bin/bash


MODE_DEBUG=no
MODE_DEBUG_VERBOSE=no

### debuge MESSAGE Usage:bbuild
# print a blue debug message to stderr
# only prints if MODE_DEBUG is set to "yes"
###/doc
function debuge {
	if [[ "$MODE_DEBUG" = yes ]]; then
		echo -e "${CBBLU}DEBUG:$CBLU$*$CDEF" 1>&2
	fi
}

### infoe MESSAGE Usage:bbuild
# print a green informational message to stderr
###/doc
function infoe {
	echo -e "$CGRN$*$CDEF" 1>&2
}

### warne MESSAGE Usage:bbuild
# print a yellow warning message to stderr
###/doc
function warne {
	echo -e "${CBYEL}WARN:$CYEL $*$CDEF" 1>&2
}

### faile [CODE] MESSAGE Usage:bbuild
# print a red failure message to stderr and exit with CODE
# CODE must be a number
# if no code is specified, error code 127 is used
###/doc
function faile {
	local ERCODE=127
	local numpat='^[0-9]+$'

	if [[ "$1" =~ $numpat ]]; then
		ERCODE="$1"; shift
	fi

	echo "${CBRED}ERROR FAIL:$CRED$*$CDEF" 1>&2
	exit $ERCODE
}

function dumpe {
	echo -n "[1;35m$*" 1>&2
	echo -n "[0;35m" 1>&2
	cat - 1>&2
	echo -n "[0m" 1>&2
}

function breake {
	if [[ "$MODE_DEBUG" != yes ]]; then
		return
	fi

	read -p "${CRED}BREAKPOINT: $* >$CDEF " >&2
	if [[ "$REPLY" =~ $(echo 'quit|exit|stop') ]]; then
		faile "ABORT"
	fi
}

### Auto debug Usage:main
# When included, bashout processes a special "--debug" flag
#
# It does not remove the debug flag from arguments.
###/doc

if [[ "$*" =~ --debug ]]; then
	MODE_DEBUG=yes

	if [[ "$MODE_DEBUG_VERBOSE" = yes ]]; then
		set -x
	fi
fi
#!/bin/bash

### Colours for bash Usage:bbuild
# A series of colour flags for use in outputs.
#
# Example:
# 	
# 	echo "${CRED}Some red text ${CBBLU} some blue text $CDEF some text in the terminal's default colour"
#
# Colours available:
#
# CDEF -- switches to the terminal default
#
# CRED, CBRED -- red and bright/bold red
# CGRN, CBGRN -- green and bright/bold green
# CYEL, CBYEL -- yellow and bright/bold yellow
# CBLU, CBBLU -- blue and bright/bold blue
# CPUR, CBPUR -- purple and bright/bold purple
#
###/doc

export CRED="[31m"
export CGRN="[32m"
export CYEL="[33m"
export CBLU="[34m"
export CPUR="[35m"
export CBRED="[1;31m"
export CBGRN="[1;32m"
export CBYEL="[1;33m"
export CBBLU="[1;34m"
export CBPUR="[1;35m"
export CDEF="[0m"

dirsetup() {
	mkdir -p "$mtdatadir"
	mkdir -p "$mtdatadir/worlds"
	mkdir -p "$mtdatadir/mods"
	mkdir -p "$mtdatadir/games"

	git clone https://github.com/minetest/minetest_game "$mtdatadir/games/minetest_game"
}

get_arg_for() {
	local token="$1"; shift

	while [[ -n "$*" ]]; do
		if [[ "$1" = "$token" ]]; then
			echo "$2"
			return
		fi
		shift
	done
	return 1
}

get_port_arg() {
	local port="$(get_arg_for -p "$@")"
	[[ "$port" =~ ^[0-9]+$ ]] && mtport="$port"
}

get_dir_arg() {
	local direc="$(get_arg_for -d "$@")"
	[[ -n "$direc" ]] && {
		[[ -d "$direc" ]] || faile "'$direc' is not a directory."

		mtdatadir="$direc"
		return 0
	}
	return 1
}

main() {

	mtdatadir="$PWD/minetest"
	mtport=30000

	local imagename="$1"; shift

	get_port_arg

	get_dir_arg || dirsetup # Only if we do not receive an override

	docker run -d "$imagename" -v "$mtdatadir:/root/minetest/userdata:rw" -p "$mtport:$mtport/udp"

}

notest main "$@"
