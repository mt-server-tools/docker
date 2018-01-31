#!/bin/bash

[[ "$UID" = 0 ]] || {
	echo "You must be root to run this script"
	exit 1
}

set -euo pipefail

install_ubuntu() {
	apt-get remove docker docker-engine docker.io || :

	apt-get update

	apt-get install apt-transport-https ca-certificates curl software-properties-common -y

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

	echo|add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

	apt-get update

	apt-get install docker-ce -y
}

install_centos() {
	yum remove docker docker-common docker-selinux docker-engine || :

	yum install -y yum-utils device-mapper-persistent-data lvm2

	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

	yum-config-manager --enable docker-ce-stable

	yum install docker-ce -y
}

install_debian() {
	apt-get remove docker docker-engine docker.io || :

	apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common

	echo|curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

	# todo check uname -r and check for wheezy
	# deb-src [arch=amd64] https://download.docker.com/linux/debian wheezy stable

	apt-get update

	apt-get install docker-ce -y
}

main() {
	case "$(grep -iPo "ubuntu|centos|debian" /etc/os-release|head -n 1 | tr '[:upper:]' '[:lower:]')" in
		ubuntu)
			install_ubuntu ;;
		debian)
			install_debian ;;
		centos)
			install_centos ;;
		*)
			echo "Unsupported distro"
			exit 1
			;;
	esac
}

main "$@"
