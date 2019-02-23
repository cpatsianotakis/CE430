/*	uart_receiver module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Receives a message via the RxD input and promotes it to its controller
*/

module uart_receiver(
	reset, 
	clk, 
	Rx_DATA, 
	baud_select, 
	Rx_EN, 
	RxD,
	Rx_FERROR, 
	Rx_PERROR, 
	Rx_VALID
);


input reset, clk;
input [2:0] baud_select;
input Rx_EN;
input RxD;

output reg [7:0] Rx_DATA;
output reg Rx_FERROR; // Framing Error //
output reg Rx_PERROR; // Parity Error //
output reg Rx_VALID; // DATA is Valid //

wire Rx_sample_ENABLE;

reg parity_bit;

reg [3:0] state_counter;
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

always @( posedge Rx_sample_ENABLE or posedge reset) 
begin

	if ( reset ) 
	begin
		
		Rx_PERROR = 0;
		Rx_FERROR = 0;
		Rx_VALID = 0;
		state = STATE_IDLE;

	end

	else 
	begin

	if ( Rx_EN )
	begin

		case (state)

			STATE_IDLE:
			begin
				
				state_counter = 0;
				parity_bit = 0;

				if( RxD == 0 )
				begin
					state = STATE_START_BIT;
				end
					

			end

			STATE_START_BIT:
			begin

				if ( state_counter == 7)
				begin
					
					state_counter = 0;

					if ( RxD == 0 )
					begin
						Rx_PERROR = 0;
						Rx_FERROR = 0;
						Rx_VALID = 0;
						state = STATE_D0;
					end
					else 
					begin
						state = STATE_IDLE;
					end
				end

				else 
				begin
					state_counter = state_counter + 1;
				end
				
			end

			STATE_D0:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[0] = RxD;
					parity_bit = parity_bit ^ RxD;

					state = STATE_D1;

				end
					
				state_counter = state_counter + 1;
			end

			STATE_D1:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[1] = RxD;
					parity_bit = parity_bit ^ RxD;

					state = STATE_D2;

				end					
				state_counter = state_counter + 1;
			end

			STATE_D2:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[2] = RxD;
					parity_bit = parity_bit ^ RxD;

					state_counter = 0;
					state = STATE_D3;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

			STATE_D3:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[3] = RxD;
					parity_bit = parity_bit ^ RxD;

					state_counter = 0;
					state = STATE_D4;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

			STATE_D4:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[4] = RxD;
					parity_bit = parity_bit ^ RxD;

					state_counter = 0;
					state = STATE_D5;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

			STATE_D5:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[5] = RxD;
					parity_bit = parity_bit ^ RxD;

					state_counter = 0;
					state = STATE_D6;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

			STATE_D6:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[6] = RxD;
					parity_bit = parity_bit ^ RxD;

					state_counter = 0;
					state = STATE_D7;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

			STATE_D7:
			begin
				
				if ( state_counter == 15 )
				begin
					
					Rx_DATA[7] = RxD;
					parity_bit = parity_bit ^ RxD;

					state_counter = 0;
					state = STATE_PARITY_BIT;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

			STATE_PARITY_BIT:
			begin
				
				if ( state_counter == 15 )
				begin
					
					if ( RxD != parity_bit )
					begin
						Rx_PERROR = 1;
					end

					state_counter = 0;
					state = STATE_STOP_BIT;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

			STATE_STOP_BIT:
			begin
				
				if ( state_counter == 15 )
				begin
					
					if ( RxD != 1 )
					begin
						Rx_FERROR = 1;
					end
					
					else 
					begin

						if ( Rx_PERROR == 0 )
						begin
							Rx_VALID = 1;
						end
							
					end

					state_counter = 0;
					state = STATE_IDLE;

				end
				else 
				begin
					
					state_counter = state_counter + 1;
				end
			end

		endcase
	end
		
	end
end

baud_controller baud_controller_rx_instance(
	.reset ( reset), 
	.clk ( clk), 
	.baud_select ( baud_select), 
	.sample_ENABLE ( Rx_sample_ENABLE)
);

endmodule