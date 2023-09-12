#!/usr/bin/bash

if [ ! -e  "$PROGRESS_BAR_PATH" ]; then
	if [ -e "$PWD/bash-progress-bar.sh" ]; then 
		PROGRESS_BAR_PATH="$PWD/bash-progress-bar.sh"
	fi
fi

stopProgressBar(){
	kill "-${1}" $bg_pid &>/dev/null
	wait $bg_pid
}

stopAsSuccessProgressBar(){
	stopProgressBar 'SIGTERM'
}

stopProgressBarAsFail(){
	stopProgressBar 'SIGHUP'
}

stopProgressAsCanceled(){
	stopProgressBar 'SIGUSR1'
}

startProgressBar(){
	$PROGRESS_BAR_PATH 0.2 "$1" 1 $$ &
	bg_pid=$!
}