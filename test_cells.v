module top;

wire [63:0]x = 64'hDEADBEEFBAADF00D;
wire [31:0]k = 64'h01234567;
wire [63:0]y;

fcell fc (
    .IN(x),
    .KEY(k),
    .OUT(y)
);

initial begin
    $display("x  = %h", x);
    $display("k  = %h", k);
end

wire [63:0]x_dec;

ifcell ifc (
    .IN(y),
    .KEY(k),
    .OUT(x_dec)
);

initial begin
    #1 $display("y  = %h", y);
    $display("x' = %h", x_dec);
    if (x == x_dec) begin
        $display("[PASSED]");
    end
    $finish;
end

endmodule
