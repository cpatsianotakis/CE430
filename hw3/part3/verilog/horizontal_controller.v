

module horizontal_controller(
	reset,
	clk,
	V_Frame_ON,
	addr,
	HSYNC,
	H_Frame_ON
);

input reset;
input clk;
input V_Frame_ON;
output reg [6:0] addr;
output reg HSYNC;
output reg H_Frame_ON;

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

reg [6:0] next_addr;


always @(posedge clk or posedge reset) 
begin
	if ( reset ) 
	begin
		state = STATE_B;
		counter = 0;
		addr_counter = 0;
		addr = 0;
		
	end

	else 
	begin
		state = next_state;
		counter = next_counter;
		addr_counter = next_addr_counter;
		addr = next_addr;
	end
end

always @( state or counter or  addr_counter or addr or V_Frame_ON )
begin

	next_addr_counter = addr_counter;
	next_state = state;
	next_counter = counter;
	next_addr = addr;
	
	if ( V_Frame_ON == 0 )
	begin
		
		next_state = STATE_B;
		next_addr = 0;
		next_counter = 0;
		next_addr_counter = 0;
		HSYNC = 0;
		H_Frame_ON = 0;

	end
	else
	begin

		case (state)

			STATE_B:
			begin
				
				HSYNC = 1'b0;
				H_Frame_ON = 0;

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
				H_Frame_ON = 0;

				if ( counter == MAX_COUNTER_C)
				begin
					next_addr = 0;
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
				H_Frame_ON = 1;

				if ( counter == MAX_COUNTER_D )
				begin
					next_counter = 0;
					next_state = STATE_E;
					next_addr = 0;
				end
				else 
				begin
					next_counter = counter + 1;

					if ( addr_counter == MAX_COUNTER_FOR_ADDRESS )
					begin
						next_addr_counter = 0;
						next_addr = addr + 1;
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
				H_Frame_ON = 0;

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

			default:
			begin
				
				HSYNC = 1'b0;
				next_addr = 0;
				H_Frame_ON = 0;
			end

			
		endcase

	end
	
end

endmodule