test: test-cells test-sbox
	$(foreach t, $^, vvp $(t) | grep -v "WARNING";)

test-cells: test_cells.v fcell.v ifcell.v f.v sbox_array.v sbox.v
	iverilog $^ -o $@

test-sbox: test_sbox.v sbox_array.v sbox.v
	iverilog $^ -o $@

.PHONY: clean test

clean:
	rm -f test-cells
	rm -f test-sbox
