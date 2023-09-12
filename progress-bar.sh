#!/usr/bin/bash
PROGRESS_BAR_PATH="$(dirname $0)/bash-progress-bar.sh)"

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
	stopProgressBar 'SIGUSR1'
}

startProgressBar(){
	$PROGRESS_BAR_PATH 0.2 "$sucess_filler" 1 $$ &
	bg_pid=$!
}