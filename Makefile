all:
	@echo "run manually './testall.sh /path/to/jsdec'"
	@echo "to build the tests again, use 'make build && make buildtests'"

build:
	@echo "bins"
	@make --no-print-directory -C bins

buildtests:
	@bash ./builder.sh bins/binaries.lst

clean:
	@make clean --no-print-directory -C bins
