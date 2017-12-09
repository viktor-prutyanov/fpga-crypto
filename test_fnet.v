module top;

reg clk;

initial 
    clk = 1'b0;

always
    #1 clk = ~clk;

wire [63:0]in = 64'hDEADBEEFBAADF00D;
wire [255:0]key = 256'h1F1E1D1C1B1A191817161514131211100F0E0D0C0B0A09080706050403020100;
wire [63:0]out;
wire [63:0]i_out;

fnet fnet (
    .IN(in),
    .KEY(key),
    .OUT(out)
);

ifnet ifnet (
    .IN(out),
    .KEY(key),
    .OUT(i_out)
);

initial begin
	#1 $display("%h", out);
	$display("%h", i_out);
    
    if (in == i_out)
        $display("[PASSED]");
    else 
        $display("[FAILED]");
    
    $finish;
end

endmodule
