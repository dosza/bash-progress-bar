#!/usr/bin/env bash 

GREEN=$'\e[1;32m'
BOLD=$'\e[1m'
RED=$'\e[1;31m'
BLUE=$'\e[1;34m'
DEFAULT=$'\e[0m'
_PPID=$4

LINE_BAR=(
	'[===                                    ]'
	'[   ===                                 ]'
	'[      ===                              ]'
	'[         ===                           ]'
	'[            ===                        ]'
	'[               ===                     ]'
	'[                  ===                  ]'
	'[                     ===               ]'
	'[                        ===            ]'
	'[                           ===         ]'
	'[                              ===      ]'
	'[                                 ===   ]'
	'[                                    ===]'
	'[                                 ===   ]'
	'[                              ===      ]'
	'[                           ===         ]'
	'[                        ===            ]'
	'[                     ===               ]'
	'[                  ===                  ]'
	'[               ===                     ]'
	'[            ===                        ]'
	'[         ===                           ]'
	'[      ===                              ]'
	'[   ===                                 ]'
	'[===                                    ]'	
)

EMOJI_BAR=(
	'[🟦️                                    ]'
	'[   🟦️                                 ]'
	'[      🟦️                              ]'
	'[         🟦️                           ]'
	'[            🟦️                        ]'
	'[               🟦️                     ]'
	'[                  🟦️                  ]'
	'[                     🟦️               ]'
	'[                        🟦️            ]'
	'[                           🟦️         ]'
	'[                              🟦️      ]'
	'[                                 🟦️   ]'
	'[                                    🟦️]'
	'[                                 🟦️   ]'
	'[                              🟦️      ]'
	'[                           🟦️         ]'
	'[                        🟦️            ]'
	'[                     🟦️               ]'
	'[                  🟦️                  ]'
	'[               🟦️                     ]'
	'[            🟦️                        ]'
	'[         🟦️                           ]'
	'[      🟦️                              ]'
	'[   🟦️                                 ]'
	'[🟦️                                    ]'
)

FINISH_EMOJI_BAR='[🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️🟦️]'
FINISH_BAR='[=======================================]'
SPINER_CLOCK=(🕛️ 🕑️ 🕒️ 🕕️ 🕗️ 🕘️ )
SPINER=("|" "/" "—" '\')
MESSAGE="$2"
BAR_TYPE=$3
STATUS_PARENT='failed'

doExit(){
	exit
}

onSuccessFinishEmojiBar(){
	local correct_emoji="${BLUE}✅${DEFAULT}"
	echo -e "\r[ ${correct_emoji} ] ${FINISH_EMOJI_BAR}\t${MESSAGE} success!                  "
	doExit
}

onFailedEmojiBar(){
	local fail_label="${RED}❌${DEFAULT}"
	echo -e "\r[ ${fail_label} ] ${FINISH_EMOJI_BAR}\t${MESSAGE} $STATUS_PARENT!                  "
	doExit
}

onSuccessFinishProgressBar(){
	local sucess_label="${GREEN}+${DEFAULT}"
	echo -e "\r[ ${sucess_label} ] ${FINISH_BAR}\t${MESSAGE} success!                  "
	doExit
}

onFailedProgressBar(){
	local status="${RED}X${DEFAULT}"
	echo -e "\r[ ${status} ] ${FINISH_BAR}\t${MESSAGE} $STATUS_PARENT!                  "
	doExit
}

checkIfProcessParentIsALive(){

	local count=$((i%100))
	[ $count !=  0 ] && return 
	if !  ps --pid "${_PPID}" &> /dev/null; then 
		handleExitFailed
	fi
}


runProgressBar(){
	declare -n ref_spiner=$1
	declare -n ref_progress_bar=$2

	local -i i=0
	local progress_bar_size=${#ref_progress_bar[@]}
	local spiner_size=${#ref_spiner[@]}

	while true; do 
		index_progress_bar=$((i%progress_bar_size))
		index_spiner=$((i%spiner_size))
		current_progress_bar="${ref_progress_bar[$index_progress_bar]}"
		current_spiner="${BLUE}${ref_spiner[$index_spiner]}${DEFAULT}"
		message="\r[ ${current_spiner} ] ${current_progress_bar}\tplease wait $3 ..."
		echo -en "$message"
		sleep $4
		checkIfProcessParentIsALive
		let i++
	done
}

startEmojiProgressBar(){
	runProgressBar SPINER_CLOCK EMOJI_BAR "$2" "$1"
}

startSimpleProgressBar(){
	runProgressBar SPINER LINE_BAR "$2" "$1"
}

handleSigTerm(){
	[  "$BAR_TYPE" = "0" ] && onSuccessFinishEmojiBar
	onSuccessFinishProgressBar
}

handleExitFailed(){
	[ "$BAR_TYPE" = "0" ] && onFailedEmojiBar
	onFailedProgressBar
}

handleSigInt(){
	STATUS_PARENT='canceled'
	handleExitFailed
}

handleSigUsr1(){
	handleSigInt
	doExit
}
initProgressBar(){
	[ "$BAR_TYPE" = "0" ] && startEmojiProgressBar "$1" "$2"
	startSimpleProgressBar "$1" "$2"
}

trap handleSigTerm SIGTERM
trap handleExitFailed SIGHUP
trap handleSigInt SIGINT
trap handleSigUsr1 SIGUSR1

if [  $# =  4 ] && [ "$1" != "0" ]; then 
	initProgressBar "$1" "$2"
fi