#!/bin/bash

TESTFOLDER=./tests
TMPFOLDER=./tmp
JSDECFOLDER=$2
TESTNAME=$1
RMCMD="rmdir"
ERROR=false
DIFF="diff --color=always -u"

if [ -z "$JSDECFOLDER" ]; then
	echo "$0 <file.json> <jsdec folder>"
	exit 1
fi

JSDECBINFLD=$JSDECFOLDER/p

if [ ! -f "$JSDECBINFLD/jsdec-test" ]; then
	echo "building binary src"
    make --no-print-directory testbin -C "$JSDECBINFLD"
fi

if [ -z "$TESTNAME" ]; then
	echo "Empty name.."
	exit 1;
fi

$JSDECBINFLD/jsdec-test "$JSDECFOLDER" "$TESTNAME"

