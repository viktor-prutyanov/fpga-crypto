module sbox_array(
    input [31:0]IN,
    output [31:0]OUT
);

sbox #(.init_file("sbox7.txt")) sbox7 (.IN(IN[3:0]  ), .OUT(OUT[3:0]  ));
sbox #(.init_file("sbox6.txt")) sbox6 (.IN(IN[7:4]  ), .OUT(OUT[7:4]  ));
sbox #(.init_file("sbox5.txt")) sbox5 (.IN(IN[11:8] ), .OUT(OUT[11:8] ));
sbox #(.init_file("sbox4.txt")) sbox4 (.IN(IN[15:12]), .OUT(OUT[15:12]));
sbox #(.init_file("sbox3.txt")) sbox3 (.IN(IN[19:16]), .OUT(OUT[19:16]));
sbox #(.init_file("sbox2.txt")) sbox2 (.IN(IN[23:20]), .OUT(OUT[23:20]));
sbox #(.init_file("sbox1.txt")) sbox1 (.IN(IN[27:24]), .OUT(OUT[27:24]));
sbox #(.init_file("sbox0.txt")) sbox0 (.IN(IN[31:28]), .OUT(OUT[31:28]));

endmodule
