#!/usr/bin/bash



PROGRESS_BAR_PATH="$(realpath ..)/bash-progress-bar.sh"
source ../progress-bar.sh

taskSuccess(){
	for i in $(seq 100000); do
		: &>/dev/null
	done
}

taskFail(){
	for i in $(seq 100000); do 
		echo task &> /dev/null
	done

	return 1
}
testSuccess(){
	startProgressBar "task"
	if taskSuccess; then
		stopAsSuccessProgressBar
	fi
}


testFail(){
	startProgressBar
	if ! taskFail; then 
		stopProgressBarAsFail
	fi
}



. $(which shunit2)