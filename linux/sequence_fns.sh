#!/bin/bash

### Functions pertaining to keeping track of progress during planned restarts and in the event of a crash. ###

### in_stage $VAR

FAHT_CFG_DIR="/home/$(whoami)/.fahtdiag"
FAHT_CFG_FILE="$FAHT_CFG_DIR/config"
FAHT_STAGE_FILE="$FAHT_CFG_DIR/current_stage"
declare -A FAHT_STAGE_ARRAY=()

config_file_build () {
	if [ ! -d "$FAHT_CFG_DIR" ]; then
		mkdir "$FAHT_CFG_DIR"
	fi

	if [ ! -f "$FAHT_CFG_FILE" ]; then
		touch "$FAHT_CFG_FILE"
	fi

	echo "FAHT Configuration file v. 1.0">"$FAHT_CFG_FILE"

	echo "FAHT_USB_DIR=/mnt/usbdata/faht-tests/">"$FAHT_CFG_FILE"
	echo "FAHT_STAGE_FILE=$FAHT_CFG_DIR/current_stage"
}

faht_config_check () {
	echo "Do something... Someday..."
}

set_stage () {
	FAHT_CURR_STAGE="$1"
	sed -i "s/^FAHT_CURR_STAGE=\(.*\)/FAHT_CURR_STAGE=$1/g" "$FAHT_STAGE_FILE"
}

init_stagefile () {
	echo "FAHT_CURR_STAGE=">"${FAHT_STAGE_FILE}"

	echo "">>$FAHT_STAGE_FILE
	echo "Client: $FAHT_FULLNAME">>$FAHT_STAGE_FILE
	echo "Date: $FAHT_TEST_DATE">>$FAHT_STAGE_FILE
	echo "Computer: $FAHT_COMP_DESC">>$FAHT_STAGE_FILE
	echo "Working Directory: $FAHT_WORKINGDIR">>$FAHT_STAGE_FILE
	echo "">>$FAHT_STAGE_FILE
}

check_stagefile () {
	if [ -f "$FAHT_STAGE_FILE" ]; then
		# Source working dir
		echo Continuing test
		FAHT_WORKINGDIR="$(grep "Working Directory" "$FAHT_STAGE_FILE"|sed -r 's/.*Working Directory: (.*)/\1/')"
		source "${FAHT_WORKINGDIR}"/vars_noarray.txt
		echo Current stage: $FAHT_CURR_STAGE
		$DIAG
	fi
}

check_stage () {
	echo "Do something... Someday..."
}  

## run_stage STAGE_TO_RUN NEXT_STAGE_TO_RUN
run_stage () {

	declare -n CURR_STAGE=FAHT_STAGE_ARRAY[$1]

	echo "FAHT_STAGE_ARRAY[$1]"
	$DIAG
	
	if [ "${FAHT_STAGE_ARRAY[$1]}" != "complete" ] && [ "${FAHT_NEXT_STAGE}" == "$1" ]; then
		echo

		x=$1

		set_stage $1
		CURR_STAGE=running
		echo Running "${1}"
		: echo "Running stage: ${1}"
		
		$1

		CURR_STAGE=complete
		FAHT_NEXT_STAGE=$2
		#echo "Stage $1: ${FAHT_STAGE_ARRAY[${1}]}"
		save_vars
		$DIAG
	fi
	
}