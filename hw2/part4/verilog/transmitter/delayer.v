/*	delayer module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Module that enables ouptut (time_elapsed), one second after
*	last negadge input (delayer_enable)
*/

module delayer(
	reset,
	clk,
	delayer_enable,
	time_elapsed
);

input clk, reset;
input delayer_enable;
output reg time_elapsed;

parameter MAX_COUNTER      =  50000000;  // 50000000 * clockPeriod (20ns) = 1 s
parameter MAX_COUNTER_BIT  =  25;       // 25 + 1 bits for saving 50000000

parameter STATE_IDLE = 0;
parameter STATE_COUNTING = 1;

reg state;

reg [MAX_COUNTER_BIT:0] counter;

always @( posedge clk or posedge reset)
begin
	
	if ( reset )
	begin
		time_elapsed = 0;
		counter = 0;
	end
	
	else
	begin

		if ( delayer_enable )
		begin
			counter = 0;
			state = STATE_COUNTING;
		end

		else 
		begin
			
			if ( state == STATE_COUNTING )
			begin

				if (counter == MAX_COUNTER)
				begin

					counter = 0;
					state = STATE_IDLE;
					time_elapsed = 1;

				end

				else 
				begin

					counter = counter + 1;
					time_elapsed = 0;

				end

			end

			else 
			begin

				time_elapsed = 0;

			end
		end
	end
end


endmodule