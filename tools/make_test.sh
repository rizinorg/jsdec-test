#!/bin/bash

FILENAME="$1"
TESTFOLDER="$2"
TMPFOLDER="$3"

if [ $# -eq 3 ]; then
	NAME=$(basename $FILENAME)
	echo "    building: $TESTFOLDER/$NAME.json"
	ARCH=$(rizin -Q -c "e asm.arch" "$FILENAME")
	FILEJSON="$TESTFOLDER/$NAME.$ARCH.json"
	FILEOUT="$TESTFOLDER/$NAME.$ARCH.output.txt"
	rizin -A -Q -c "pddi @ main" "$FILENAME" > "$FILEJSON" 2> "$TMPFOLDER/stderr.txt"
	if [ ! -f "$FILEOUT" ]; then
		mv "$TMPFOLDER/output.txt" "$FILEOUT"
	fi
else
	echo "make_test.sh <file> <test folder> <tmp folder>"
fi

