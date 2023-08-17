build_testsuite() {
	local JSDEC="$1"
	local BUILD="$JSDEC/build-standalone"
	local BIN="$BUILD/jsdec-standalone"

	if [ ! -d "$JSDEC" ]; then
		echo "Error: '$JSDEC' is not a valid directory"
		exit 1
	fi

	if [ ! -d "$BUILD" ]; then
		echo "Info: creating meson build directory '$BUILD'"
		meson -Dstandalone=true "$BUILD" || exit 1
	fi
	
	if [ ! -f "$BIN" ]; then
		echo "Info: building '$BIN'"
		ninja -C "$BUILD" || exit 1
	fi
}

run_test() {
	local JSDEC="$1"
	local JSON="$2"
	local BIN="$JSDEC/build-standalone/jsdec-standalone"
	$BIN "$JSON"
	return $?
}

