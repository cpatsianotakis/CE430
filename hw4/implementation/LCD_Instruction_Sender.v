module LCD_Instruction_Sender
(
	clk,
	reset,
	instruction_valid,
	instruction,
	init_mode,
	LCD_RS,
	DB,
	LCD_RW,
	LCD_E,
	busy
);

input clk;
input reset;
input instruction_valid;
input [9:0] instruction;
input init_mode;

output LCD_RS;
output [3:0] DB;
output LCD_RW;
output LCD_E;
output reg busy;

parameter IDLE_STATE   = 2'b00;
parameter SETUP_STATE  = 2'b01;
parameter ENABLE_STATE = 2'b10;
parameter WAIT_STATE   = 2'b11;

parameter MAX_SETUP_CV = 1;
parameter MAX_ENABLE_CV = 11;

parameter MAX_UPPER_LOW_CV = 47;
parameter MAX_NEXT_INSTRUCTION_CV = 2000;

parameter MAX_COUNTER_BIT = 10;

parameter UPPER_BITS_STATE = 1'b1;
parameter LOWER_BITS_STATE = 1'b0;

reg [1:0] state;
reg [1:0] next_state;

reg bits_state;
reg next_bits_state;

reg [ MAX_COUNTER_BIT : 0] counter;
reg [ MAX_COUNTER_BIT : 0] next_counter;

reg LCD_E_FSM, LCD_RW_FSM, LCD_RS_FSM;
reg [3:0] DB_FSM;

reg LCD_E_neg;

assign LCD_RS = LCD_RS_FSM;
assign DB = DB_FSM;
assign LCD_RW = LCD_RW_FSM;
assign LCD_E =  LCD_E_FSM & LCD_E_neg;

always @ ( posedge clk or posedge reset )
begin

	if ( reset )
	begin
		
		state = IDLE_STATE;
		bits_state = UPPER_BITS_STATE;
		counter = 0;

	end

	else
	begin
		
		state = next_state;
		bits_state = next_bits_state;
		counter = next_counter;
	end
	
end

always @( instruction_valid or state or counter or bits_state or init_mode or instruction ) begin
	
	if ( bits_state == UPPER_BITS_STATE )
	begin

		case ( state )
		
			IDLE_STATE:
			begin

				LCD_RW_FSM = 1'b1;
				LCD_E_FSM  = 1'b0;
				
				LCD_RS_FSM = 1'b1;
				DB_FSM = 4'b0000;

				next_bits_state = bits_state;
				next_counter = 0;

				if ( instruction_valid )
					next_state = SETUP_STATE;
				else
					next_state = IDLE_STATE;

				busy = 0;			

			end

			SETUP_STATE:
			begin

				LCD_RW_FSM = 1'b0;
				LCD_E_FSM  = 1'b0;

				LCD_RS_FSM = instruction [8];
				DB_FSM [3] = instruction [7];
				DB_FSM [2] = instruction [6];
				DB_FSM [1] = instruction [5];
				DB_FSM [0] = instruction [4];
				
				next_bits_state = bits_state;

				if ( counter == MAX_SETUP_CV )
				begin
					next_counter = 0;
					next_state = ENABLE_STATE;
				end
					
				else
				begin
					next_counter = counter + 1;
					next_state = SETUP_STATE;
				end

				busy = 1;
									

			end

			ENABLE_STATE:
			begin

				LCD_RW_FSM = 1'b0;
				LCD_E_FSM  = 1'b1;

				LCD_RS_FSM = instruction [8];
				DB_FSM [3] = instruction [7];
				DB_FSM [2] = instruction [6];
				DB_FSM [1] = instruction [5];
				DB_FSM [0] = instruction [4];


				if ( counter == MAX_ENABLE_CV )
				begin
					next_counter = 0;
					next_state = IDLE_STATE;

					if ( init_mode )
					begin
						next_bits_state = bits_state;
						busy = 0;
					end
					else
					begin
						next_bits_state = LOWER_BITS_STATE;
						busy = 1;
					end
					
				end
					
				else
				begin
					next_counter = counter + 1;
					next_state = ENABLE_STATE;
					next_bits_state = bits_state;
					busy = 1;
				end
				

			end

			default:
			begin
				
				next_state = IDLE_STATE;
				next_counter = 0;
				next_bits_state = UPPER_BITS_STATE;
				busy = 0;

				LCD_RW_FSM = 1'b1;
				LCD_E_FSM  = 1'b0;
				
				LCD_RS_FSM = 1'b1;
				DB_FSM = 4'b0000;
			end

		endcase
		
	end
	else
	begin

		case ( state )
		
			IDLE_STATE:
			begin

				LCD_RW_FSM = 1'b1;
				LCD_E_FSM  = 1'b0;
				
				LCD_RS_FSM = 1'b1;
				DB_FSM = 4'b0000;

				next_bits_state = bits_state;

				if ( counter == MAX_UPPER_LOW_CV )
				begin
					next_state = SETUP_STATE;
					next_counter = 0;
				end
				else
				begin
					next_state = IDLE_STATE;
					next_counter = counter + 1;
				end

				busy = 1;			

			end

			SETUP_STATE:
			begin

				LCD_RW_FSM = 1'b0;
				LCD_E_FSM  = 1'b0;

				LCD_RS_FSM = instruction [8];
				DB_FSM [3] = instruction [3];
				DB_FSM [2] = instruction [2];
				DB_FSM [1] = instruction [1];
				DB_FSM [0] = instruction [0];
				
				next_bits_state = bits_state;

				if ( counter == MAX_SETUP_CV )
				begin
					next_counter = 0;
					next_state = ENABLE_STATE;
				end
					
				else
				begin
					next_counter = counter + 1;
					next_state = SETUP_STATE;
				end

				busy = 1;
									

			end

			ENABLE_STATE:
			begin

				LCD_RW_FSM = 1'b0;
				LCD_E_FSM  = 1'b1;

				LCD_RS_FSM = instruction [8];
				DB_FSM [3] = instruction [3];
				DB_FSM [2] = instruction [2];
				DB_FSM [1] = instruction [1];
				DB_FSM [0] = instruction [0];

				next_bits_state = bits_state;

				if ( counter == MAX_ENABLE_CV )
				begin
					next_counter = 0;
					next_state = WAIT_STATE;
				end
					
				else
				begin
					next_counter = counter + 1;
					next_state = ENABLE_STATE;
				end

				busy = 1;
				

			end

			WAIT_STATE:
			begin

				LCD_RW_FSM = 1'b1;
				LCD_E_FSM  = 1'b0;
				
				LCD_RS_FSM = 1'b1;
				DB_FSM = 4'b0000;

				if ( counter == MAX_NEXT_INSTRUCTION_CV )
				begin
					next_state = IDLE_STATE;
					next_counter = 0;
					next_bits_state = UPPER_BITS_STATE;
					busy = 0;

				end
				else
				begin
					next_state = state;
					next_counter = counter + 1;
					next_bits_state = bits_state;
					busy = 1;

				end
				
			end

		endcase
		
	end
end

always @( negedge clk ) 
begin
	if ( state == ENABLE_STATE && counter == MAX_ENABLE_CV ) 
		LCD_E_neg = 0;

	else 
		LCD_E_neg = 1;
	
end

endmodule
