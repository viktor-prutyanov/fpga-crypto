module sbox #(parameter init_file = "") (
    input [3:0]IN,
    output [3:0]OUT
);

reg [3:0]box[15:0];

initial $readmemh(init_file, box);

assign OUT = box[IN];

endmodule
