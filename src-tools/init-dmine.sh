#!/bin/bash

### Run a Minetest-Docker image Usage:help
# 
# Usage:
# 
# 	run-dmine.sh IMAGE [ -d MINETESTDATA ] [ -p PORT ] [-t CONTAINERNAME]
# 
# MINETESTDATA - a directory or Docker volume containing the minetest user data
#
# PORT - the port Minetest will listen on
#
# CONTAINERNAME - a name for the container
# 
# See https://github.com/taikedz/minetest-docker
#
###/doc

#%include autohelp.sh notest.sh bashout.sh colours.sh

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

get_title_arg() {
	local title="$(get_arg_for -t "$@")"

	[[ -n "$title" ]] && mttitle=(-t "$title")
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

	get_title_arg

	docker run "${mttitle[@]}" -d "$imagename" -v "$mtdatadir:/root/minetest/userdata" -p "$mtport:$mtport/udp"

}

notest main "$@"
