module ssd //Seven-segment display
(
    input CLK,
    
    input [15:0]WORD,
    output SEN1, SEN2, SEN3, SEN4,
    output SSA, SSB, SSC, SSD, SSE, SSF, SSG    
);

reg [15:0]cnt = 16'b0;
always @(posedge CLK) begin
    cnt <= cnt + 16'b1;
end

wire [3:0]sen; //segment enable
assign {SEN1, SEN2, SEN3, SEN4} = sen;
wire [3:0]hb; //half-byte part of word
always_comb begin
    case (cnt[15:14])
        2'b00: begin
            sen = 4'b1110;
            hb = WORD[3:0];
        end
        2'b01: begin
            sen = 4'b1101;
            hb = WORD[7:4];
        end
        2'b10: begin
            sen = 4'b1011;
            hb = WORD[11:8];
        end
        2'b11: begin
            sen = 4'b0111;
            hb = WORD[15:12];
        end
    endcase 
end

wire [6:0]ssc; //seven-segment code
assign {SSA, SSB, SSC, SSD, SSE, SSF, SSG} = ssc;
always_comb begin
    case (hb)
        4'h0: ssc = 7'b1111110;
        4'h1: ssc = 7'b0110000;
        4'h2: ssc = 7'b1101101;
        4'h3: ssc = 7'b1111001;
        4'h4: ssc = 7'b0110011;
        4'h5: ssc = 7'b1011011;
        4'h6: ssc = 7'b1011111;
        4'h7: ssc = 7'b1110000;
        4'h8: ssc = 7'b1111111;
        4'h9: ssc = 7'b1111011;
        4'ha: ssc = 7'b1110111;
        4'hb: ssc = 7'b0011111;
        4'hc: ssc = 7'b1001110;
        4'hd: ssc = 7'b0111101;
        4'he: ssc = 7'b1101111;
        4'hf: ssc = 7'b1000111;
    endcase
end

endmodule
