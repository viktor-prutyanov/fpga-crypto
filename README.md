# fpga-crypto
GOST 28147-89 (Magma) on FPGA
#### Test with Icarus Verilog:
    make test

#### Build with Altera Quartus (binaries must be in your $PATH):
    make fpga-crypto.sof

#### Try:
    stty -F /dev/ttyUSB0 raw
    stty -F /dev/ttyUSB0 9600
    dd if=/dev/ttyUSB0 of=uart_tx.v.enc iflag=fullblock bs=1 count=1240
From another terminal:
    
    dd if=uart_tx.v of=/dev/ttyUSB0
