add_js := add.js
add_wit := add.wit
add_wasm := add.wasm
dist := dist
dist_add := $(dist)/add.js
# https://github.com/bytecodealliance/component-docs/tree/main/component-model/examples/example-host
example_host_path := ~/github/component-docs/component-model/examples/example-host

$(add_wasm): Makefile $(add_js) $(add_wit)
	npx jco componentize $(add_js) \
		--wit $(add_wit) \
		--world-name example \
		--out $(add_wasm) \
		--disable all

run: $(add_wasm)
	pushd $(example_host_path) && \
	cargo run --release -- 22 20 $(CURDIR)/$(add_wasm)


# https://component-model.bytecodealliance.org/language-support/javascript.html#running-a-component-from-javascript-applications-including-the-browser
$(dist_add): $(add_wasm)
	npx jco transpile $(add_wasm) -o $(dist)

run_js: $(dist_add)
	node run.js

clean:
	rm -rf $(add_wasm) $(dist)