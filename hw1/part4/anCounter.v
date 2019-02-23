/*	FourdigitLEDdriver module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	
*/

module anCounter(reset, clk, inMessage, an, outMessage);
input reset, clk;
input [15:0] inMessage;
output reg [3:0]  an;
output reg [3:0]  outMessage;


reg [3:0] counter; 

always @(posedge clk or posedge reset) 
begin
	if (reset)
	begin
		
		counter = 4'b1111;
		an 		= 4'b1111;
		
	end

	else
	begin

	case(counter)
		4'b1111:
			begin
				an 		= 4'b0111;
				counter = 4'b1110;
				outMessage = inMessage[15:12];
			end

		4'b1110:
			begin
				an 		= 4'b1111;
				counter = 4'b1101;
			end

		4'b1101:
			begin
				an 		= 4'b1111;
				counter = 4'b1100;
			end

		4'b1100:
			begin
				an 		= 4'b1111;
				counter = 4'b1011;
			end

		4'b1011:
			begin
				an 		= 4'b1011;
				counter = 4'b1010;
				outMessage = inMessage[11:8];
			end

		4'b1010:
			begin
				an 		= 4'b1111;
				counter = 4'b1001;
			end

		4'b1001:
			begin
				an 		= 4'b1111;
				counter = 4'b1000;
			end

		4'b1000:
			begin
				an 		= 4'b1111;
				counter = 4'b0111;
			end

		4'b0111:
			begin
				an 		= 4'b1101;
				counter = 4'b0110;
				outMessage = inMessage[7:4];
			end

		4'b0110:
			begin
				an 		= 4'b1111;
				counter = 4'b0101;
			end

		4'b0101:
			begin
				an 		= 4'b1111;
				counter = 4'b0100;
			end

		4'b0100:
			begin
				an 		= 4'b1111;
				counter = 4'b0011;
			end

		4'b0011:
			begin
				an 		= 4'b1110;
				counter = 4'b0010;
				outMessage = inMessage[3:0];
			end

		4'b0010:
			begin
				an 		= 4'b1111;
				counter = 4'b0001;
			end

		4'b0001:
			begin
				an 		= 4'b1111;
				counter = 4'b0000;
			end

		4'b0000:
			begin
				an 		= 4'b1111;
				counter = 4'b1111;
			end


	endcase
	end
	
end

endmodule
