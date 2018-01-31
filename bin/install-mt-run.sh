#!/bin/bash

cd "$(dirname "$0")"

bindir=/usr/local/bin

uconfirm() {
	read -p "$* y/N> " REPLY
	[[ "$REPLY" =~ (y|Y|yes|YES) ]]
}

if [[ "$UID" != 0 ]]; then
	bindir="$HOME/.local/bin"
fi

uconfirm "Install to ${bindir}$( [[ -d "$bindir" ]] || echo " (it will be created)" ) ?" || exit 1

if [[ ! "$PATH" =~ "$bindir" ]]; then
	uconfirm "Add $bindir to \$PATH in ~/.bashrc ?" || exit 1
	echo "PATH=$bindir:\$PATH" >> "$HOME/.bashrc"
	NEWSESSION=true
fi

mkdir -p "$bindir"
cp mt-run "$bindir/mt-run"

chmod 755 "$bindir/mt-run"

echo "Successfully installed mt-run"
[[ -z "${NEWSESSION}" ]] || echo "You will need to start a new session, or re-load your .bashrc file"
