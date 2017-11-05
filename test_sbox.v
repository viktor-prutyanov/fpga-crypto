module top;

reg clk;

initial 
    clk = 1'b0;

always
    #1 clk = ~clk;

reg [3:0]sbox_in = 4'h0; 
wire [31:0]sbox_outs;

sbox_array sba (
    .IN({8{sbox_in}}),
    .OUT(sbox_outs)
);

initial
    $display("NR   01234567");

always @(posedge clk) begin
    sbox_in <= sbox_in + 4'h1;
    $display("%h -> %h", sbox_in, sbox_outs);
end

initial
    #32 $finish;

endmodule
