

module horizontal_controller(
	reset,
	clk,
	addr,
	HSYNC
);

input reset;
input clk;
output reg [7:0] addr;
output reg HSYNC;

parameter STATE_B = 3'b00;
parameter STATE_C = 3'b01;
parameter STATE_D = 3'b10;
parameter STATE_E = 3'b11;

parameter MAX_COUNTER_B = 191;
parameter MAX_COUNTER_C = 95;
parameter MAX_COUNTER_D = 1279;
parameter MAX_COUNTER_E = 31;

parameter MAX_COUNTER_FOR_ADDRESS = 9;

reg [2:0] state;
reg [2:0] next_state;

reg [10:0] counter;
reg [10:0] next_counter;

reg [3:0] addr_counter;
reg [3:0] next_addr_counter;


always @(posedge clk or posedge reset) 
begin
	if ( reset ) 
	begin
		state = STATE_B;
		counter = 0;
		addr_counter = 0;
		
	end

	else 
	begin
		state = next_state;
		counter = next_counter;
		addr_counter = next_addr_counter;
	end
end

always @( state or counter or  addr_counter)
begin

	next_addr_counter = addr_counter;
	next_state = state;
	addr = addr;
	next_counter = counter;
	
	case (state)

		STATE_B:
		begin
			
			HSYNC = 1'b0;

			if ( counter == MAX_COUNTER_B)
			begin
				next_counter = 0;
				next_state = STATE_C;
			end
			else 
			begin
				next_counter = counter + 1;
			end

		end

		STATE_C:
		begin
			
			HSYNC = 1'b1;

			if ( counter == MAX_COUNTER_C)
			begin
				addr = 0;
				next_counter = 0;
				next_state = STATE_D;
			end
			else 
			begin
				next_counter = counter + 1;
			end
		end

		STATE_D:
		begin

			HSYNC = 1'b1;

			if ( counter == MAX_COUNTER_D )
			begin
				next_counter = 0;
				next_state = STATE_E;
				addr = 0;
			end
			else 
			begin
				next_counter = counter + 1;

				if ( addr_counter == MAX_COUNTER_FOR_ADDRESS )
				begin
					next_addr_counter = 0;
					addr = addr + 1;
				end

				else 
				begin
					next_addr_counter = addr_counter + 1;
				end

			end
			
		end

		STATE_E:
		begin
			
			HSYNC = 1'b1;

			if ( counter == MAX_COUNTER_E)
			begin
				next_counter = 0;
				next_state = STATE_B;
			end
			else 
			begin
				next_counter = counter + 1;
			end
		end

		
	endcase
	
end

endmodule