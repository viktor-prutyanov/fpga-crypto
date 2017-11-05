module fcell (
    input [63:0]IN,
    input [31:0]KEY,
    output [63:0]OUT    
);

wire [31:0]a = IN[63:32];
wire [31:0]b = IN[31:0];

wire [31:0]f_out;

f f (
    .X(a),
    .K(KEY),
    .Y(f_out)
);

assign OUT = { b ^ f_out, a };

endmodule
