/*	InputAntiBouncer module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Memory where message is saved, and changes out value, when re is enabled
*/

module memory(reset, clk, re, out_data);
	
input reset, clk, re;
output reg [15:0] out_data;

reg [0:3] mem [15:0];
reg [3:0] counter;


always @(posedge clk or posedge reset) 
begin

	if (reset) 
	begin

		mem[0]  = 0;
		mem[1]  = 1;
		mem[2]  = 2;
		mem[3]  = 3;
		mem[4]  = 4;
		mem[5]  = 5;
		mem[6]  = 6;
		mem[7]  = 7;
		mem[8]  = 8;
		mem[9]  = 9;
		mem[10] = 10;
		mem[11] = 11;
		mem[12] = 12;
		mem[13] = 13;
		mem[14] = 14;
		mem[15] = 15;

		out_data = {mem[0], mem[1], mem[2], mem[3]};

		counter = 4;
		
	end

	else if(re)
	begin
		
		out_data[15:12] = out_data[11:8];
		out_data[11:8]  = out_data[7:4];
		out_data[7:4]   = out_data[3:0];
		out_data[3:0]   = mem[counter];

		counter = counter + 1;

	end
end

endmodule
