#!/bin/bash

TESTFOLDER=./tests
TMPFOLDER=./tmp
JSDECFOLDER=$1
TRAVIS=$2
RMCMD="rm -rf"
ERROR=false
DIFF="diff -u"

if [ -z "$TRAVIS" ]; then
	RMCMD="rmdir"
	DIFF="diff --color=always -u"
fi

if [ -z "$JSDECFOLDER" ]; then
	echo "$0 <jsdec folder> <ci>"
	exit 1
fi

JSDECBINFLD=$JSDECFOLDER/p

if [ ! -f "$JSDECBINFLD/jsdec-test" ]; then
	echo "building binary src"
    make --no-print-directory testbin -C "$JSDECBINFLD"
fi

TESTS=$(find "$TESTFOLDER" | grep ".json" | sed "s/.json//g")

mkdir "$TMPFOLDER"

for ELEM in $TESTS; do
	NAME=$(basename "$ELEM")
	OUTPUTFILE="$TMPFOLDER/$NAME.output.txt"
	$JSDECBINFLD/jsdec-test "$JSDECFOLDER" "$ELEM.json" > "$OUTPUTFILE" || break
	DIFFOUTPUT=$(diff -u "$ELEM.output.txt" "$OUTPUTFILE")

	if [ ! -z "$DIFFOUTPUT" ]; then
		echo "[XX]: $NAME"
		$DIFF "$ELEM.output.txt" "$OUTPUTFILE"
		ERROR=true
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

if [ -f "$JSDECBINFLD/jsdec-test" ]; then
	echo "cleaning binary folder"
    make --no-print-directory clean -C "$JSDECBINFLD"
fi

exit 0;
