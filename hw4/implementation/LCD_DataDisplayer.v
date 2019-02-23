module LCD_DataDisplayer
(
	clk,
	reset,
	enable,
	instruction_done,
	instruction,
	instruction_valid
);

input clk;
input reset;
input enable;
input instruction_done;

output reg [9:0] instruction;
output reg instruction_valid;

parameter STATE_SET_DDRAM   = 0;
parameter STATE_WRITE_DDRAM = 1;

wire [7:0] BRAM_DO;

reg state;
reg next_state;

reg state_f_period;
reg next_state_f_period;

reg [6:0] DDRAM_address;
reg [6:0] next_DDRAM_address;

reg [10:0] BRAM_address;
reg [10:0] next_BRAM_address;

LCD_BRAM LCD_BRAM_INST
(
	.clk ( clk ),
	.reset ( reset ),
	.address ( BRAM_address ),
	.do ( BRAM_DO )
);


always @(posedge clk or posedge  reset)
begin
	if ( reset )
	begin
		DDRAM_address = 0;
		BRAM_address = 0;
		state = 0;
		state_f_period = 1;
		
	end
	else
	begin
		BRAM_address = next_BRAM_address;
		DDRAM_address = next_DDRAM_address;
		state = next_state;
		state_f_period = next_state_f_period;
	end
end

always @( enable or state or instruction_done or state_f_period or DDRAM_address or BRAM_address or BRAM_DO )
begin
	
	if ( enable )
	begin
		
		if( state == STATE_SET_DDRAM )
		begin

			instruction [9:7] = 3'b001;
			instruction [6:0] = DDRAM_address;

			next_BRAM_address = BRAM_address;

			if ( state_f_period )
			begin
				instruction_valid = 1;
				next_state_f_period = 0;
				next_DDRAM_address = DDRAM_address;
				next_state = state;
			end
			else
			begin
				instruction_valid = 0;
			
				if ( instruction_done )
				begin
					next_state = STATE_WRITE_DDRAM;
					next_state_f_period = 1;

					if ( DDRAM_address == 7'b000_1111 )
					begin
						next_DDRAM_address = 7'b100_0000;
					end
					else
					if ( DDRAM_address == 7'b100_1111 )
					begin
						next_DDRAM_address = 0;
					end
					else
					begin
						next_DDRAM_address = DDRAM_address + 1;	
					end
				end
				else
				begin
					
					next_state = state;
					next_DDRAM_address = DDRAM_address;
					next_state_f_period = 0;

				end
			end

		end

		else
		begin

			instruction [9:8] = 2'b10;
			instruction [7:0] = BRAM_DO;

			next_DDRAM_address = DDRAM_address;

			if ( state_f_period )
			begin
				instruction_valid = 1;
				next_state_f_period = 0;
				next_BRAM_address = BRAM_address;
				next_state = state;
			end
			else
			begin
				instruction_valid = 0;
			
				if ( instruction_done )
				begin
					next_state = STATE_SET_DDRAM;
					next_state_f_period = 1;

					if ( BRAM_address == 15 )
					begin
						next_BRAM_address = 0;
					end
					else
					begin
						next_BRAM_address = BRAM_address + 1;	
					end
				end
				else
				begin
					
					next_state = state;
					next_BRAM_address = BRAM_address;
					next_state_f_period = 0;

				end

			end

		end

	end
	else
	begin
		
		next_state = STATE_SET_DDRAM;
		next_BRAM_address = 0;
		next_DDRAM_address = 0;
		next_state_f_period = 1;
		instruction_valid = 0;
		instruction = 10'b00_0000_0000;

	end

end


endmodule