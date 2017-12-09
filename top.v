module top
(
    input CLK,

    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,

	input TXD,
	output RXD,

	input KEY1
);

wire [255:0]key = 256'h1F1E1D1C1B1A191817161514131211100F0E0D0C0B0A09080706050403020100;

wire [63:0]enc_in = enc_buffer;
wire [63:0]enc_out;
fnet fnet (
    .IN(enc_in),
    .KEY(key),
    .OUT(enc_out)
);

wire [63:0]dec_in = dec_buffer;
wire [63:0]dec_out;
ifnet ifnet (
    .IN(dec_in),
    .KEY(key),
    .OUT(dec_out)
);

reg mode = 1'b1; //1 for encrypt, 0 for decrypt
reg mode_set = 1'b0;

always @(posedge KEY1) begin
	mode <= ~mode;
end

wire [63:0]out = mode ? enc_out : dec_out;

//wire [63:0]longword = mode;
wire [15:0]word = mode;
/*reg [25:0]cnt = 0;
always @(posedge CLK) begin
	cnt <= cnt + 1;
	case (cnt[25:24])
	2'b00: word <= longword[63:48];
	2'b01: word <= longword[47:32];
	2'b10: word <= longword[31:16];
	2'b11: word <= longword[15:0];
	endcase
end*/

wire [7:0]uart_rx_data;
wire uart_ready;
async_receiver ar(
	.clk(CLK),
	.RxD(TXD),
	.RxD_data_ready(uart_ready),
	.RxD_data(uart_rx_data)
);

wire [63:0]in_data = { in_buffer[63:8], uart_rx_data };

reg [63:0]in_buffer = 64'h0;
reg [2:0]uart_read_state = 3'b000;
always @(posedge CLK) begin
    if (uart_ready) begin
        case (uart_read_state)
        3'b000: begin
            in_buffer[63:56] <= uart_rx_data; 
            uart_read_state <= 3'b001;
        end
        3'b001: begin
            in_buffer[55:48] <= uart_rx_data; 
            uart_read_state <= 3'b010;
        end
        3'b010: begin
            in_buffer[47:40] <= uart_rx_data;
            uart_read_state <= 3'b011;
        end
        3'b011: begin
            in_buffer[39:32] <= uart_rx_data; 
            uart_read_state <= 3'b100;
        end
        3'b100: begin
            in_buffer[31:24] <= uart_rx_data; 
            uart_read_state <= 3'b101;
        end
        3'b101: begin
            in_buffer[23:16] <= uart_rx_data; 
            uart_read_state <= 3'b110;
        end
        3'b110: begin
            in_buffer[15:8] <= uart_rx_data;
            uart_read_state <= 3'b111;
        end
        3'b111: begin
            if (&in_data & ~mode_set) begin
                mode_set <= 1'b1;
            end
            
			if (mode)
                enc_buffer <= in_data;
            else
                dec_buffer <= in_data;

            in_buffer[7:0] <= uart_rx_data;
            uart_read_state <= 3'b000;
            buffer_ready <= 1'b1;
        end
        endcase 
    end
    else begin
        buffer_ready <= 1'b0;
    end
end

reg [63:0]enc_buffer = 64'h0;
reg [63:0]dec_buffer = 64'h0;
reg buffer_ready = 1'b0;

reg [7:0]uart_tx_data;
reg uart_tx_start = 0;
wire uart_tx_busy;
uart_tx ut(
	.CLK(CLK),
	.TXD(RXD),
	.BUSY(uart_tx_busy),
	.START(uart_tx_start),
	.DATA(uart_tx_data)
);

reg [2:0]delay_cnt = 3'b000;
wire delay_start = buffer_ready;
wire delay_sig = (delay_cnt == 3'b111);
always @(posedge CLK) begin
    if (delay_start)
        delay_cnt <= 3'b001;
    else if (|delay_cnt)
        delay_cnt <= delay_cnt + 3'b001;
end

reg [63:0]out_buffer = 64'h3031323334353637;
reg [3:0]uart_write_state = 4'b1000;
always @(posedge CLK) begin
    if (delay_sig & (uart_write_state == 4'b1000)) begin
        out_buffer <= out;
        uart_write_state <= 4'b0;
    end
	
    if (!uart_tx_busy) begin
    	case (uart_write_state)
    	4'b0000: begin
    	    uart_tx_data <= out_buffer[63:56]; 
    	    uart_write_state <= 4'b0001;
    	end
    	4'b0001: begin
    	    uart_tx_data <= out_buffer[55:48]; 
    	    uart_write_state <= 4'b0010;
    	end
    	4'b0010: begin
    	    uart_tx_data <= out_buffer[47:40]; 
    	    uart_write_state <= 4'b0011;
    	end
    	4'b0011: begin
    	    uart_tx_data <= out_buffer[39:32];  
    	    uart_write_state <= 4'b0100;
    	end
    	4'b0100: begin
    	    uart_tx_data <= out_buffer[31:24];  
    	    uart_write_state <= 4'b0101;
    	end
    	4'b0101: begin
    	    uart_tx_data <= out_buffer[23:16];  
    	    uart_write_state <= 4'b0110;
    	end
    	4'b0110: begin
    	    uart_tx_data <= out_buffer[15:8];
    	    uart_write_state <= 4'b0111;
    	end
    	4'b0111: begin
    	    uart_tx_data <= out_buffer[7:0];
    	    uart_write_state <= 4'b1000;
    	end
    	endcase

        if (uart_write_state != 4'b1000)
		    uart_tx_start <= 1'b1;
	end
	else
		uart_tx_start <= 1'b0;
end

ssd ssd_inst(
    .CLK(CLK),
    .SEN1(DS_EN1), .SEN2(DS_EN2), .SEN3(DS_EN3), .SEN4(DS_EN4),
    .SSA(DS_A), .SSB(DS_B), .SSC(DS_C), .SSD(DS_D), .SSE(DS_E), .SSF(DS_F), .SSG(DS_G),
    .WORD(word)
);

endmodule
