#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
JSDEC="$2"
TESTNAME="$1"

if [ -z "$JSDEC" ]; then
	echo "$0 <file.json> <jsdec folder>"
	exit 1
fi

. "$SCRIPT_DIR/common.sh"

build_testsuite "$JSDEC"

if [ -z "$TESTNAME" ]; then
	echo "Empty name.."
	exit 1;
fi

run_test "$JSDEC" "$TESTNAME"

