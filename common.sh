build_testsuite() {
	local JSDEC="$1"
	local BUILD="$JSDEC/build-standalone"
	local BIN="$BUILD/jsdec-standalone"
	local WORKDIR="$PWD"

	if [ ! -d "$JSDEC" ]; then
		echo "Error: '$JSDEC' is not a valid directory"
		exit 1
	fi

	if [ ! -d "$BUILD" ]; then
		echo "Info: creating meson build '$BUILD'"
		cd "$JSDEC"
		meson -Dstandalone=true "build-standalone" || exit 1
		ninja -C "build-standalone" || exit 1
		cd "$WORKDIR"
	elif [ ! -f "$BIN" ]; then
		echo "Info: rebuilding '$BIN'"
		cd "$JSDEC"
		ninja -C "build-standalone" || exit 1
		cd "$WORKDIR"
	fi
}

run_test() {
	local JSDEC="$1"
	local JSON="$2"
	local BIN="$JSDEC/build-standalone/jsdec-standalone"
	$BIN "$JSON"
	return $?
}

