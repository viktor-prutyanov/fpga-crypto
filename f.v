module f (
    input [31:0]X,
    input [31:0]K,
    output [31:0]Y
);

wire [31:0]f1 = X + K;
wire [31:0]f2;

sbox_array sba (
    .IN(f1),
    .OUT(f2)
);

assign Y = { f2[20:0], f2[31:21] };

endmodule
