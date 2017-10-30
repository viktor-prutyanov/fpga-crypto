module top;

reg clk;

initial 
    clk = 1'b0;

initial
    #10 clk = 1'b0;

always
    #10 clk = ~clk;

wire [63:0]fcell_in = 64'h01234567DEADBEEF; 
wire [31:0]fcell_k  = 32'h12345678;
wire [63:0]fcell_out;

fcell fcell (
    .IN(fcell_in),
    .KEY(fcell_k),
    .OUT(fcell_out)
);

initial
    #50 $finish;

initial begin
    $dumpfile("out.vcd");
    $dumpvars(0, top);
end

endmodule
