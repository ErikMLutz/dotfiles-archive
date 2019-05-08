containsElement () {
  local array match="$1"
  shift
  for array; do [[ "$array" == "$match" ]] && return 0; done
  return 1
}

repos () {
	if [[ $# -eq 0 ]]; then
		cd ~/repos
	elif containsElement pull $@; then
		pushd ~/repos > /dev/null 2>&1
		for directory in */ ; do
			echo "Updating $directory:"
			echo "=============================================="
			pushd $directory  > /dev/null 2>&1
			if [ -d .git ]; then
				git pull
			elif [ -d .svn ]; then
				svn up
			else;
				echo "No Git or SVN versioning detected."
			fi
			popd > /dev/null 2>&1
			echo
		done
		popd > /dev/null 2>&1
	fi
}
