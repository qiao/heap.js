TEST_TIMEOUT = 2000
TEST_REPORTER = spec

all: lib/heap.cjs lib/heap.mjs

lib/heap.cjs: src/heap.coffee src/suffix.cjs.coffee
	@cat src/heap.coffee src/suffix.cjs.coffee | node_modules/.bin/coffee -c --stdio > lib/heap.cjs

lib/heap.mjs: src/heap.coffee src/suffix.mjs.coffee
	@cat src/heap.coffee src/suffix.mjs.coffee | node_modules/.bin/coffee -c --stdio > lib/heap.mjs

test:
	@NODE_ENV=test \
		node_modules/.bin/mocha \
			--require should \
			--timeout $(TEST_TIMEOUT) \
			--reporter $(TEST_REPORTER) \
			--require coffeescript/register "test/**/*.{js,coffee}" \
			test/*.coffee


.PHONY: all test
