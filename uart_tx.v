module uart_tx
(
    input CLK,

    output reg TXD = 1'b1,
	input START,
	input [7:0]DATA,
    output BUSY
);

assign BUSY = (bit_num != 4'b1111);

reg [12:0]cnt = 13'b0;
reg uart_clk = 1'b0;
always @(posedge CLK or posedge START) begin
	if (START) begin
        cnt <= 13'b0;
        uart_clk <= 1'b1;
	end
	else begin
    	if (cnt == 1250) begin // 48_000_000 = 1250 * 38400
    	    cnt <= 13'b0;
    	    uart_clk <= 1'b1;
    	end
    	else begin
    	    cnt <= cnt + 13'b1;
    	    uart_clk <= 1'b0;
    	end
	end
end

reg [3:0]bit_num = 4'b1111;
always @(posedge uart_clk) begin
	if (START) begin
		bit_num <= 4'b0000;
		TXD <= 1'b0;
	end

	case (bit_num)
	4'b0000: begin bit_num <= 4'b0001; TXD <= DATA[0]; end
	4'b0001: begin bit_num <= 4'b0010; TXD <= DATA[1]; end 
	4'b0010: begin bit_num <= 4'b0011; TXD <= DATA[2]; end
	4'b0011: begin bit_num <= 4'b0100; TXD <= DATA[3]; end
	4'b0100: begin bit_num <= 4'b0101; TXD <= DATA[4]; end
	4'b0101: begin bit_num <= 4'b0110; TXD <= DATA[5]; end
	4'b0110: begin bit_num <= 4'b0111; TXD <= DATA[6]; end
	4'b0111: begin bit_num <= 4'b1000; TXD <= DATA[7]; end
	4'b1000: begin bit_num <= 4'b1001; TXD <= 1'b1; end
	4'b1001: begin bit_num <= 4'b1111; end
	endcase
end

endmodule
