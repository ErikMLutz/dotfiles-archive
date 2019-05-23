source ~/.dotfiles/utils/funcs.sh

repos () {
	if [[ $# -eq 0 ]]; then
		cd ~/repos
	elif containsElement pull $@ || containsElement up $@; then
		pushd ~/repos > /dev/null 2>&1
		for directory in */ ; do
			echo "Updating $directory:"
			echo "=============================================="
			pushd $directory  > /dev/null 2>&1
			if [ -d .git ]; then
				git pull
			elif [ -d .svn ]; then
				svn up
			else
				echo "No Git or SVN versioning detected."
			fi
			popd > /dev/null 2>&1
			echo
		done
		popd > /dev/null 2>&1
	elif [ -d ~/repos/$1 ]; then
		cd ~/repos/$1
	else
		echo "Not a valid argument for repos."
	fi
}

dotfiles () {
	if [[ $# -eq 0 ]]; then
		cd ~/.dotfiles
	elif containsElement pull $@ || containsElement up $@; then
		pushd ~/.dotfiles > /dev/null 2>&1
		git pull
		popd > /dev/null 2>&1
	elif containsElement install $@; then
		pushd ~/.dotfiles > /dev/null 2>&1
		./install.sh ${@:2}
		popd > /dev/null 2>&1
	else
		echo "Not a valid argument for dotfiles."
	fi
}


dk () {
	if [[ $# -eq 0 ]]; then
		echo ""
		echo "Usage: dk [OPTIONS]"
		echo ""
		echo "  Custom CLI for common Docker commands used with Airflow."
		echo ""
		echo "Example:"
		echo "  dk up -u"
	elif [[ $1 = up ]]; then
		docker-compose up -d
		OPTIND=2
		while getopts ":u" opt; do
			case $opt in
				u)
					container_name=$(docker ps --format '{{.Names}}' | grep -m 1 webserver)
					docker exec -it $container_name\
						airflow create_user \
						-f Erik -l Lutz \
						-e erik.lutz@1010data.com \
						-u admin -p admin \
						-r Admin
					;;
				\?)
					echo "Invalid option: -$OPTARG" >&2
					;;
				:)
					echo "Option -$OPTARG requires and argument." >&2
					;;
			esac
		done
	elif [[ $1 = down ]]; then
		docker-compose down
	elif [[ $1 = restart ]]; then
		docker-compose down
		docker-compose up -d
		container_name=$(docker ps --format '{{.Names}}' | grep -m 1 webserver)
		docker exec -it $container_name /bin/bash
	elif [[ $1 = exec ]]; then
		OPTIND=2
		while getopts ":u" opt; do
			case $opt in
				u)
					container_name=$(docker ps --format '{{.Names}}' | grep -m 1 webserver)
					docker exec -it $container_name\
						airflow create_user \
						-f Erik -l Lutz \
						-e erik.lutz@1010data.com \
						-u admin -p admin \
						-r Admin
					docker exec -it $container_name /bin/bash
					;;
				\?)
					echo "Invalid option: -$OPTARG" >&2
					;;
				:)
					echo "Option -$OPTARG requires and argument." >&2
					;;
			esac
		done
		if [[ $OPTIND -eq 2 ]]; then
			container_name=$(docker ps --format '{{.Names}}' | grep -m 1 webserver)
			docker exec -it $container_name /bin/bash
		fi
	elif [[ $1 = ps ]]; then
		OPTIND=2
		while getopts ":w" opt; do
			case $opt in
				w)
					watch 'docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
					;;
				\?)
					echo "Invalid option: -$OPTARG" >&2
					;;
				:)
					echo "Option -$OPTARG requires and argument." >&2
					;;
			esac
		done
		if [[ $OPTIND -eq 2 ]]; then
			docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
		fi
	fi
}
