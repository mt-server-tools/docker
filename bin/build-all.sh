#!/bin/bash

buildprofiles=(stable daily-builds)

[[ -n "${MAINTAINER:-}" ]] || {
	echo "No MAINTAINER env var defined"
	exit 1
}

[[ -n "${HUBNAME:-}" ]] || {
	echo "No NAMENAME env var defined (Docker Hub user name)"
	exit 1
}

build_profiles() {
	for profile in "$@"; do
		if [[ "$profile" = "daily" ]]; then
			profile=daily-builds
		fi

		mkdir "$profile.d" || continue

		sed "s/%%BUILDPROFILE%%/$profile/;s/%%MAINTAINER%%/$MAINTAINER/" mttemplate.Dockerfile > "$profile.d/Dockerfile" || continue
		cp bin/minetest-entrypoint.sh "$profile.d/"

		pushd "$profile.d"
		docker build -t "$HUBNAME/minetest-$profile" .
		popd

		rm -r "$profile.d"
	done
}

if [[ -n "$*" ]]; then
	build_profiles "$@"
else
	build_profiles "${buildprofiles[@]}"
fi
