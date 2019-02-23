/*	uart_transmitter module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Drives uart_transmitter to test it
*/

module uart_transmitter_controller(
	reset,
	clk,
	baud_select,
	TxD
);

input reset;
input clk;
input [2:0] baud_select;
output TxD;

reg [7:0] Tx_DATA;
reg Tx_EN;
reg Tx_WR;

wire Tx_BUSY;

parameter STATE_TRANS_BEFORE = 2'b00;
parameter STATE_TRANS_START  = 2'b01;
parameter STATE_TRANS_BUSY   = 2'b10;
parameter STATE_TRANS_AFTER  = 2'b11;

reg [0:7] message [15:0];
reg [3:0] counter;

reg [1:0] trans_state;
reg [1:0] trans_next_state;

reg delayer_enable;
wire delayer_time_elapsed;

always @(trans_state or delayer_time_elapsed or Tx_BUSY or delayer_time_elapsed or reset)
begin
	
	if ( reset )
	begin
		Tx_WR = 0;
		counter = 0;
		delayer_enable = 0;
	end


	Tx_DATA = message [ counter ];

	case ( trans_state )

		STATE_TRANS_BEFORE:
		begin
			Tx_WR = 1;
			trans_next_state = STATE_TRANS_START;
		end

		STATE_TRANS_START:
		begin
			Tx_WR = 0;
			if( Tx_BUSY == 1)
			begin
				trans_next_state = STATE_TRANS_BUSY;
			end
		end

		STATE_TRANS_BUSY:
		begin
			if ( Tx_BUSY == 0 )
			begin
				delayer_enable = 1;
				trans_next_state = STATE_TRANS_AFTER;
			end
		end

		STATE_TRANS_AFTER:
		begin
			delayer_enable = 0;
			if ( delayer_time_elapsed == 1)
			begin
				trans_next_state = STATE_TRANS_BEFORE;
				if ( counter == 12 )
					counter = 0;
				else
					counter = counter + 1;
			end
		end

		endcase

end

always @(posedge clk or posedge reset) 
begin
	if ( reset )
	begin
		message[0]  = 8'b1101_1100; //HE
		message[1]  = 8'b1110_1110; //LL
		message[2]  = 8'b0000_1111; //O_
		message[3]  = 8'b1111_1111; //__
		message[4]  = 8'b1010_1010; //AA
		message[5]  = 8'b0101_0101; //55
		message[6]  = 8'b1100_1100; //FF
		message[7]  = 8'b1000_1001; //89
		message[8]  = 8'b1111_1111; //__
		message[9]  = 8'b1111_0000; //_O
		message[10] = 8'b1011_0001; //FI
		message[11] = 8'b0100_1111; //4_
		message[12] = 8'b1111_1111; //__
		message[13] = 8'b1111_1111; //__
		message[14] = 8'b1111_1111; //__
		message[15] = 8'b1111_1111; //__

		trans_state = STATE_TRANS_BEFORE;

		Tx_EN = 1;
		
	end
	else 
	begin
		trans_state = trans_next_state;
	end
end

uart_transmitter uart_transmitter_INSTANCE (
	.reset ( reset ), 
	.clk (clk ), 
	.Tx_DATA ( Tx_DATA ), 
	.baud_select ( baud_select ), 
	.Tx_WR ( Tx_WR ), 
	.Tx_EN ( Tx_EN ), 
	.TxD ( TxD ), 
	.Tx_BUSY (Tx_BUSY )
);

delayer delayer_INSTANCE(
	.reset ( reset ),
	.clk ( clk ),
	.delayer_enable ( delayer_enable ),
	.time_elapsed ( delayer_time_elapsed )
);

endmodule