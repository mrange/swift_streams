all: run_tests

clean:
	git clean -fdX

build/test_suite: test/src/main.swift src/stream.swift
	swiftc -O -g test/src/main.swift src/stream.swift -o build/test_suite

build/test_perf_suite: test_perf/src/main.swift src/stream.swift
	swiftc -O -g test_perf/src/main.swift src/stream.swift -o build/test_perf_suite

tests: build/test_suite build/test_perf_suite

run_tests: tests
	./build/test_suite
	time ./build/test_perf_suite
