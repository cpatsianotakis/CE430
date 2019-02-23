module LCD_Configurator
(
	clk,
	reset,
	activator,
	instruction_done,
	instruction,
	instruction_valid,
	busy
);


input clk;
input reset;
input activator;
input instruction_done;

output reg [9:0] instruction;
output reg instruction_valid;
output reg busy;

parameter STATE_IDLE = 3'b000;
parameter STATE_A 	 = 3'b001;
parameter STATE_B	 = 3'b010;
parameter STATE_C	 = 3'b011;
parameter STATE_D	 = 3'b100;
parameter STATE_E	 = 3'b101;

parameter MAX_STATE_E_CV = 82000;

reg [2:0] state;
reg [2:0] next_state;

reg state_f_period;
reg next_state_f_period;

reg [16:0] counter;
reg [16:0] next_counter;

always @(posedge clk or posedge reset) begin
	if ( reset )
	begin
		state = STATE_IDLE;
		state_f_period = 0;
		counter = 0;
	end
	else 
	begin
		state = next_state;
		state_f_period = next_state_f_period;
		counter = next_counter;
	end
		
end

always @( state or instruction_done or activator or counter or state_f_period ) begin
	
	case ( state )

		STATE_IDLE:
		begin
			
			instruction = 10'b00_0010_1000;
			instruction_valid = 0;
			next_counter = 0;

			busy = 0;

			if ( activator )
			begin
				next_state = STATE_A;
				next_state_f_period = 1;
			end
				
			else
			begin
				next_state = state;
				next_state_f_period = 0;
			end
				

		end

		STATE_A:
		begin
			
			instruction = 10'b00_0010_1000;
			next_counter = 0;

			busy = 1;

			if ( state_f_period )
			begin
				instruction_valid = 1;
				next_state = state;
				next_state_f_period = 0;
			end
			else
			begin
				instruction_valid = 0;

				if ( instruction_done )
				begin
					next_state = STATE_B;
					next_state_f_period = 1;
				end
				else
				begin
					next_state = state;
					next_state_f_period = 0;
				end
					
			end
				
		end

		STATE_B:
		begin
			
			instruction = 10'b00_0000_0110;
			next_counter = 0;

			busy = 1;

			if ( state_f_period )
			begin
				instruction_valid = 1;
				next_state = state;
				next_state_f_period = 0;
			end
			else
			begin
				instruction_valid = 0;

				if ( instruction_done )
				begin
					next_state = STATE_C;
					next_state_f_period = 1;
				end
				else
				begin
					next_state = state;
					next_state_f_period = 0;
				end
					
			end
				
		end

		STATE_C:
		begin
			
			instruction = 10'b00_0000_1100;
			next_counter = 0;

			busy = 1;

			if ( state_f_period )
			begin
				instruction_valid = 1;
				next_state = state;
				next_state_f_period = 0;
			end
			else
			begin
				instruction_valid = 0;

				if ( instruction_done )
				begin
					next_state = STATE_D;
					next_state_f_period = 1;
				end
				else
				begin
					next_state = state;
					next_state_f_period = 0;
				end
					
			end
				
		end

		STATE_D:
		begin
			
			instruction = 10'b00_0000_0001;
			next_counter = 0;

			busy = 1;

			if ( state_f_period )
			begin
				instruction_valid = 1;
				next_state = state;
				next_state_f_period = 0;
			end
			else
			begin
				instruction_valid = 0;

				if ( instruction_done )
				begin
					next_state = STATE_E;
					next_state_f_period = 1;
				end
				else
				begin
					next_state = state;
					next_state_f_period = 0;
				end
					
			end
				
		end

		STATE_E:
		begin
			
			instruction = 10'b00_0010_1000;
			instruction_valid = 0;

			busy = 1;

			if ( counter == MAX_STATE_E_CV )
			begin
				next_state = STATE_IDLE;
				next_state_f_period = 1;
				next_counter = 0;
			end
			else
			begin
				next_state = state;
				next_state_f_period = 0;
				next_counter = counter + 1;
			end
				
		end

		default:
		begin
			
			instruction = 10'b00_0000_0000;
			instruction_valid = 0;

			busy = 0;

			next_state = STATE_IDLE;
			next_state_f_period = 1;
			next_counter = 0;
		end


	endcase

end

endmodule


