Simple Bash Progress Bar
----

A random progress bar to be used in tasks that do not have a specific time to finish.
To entertain the user while the task is performed.

Getting Started
---
1. Clone or get this repository
2. Set PROGRESS_BAR_PATH variable with absolute path of *bash-progress-bar.sh*
3. in your project import this  *progress-bar.sh*
4. call starProgressBar with message arg
5. Run your task redirecting output to /dev/null ¹
	1.	sample echo "something" &> /dev/null
6. call *stopAsSuccessProgressBar* or *stopProgressBarAsFail*

Sample
---

```bash
PROGRESS_BAR_PATH=somepath
source . ./progress-bar.sh

task(){
	for i in $(seq 0..100);
	do
		echo $i &> /dev/null
	done
}
startProgressBar "message"
if task; then
	stopAsSuccessProgressBar
else
	stopAsFailProgressBar
fi
```

How this tool works
---

*starProgressBar* is a function that takes a message as an argument and starts the animation


*stopAsSuccessProgressBar* is a function that ends the progressbar successfully

*stopProgressBarAsFail* is a function that ends the progressbar with a failure message

*stopProgressAsCanceled* is a function (optional) that ends the progressbar with a canceled status

When startProgressBar is called, the bash-progress-bar.sh script is initialized in the background.
Next instruction is executed while the animation is running

The user must use the function *stopAsSuccessProgressBar* (for success) or stopProgressBarAsFail* (failure)

Note
---

1. It is important to redirect the output of your task to */dev/null* to only see the progressbar animation

Important Note
---

*bash-progress-bar.sh* is a child process of its main task,
If you use **SIGTERM** or **SIGINT** and are using *bash-progress-bar* it is important to call one of the stopProgressBar functions when processing these signals.


## Sample: ##

```bash
handleSignInt(){
	# ... your code
	stopAsFailProgressBar
}

handleSigTerm(){
	# ... your code
	stopAsFailProgressBar	
}

# install trap to SIGINT (keyboard interruption)
trap handleSigInt SIGINT 
```
