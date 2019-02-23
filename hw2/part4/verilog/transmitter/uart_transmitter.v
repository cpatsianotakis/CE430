/*	uart_transmitter module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Gets the message from controller and sends it via TxD channel
*	after it adds start, stop and parity bit
*/

module uart_transmitter(
	reset, 
	clk, 
	Tx_DATA, 
	baud_select, 
	Tx_WR, 
	Tx_EN, 
	TxD, 
	Tx_BUSY
);


	input reset, clk;
	input [7:0] Tx_DATA;
	input [2:0] baud_select;
	input Tx_EN;
	input Tx_WR;

	output reg TxD;
	output reg Tx_BUSY;

	wire sample_Tx_WR;

	wire sample_send;

	wire sos_wire;

	reg Tx_PARITY_BIT;

	reg [3:0] state;

	parameter STATE_IDLE       = 4'b0000;
	parameter STATE_START_BIT  = 4'b0001;
	parameter STATE_D0         = 4'b0010;
	parameter STATE_D1         = 4'b0011;
	parameter STATE_D2         = 4'b0100;
	parameter STATE_D3         = 4'b0101;
	parameter STATE_D4         = 4'b0110;
	parameter STATE_D5         = 4'b0111;
	parameter STATE_D6         = 4'b1000;
	parameter STATE_D7         = 4'b1001;
	parameter STATE_PARITY_BIT = 4'b1010;
	parameter STATE_STOP_BIT   = 4'b1011;

	assign sos_wire = reset | ~Tx_EN;

	always @( posedge sample_send or posedge sos_wire) 
	begin

		if ( sos_wire == 1 )
		begin
			TxD = 1;
			Tx_BUSY = 0;
			state = STATE_IDLE;
		end

		else 
		begin
				
			case ( state )

				STATE_IDLE:
				begin
					if ( sample_Tx_WR == 1 )
					begin
						state = STATE_START_BIT;
						Tx_BUSY = 1;
						Tx_PARITY_BIT = ( (Tx_DATA[0]^Tx_DATA[1] ) ^ ( Tx_DATA[2]^Tx_DATA[3] ) ) ^ ( ( Tx_DATA[4]^Tx_DATA[5] ) ^ ( Tx_DATA[6]^Tx_DATA[7] ) );
					end
				end

				STATE_START_BIT:
				begin
					state = STATE_D0;
					TxD = 0;
				end

				STATE_D0:
				begin
					state = STATE_D1;
					TxD = Tx_DATA[0];
				end

				STATE_D1:
				begin
					state = STATE_D2;
					TxD = Tx_DATA[1];
				end

				STATE_D2:
				begin
					state = STATE_D3;
					TxD = Tx_DATA[2];
				end

				STATE_D3:
				begin
					state = STATE_D4;
					TxD = Tx_DATA[3];
				end

				STATE_D4:
				begin
					state = STATE_D5;
					TxD = Tx_DATA[4];
				end

				STATE_D5:
				begin
					state = STATE_D6;
					TxD = Tx_DATA[5];
				end

				STATE_D6:
				begin
					state = STATE_D7;
					TxD = Tx_DATA[6];
				end

				STATE_D7:
				begin
					state = STATE_PARITY_BIT;
					TxD = Tx_DATA[7];
				end

				STATE_PARITY_BIT:
				begin
					state = STATE_STOP_BIT;
					TxD = Tx_PARITY_BIT;
				end

				STATE_STOP_BIT:
				begin
					state = STATE_IDLE;
					TxD = 1;
					Tx_BUSY = 0;
				end

			endcase
			
		end
		
	end


	baud_controller baud_controller_tx_instance(
		.reset ( reset), 
		.clk ( clk), 
		.baud_select ( baud_select), 
		.sample_ENABLE ( Tx_sample_ENABLE)
	);

	TSE TSE_instance(
		.reset ( reset),
		.in_sample ( Tx_sample_ENABLE),
		.out_sample ( sample_send )
	);

	ETS Tx_WR_ETS_instance(
		.reset ( reset ),
		.clk ( clk ),
		.sampler ( sample_send ),
		.input_signal ( Tx_WR ),
		.output_signal ( sample_Tx_WR )
	);


endmodule

/* Transmitter Sample Enable */
module TSE(
	reset,
	in_sample,
	out_sample
);

	input reset, in_sample;
	output reg out_sample;

	reg [3:0] counter;

	always @( posedge in_sample or posedge reset) 
	begin
		if (reset) 
		begin
			out_sample = 0;
			counter = 0;
		end
		else 
		begin
			if ( counter == 15)
			begin 
				out_sample = 1;
			end
			
			else 
			begin
				out_sample = 0;
			end
			
			counter = counter + 1;
		end
	end

endmodule

/* Enable To Sampler*/
module ETS(
	reset,
	clk,
	sampler,
	input_signal,
	output_signal
);

	input reset;
	input clk;
	input sampler;
	input input_signal;
	output reg output_signal;

	reg signal_activated;
	reg prev_sampler;

	always @(posedge clk or posedge reset) 
	begin

		if ( reset == 1 ) 
		begin
			output_signal = 0;
			signal_activated = 0;
			prev_sampler = 1;
		end

		else 
		begin
			if( signal_activated == 0)
			begin
				signal_activated = input_signal;
				output_signal = input_signal;
			end

			if( sampler == 1 && prev_sampler == 0)
			begin
				signal_activated = 0;
			end

			prev_sampler = sampler;
		end
	end

endmodule