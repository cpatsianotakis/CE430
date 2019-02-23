

module vertical_controller(
	reset,
	clk,
	HSYNC,
	addr,
	VSYNC,
	Frame_ON
);

input reset;
input clk;
input HSYNC;
output reg [6:0] addr;
output reg VSYNC;
output reg Frame_ON;

parameter STATE_PULSE_WIDTH = 3'b00;
parameter STATE_BACK_PORCH = 3'b01;
parameter STATE_DISPLAY_TIME = 3'b10;
parameter STATE_FRONT_PORCH = 3'b11;

parameter MAX_COUNTER_PULSE_WIDTH = 3199;
parameter MAX_COUNTER_BACK_PORCH = 46399;
parameter MAX_COUNTER_DISPLAY_TIME = 767999;
parameter MAX_COUNTER_FRONT_PORCH = 15999;


reg [2:0] state;
reg [2:0] next_state;

reg [19:0] counter;
reg [19:0] next_counter;

reg  negedge_HSYNC;
reg  next_negedge_HSYNC;

reg [2:0] counter_HSYNC;
reg [2:0] next_counter_HSYNC;

reg [6:0] next_addr;


always @(posedge clk or posedge reset) 
begin
	if ( reset ) 
	begin
		state = STATE_PULSE_WIDTH;
		counter = 0;
		negedge_HSYNC = 1;
		counter_HSYNC = 0;
		addr = 0;
		
	end

	else 
	begin
		state = next_state;
		counter = next_counter;
		counter_HSYNC = next_counter_HSYNC;
		negedge_HSYNC = next_negedge_HSYNC;
		addr = next_addr;
	end
end

always @( state or counter or  HSYNC or counter_HSYNC or negedge_HSYNC or addr)
begin

	next_counter_HSYNC = counter_HSYNC;
	next_state = state;
	next_counter = counter;
	next_addr = addr;
	
	case (state)

		STATE_PULSE_WIDTH:
		begin
			
			VSYNC = 1'b0;
			Frame_ON = 0;
			next_negedge_HSYNC = 1;

			if ( counter == MAX_COUNTER_PULSE_WIDTH)
			begin
				next_counter = 0;
				next_state = STATE_BACK_PORCH;
			end
			else 
			begin
				next_counter = counter + 1;
			end

		end

		STATE_BACK_PORCH:
		begin
			
			VSYNC = 1'b1;
			Frame_ON = 0;
			next_negedge_HSYNC = 1;

			if ( counter == MAX_COUNTER_BACK_PORCH)
			begin
				next_addr = 0;
				next_counter = 0;
				next_state = STATE_DISPLAY_TIME;
			end
			else 
			begin
				next_counter = counter + 1;
			end
		end

		STATE_DISPLAY_TIME:
		begin

			VSYNC = 1'b1;
			Frame_ON = 1;

			if ( counter == MAX_COUNTER_DISPLAY_TIME )
			begin

				next_counter = 0;
				next_state = STATE_FRONT_PORCH;
				next_addr = 0;

				next_negedge_HSYNC = 1;
				next_counter_HSYNC = 0;
			end
			else 
			begin
				next_counter = counter + 1;

				if ( HSYNC == 0 & negedge_HSYNC == 0 )
				begin

					next_negedge_HSYNC = 1;

					if ( counter_HSYNC == 3'b100)
					begin
						
						next_counter_HSYNC = 0;
						next_addr = addr + 1;
					end

					else
					begin
						
						next_counter_HSYNC = counter_HSYNC + 1;

					end
				end

				else
				if ( HSYNC == 1 )
				begin
					next_negedge_HSYNC = 0;
				end

				else 
					next_negedge_HSYNC = 1;

			end
			
		end

		STATE_FRONT_PORCH:
		begin
			
			VSYNC = 1'b1;
			Frame_ON = 0;
			next_negedge_HSYNC = 1;

			if ( counter == MAX_COUNTER_FRONT_PORCH )
			begin
				next_counter = 0;
				next_state = STATE_PULSE_WIDTH;
			end
			else 
			begin
				next_counter = counter + 1;
			end
		end

		default:
		begin
			
			Frame_ON = 0;
			VSYNC = 1'b1;
			next_addr = 0;
			next_negedge_HSYNC = 1;
		end

		
	endcase
	
end

endmodule