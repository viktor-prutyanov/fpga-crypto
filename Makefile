test: test-cells test-sbox test-fnet
	@vvp test-cells | grep -v "WARNING"
	@echo ""
	@vvp test-sbox | grep -v "WARNING"
	@echo ""
	@vvp test-fnet | grep -v "WARNING"
	@echo ""

test-cells: test_cells.v fcell.v ifcell.v f.v sbox_array.v sbox.v
	iverilog $^ -o $@

test-sbox: test_sbox.v sbox_array.v sbox.v
	iverilog $^ -o $@

test-fnet: test_fnet.v fnet.v fcell.v f.v sbox_array.v sbox.v
	iverilog $^ -o $@

.PHONY: clean test tags

tags:
	ctags -R

fpga-crypto.sof: top.v async.v
	quartus_map --read_settings_files=on --write_settings_files=off fpga-crypto -c fpga-crypto
	quartus_fit --read_settings_files=off --write_settings_files=off fpga-crypto -c fpga-crypto
	quartus_asm --read_settings_files=off --write_settings_files=off fpga-crypto -c fpga-crypto
	cp output_files/fpga-crypto.sof fpga-crypto.sof

clean:
	rm -f test-cells
	rm -f test-sbox
	rm -f test-fnet
