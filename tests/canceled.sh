#!/usr/bin/bash



PROGRESS_BAR_PATH="$(realpath ..)/bash-progress-bar.sh"
source ../progress-bar.sh


taskCanceled(){
	startProgressBar
	for i in $(seq 1000); do
		read
	done
}

handleSigInt(){
	stopProgressAsCanceled
	exit
}

trap handleSigInt SIGINT
taskCanceled

