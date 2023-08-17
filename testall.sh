#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TESTFOLDER=./tests
TMPFOLDER=./tmp
JSDEC=$1
TRAVIS=$2
RMCMD="rm -rf"
ERROR=false
DIFF="diff -u"

if [ -z "$TRAVIS" ]; then
	RMCMD="rmdir"
	DIFF="diff --color=always -u"
fi

if [ -z "$JSDEC" ]; then
	echo "$0 <jsdec folder> <ci>"
	exit 1
fi

. "$SCRIPT_DIR/common.sh"

build_testsuite "$JSDEC"

TESTS=$(find "$TESTFOLDER" -name "*.json" | sed "s/.json//g")

mkdir "$TMPFOLDER"

for ELEM in $TESTS; do
	NAME=$(basename "$ELEM")
	OUTPUTFILE="$TMPFOLDER/$NAME.output.txt"
	run_test "$JSDEC" "$ELEM.json" > "$OUTPUTFILE" || break
	DIFFOUTPUT=$(diff -u "$ELEM.output.txt" "$OUTPUTFILE")

	if [ ! -z "$DIFFOUTPUT" ]; then
		echo "[XX]: $NAME"
		$DIFF "$ELEM.output.txt" "$OUTPUTFILE"
		ERROR=true
		break
	else
		echo "[OK]: $NAME"
		rm "$OUTPUTFILE"
	fi

done

if [ ! "$TMPFOLDER" == "/tmp" ] ; then
	$RMCMD "$TMPFOLDER"
fi

if $ERROR; then
	exit 1;
fi

exit 0;
