module fnet (
    input [63:0]IN,
    input [255:0]KEY,
    output [63:0]OUT
);

wire [31:0]k[31:0];

genvar i;
generate
    //To generate a subkey, the original 256-bit key is divided into eight 
    //32-bit blocks: K1...K8
    for (i = 0; i < 8; i = i + 1) begin : key_generation_0_7
        assign k[i] = KEY[32*i+31:32*i];
    end
    //The keys K9...K24 are a cyclic repetition of the keys K1...K8
    for (i = 0; i < 8; i = i + 1) begin : key_generation_8_23
        assign k[i+8] = k[i];
        assign k[i+16] = k[i];
    end
    //The keys K25...K32 are the keys K8...K1
    for (i = 0; i < 8; i = i + 1) begin : key_generation_24_31
        assign k[31-i] = k[i];
    end
endgenerate

wire [63:0]in[31:0];
wire [63:0]out[31:0];

assign in[0] = IN;

genvar j;
generate
    for (j = 0; j < 32; j = j + 1) begin : fcell_generation
        fcell fcell_inst (
            .IN(in[j]),
            .KEY(k[j]),
            .OUT(out[j])
        );
    end

    for (j = 0; j < 31; j = j + 1) begin : fcell_conn_generation
        assign in[j+1] = out[j];
    end
endgenerate

assign OUT = out[31];

endmodule
