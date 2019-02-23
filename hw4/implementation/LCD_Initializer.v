module LCD_Initializer
(
	clk,
	reset,
	instruction,
	instruction_valid,
	busy
);

input clk;
input reset;

output reg [9:0] instruction;
output reg instruction_valid;
output reg busy;

parameter STATE_1 = 4'b0001;
parameter STATE_2 = 4'b0010;
parameter STATE_3 = 4'b0011;
parameter STATE_4 = 4'b0100;
parameter STATE_5 = 4'b0101;
parameter STATE_6 = 4'b0110;
parameter STATE_7 = 4'b0111;
parameter STATE_8 = 4'b1000;
parameter STATE_9 = 4'b1001;

parameter MAX_INSTRUCTION_CV = 11;

									// 1 us = 20 ns * 50  ( CLK PERIOD = 20 ns ) //
									// So 1 us is 50 clock periods //

parameter MAX_STATE_1_CV = 750000;  //  15 ms =  15_000 us => 15_000 * 50 = 750_000 clock periods //
parameter MAX_STATE_3_CV = 205000;	// 4.1 ms =   4_100 us =>  4_100 * 50 = 205_000 clock periods //
parameter MAX_STATE_5_CV = 5000;	// 100 us =     100 us =>    100 * 50 =   5_000 clock periods //
parameter MAX_STATE_7_CV = 2000;	//  40 us =      40 us =>     40 * 50 =   2_000 clock periods //
parameter MAX_STATE_9_CV = 2000;	//  40 us =      40 us =>     40 * 50 =   2_000 clock periods //

reg [3:0] state;
reg [3:0] next_state;

reg [19:0] counter;
reg [19:0] next_counter;


always @(posedge clk or posedge reset) begin
	if ( reset ) begin
		
		counter = 0;
		state = STATE_1;
		
	end
	else 
	begin
		
		counter = next_counter;
		state = next_state;
	end
end

always @( counter or state ) begin
	
	case ( state )

		STATE_1:
		begin

			busy = 1;

			instruction = 10'b00_0011_0000;
			instruction_valid = 0;

			if ( counter == MAX_STATE_1_CV )
			begin
				next_state = STATE_2;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_2:
		begin

			busy = 1;

			instruction = 10'b00_0011_0000;
			instruction_valid = 1;

			if ( counter == MAX_INSTRUCTION_CV )
			begin
				next_state = STATE_3;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_3:
		begin

			busy = 1;

			instruction = 10'b00_0011_0000;
			instruction_valid = 0;

			if ( counter == MAX_STATE_3_CV )
			begin
				next_state = STATE_4;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_4:
		begin

			busy = 1;

			instruction = 10'b00_0011_0000;
			instruction_valid = 1;

			if ( counter == MAX_INSTRUCTION_CV )
			begin
				next_state = STATE_5;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_5:
		begin

			busy = 1;

			instruction = 10'b00_0011_0000;
			instruction_valid = 0;

			if ( counter == MAX_STATE_5_CV )
			begin
				next_state = STATE_6;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_6:
		begin

			busy = 1;

			instruction = 10'b00_0011_0000;
			instruction_valid = 1;

			if ( counter == MAX_INSTRUCTION_CV )
			begin
				next_state = STATE_7;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_7:
		begin

			busy = 1;

			instruction = 10'b00_0010_0000;
			instruction_valid = 0;

			if ( counter == MAX_STATE_7_CV )
			begin
				next_state = STATE_8;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_8:
		begin

			busy = 1;

			instruction = 10'b00_0010_0000;
			instruction_valid = 1;

			if ( counter == MAX_INSTRUCTION_CV )
			begin
				next_state = STATE_9;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_counter = counter + 1;
			end
			
		end

		STATE_9:
		begin

			instruction = 10'b00_0010_0000;
			instruction_valid = 0;

			if ( counter == MAX_STATE_9_CV )
			begin
				next_counter = counter;
				next_state = state;
				busy = 0;
			end
			else
			begin
				next_counter = counter + 1;
				next_state = state;
				busy = 1;
			end
			
		end

		default:
		begin
			
			instruction = 10'b00_0000_0000;
			instruction_valid = 0;

			next_counter = 0;
			next_state = STATE_1;
			busy = 0;
		end
		
	endcase
end

endmodule