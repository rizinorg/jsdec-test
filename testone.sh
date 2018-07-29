#!/bin/bash

TESTFOLDER=./tests
TMPFOLDER=./tmp/
R2DECFOLDER=$2
TESTNAME=$1
RMCMD="rmdir"
ERROR=false
DIFF="diff --color=always -u"

if [ -z "$R2DECFOLDER" ]; then
	R2DECFOLDER=~/.local/share/radare2/r2pm/git/r2dec-js
fi

R2DECBINFLD=$R2DECFOLDER/p

if [ ! -f "$R2DECBINFLD/r2dec-test" ]; then
	echo "building binary src"
    make --no-print-directory testbin -C "$R2DECBINFLD"
fi
ELEM=$(find "$TESTFOLDER" -name "$TESTNAME*.json" | sed "s/.json//g")
echo "$ELEM"
mkdir "$TMPFOLDER"

NAME=$(basename "$ELEM")
if [ -z "$NAME" ]; then
	echo "Empty name.."
	exit 1;
fi

OUTPUTFILE="$TMPFOLDER/$NAME.output.txt"
$R2DECBINFLD/r2dec-test "$R2DECFOLDER" "$ELEM.json" > "$OUTPUTFILE" || break
DIFFOUTPUT=$(diff -u "$ELEM.output.txt" "$OUTPUTFILE")

if [ ! -z "$DIFFOUTPUT" ]; then
	echo "[XX]: $NAME"
	if [ -f "$ELEM.output.txt" ]; then
		$DIFF "$ELEM.output.txt" "$OUTPUTFILE"
	else
		cat "$OUTPUTFILE"
	fi
	ERROR=true
else
	echo "[OK]: $NAME"
	rm "$OUTPUTFILE"
fi

if [ ! "$TMPFOLDER" == "/tmp" ] ; then
	$RMCMD "$TMPFOLDER"
fi


if $ERROR; then
	exit 1;
fi

exit 0;
