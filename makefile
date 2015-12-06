all: run_tests

clean:
	git clean -fdX

build/test_suite: test/src/main.swift src/stream.swift
	swiftc -O -g test/src/main.swift src/stream.swift -o build/test_suite

tests: build/test_suite

run_tests: tests
	./build/test_suite
