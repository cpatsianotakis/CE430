/*	Change_msg_generator module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Module that generates the change message signal
*/

module change_msg_generator(reset, clk, change_msg);

parameter MAX_COUNTER      =  3125000;  // 3125000 * clockPeriod (320ns) = 1 s
parameter MAX_COUNTER_BIT  =  21;       // 21 + 1 bits for saving 3125000

input clk, reset;
output reg change_msg;

reg [MAX_COUNTER_BIT : 0] counter;

always@(posedge clk or posedge reset)
begin

	if(reset)
	begin
		counter    = 0;
		change_msg = 0;
	end
	else 
	begin	

		if(counter == MAX_COUNTER)
		begin
			change_msg = 1;
			counter    = 0;
		end

		else 
		begin
			change_msg = 0;	
		end

		counter = counter + 1;
	end
	

end

endmodule

