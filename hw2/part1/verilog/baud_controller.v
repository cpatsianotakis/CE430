/*
/--------------------------------------------------------------------------------------/
/===================================VARS DEFINITIONS===================================/
/--------------------------------------------------------------------------------------/
*
*	BS   = BAUD_SEL (baud_select) is the input
*
*	BR   = BAUD_RATE is the speed and counted in bits/sec
*
*	T_sc = is the period of sampling in ns
*	Calculated : T_sc = ( 10^9 / (16*BR)
*
*	MCV   = MAX_COUNTER_VALUE is the max counter value to count one period
*	Calculated : MCV = T_sc/20 
*
*	BIT_MCV = The num of bits for counter reg.
*	Calculated : BIT_MCV = UPPER_INTEGER ( log2 ( MAX ( MCV) ) )
*
/--------------------------------------------------------------------------------------/
/======================================================================================/
/--------------------------------------------------------------------------------------/
*
*
/--------------------------------------------------------------------------------------/
/=====================================VALUES TABLE=====================================/
/--------------------------------------------------------------------------------------/
*	BS = 000	BR = 300     T_sc = 208333	MCV = 10417
*	BS = 001	BR = 1200    T_sc = 52083	MCV = 2604
*	BS = 010	BR = 4800    T_sc = 13021	MCV = 651
*	BS = 011	BR = 9600    T_sc = 6510	MCV = 326
*	BS = 100	BR = 19200   T_sc = 3255	MCV = 163
*	BS = 101	BR = 38400   T_sc = 1628	MCV = 81
*	BS = 110	BR = 57600   T_sc = 1085	MCV = 54
*	BS = 111	BR = 115200  T_sc = 543 	MCV = 27
*
*	BIT_MCV = 14
/--------------------------------------------------------------------------------------/
/======================================================================================/
/--------------------------------------------------------------------------------------/
*/
module baud_controller (	
	reset,
	clk,
	baud_select,
	sample_ENABLE
);

input reset, clk;
input [2:0] baud_select;
output reg sample_ENABLE;

reg [2:0] baud_select_prev;

parameter BAUD_RATE_000 = 10417;
parameter BAUD_RATE_001 = 2604;
parameter BAUD_RATE_010 = 651;
parameter BAUD_RATE_011 = 326;
parameter BAUD_RATE_100 = 163;
parameter BAUD_RATE_101 = 81;
parameter BAUD_RATE_110 = 54;
parameter BAUD_RATE_111 = 27;

parameter MAX_BIT_COUNTER = 14;


reg [MAX_BIT_COUNTER:0] clk_counter;

always @(posedge clk or posedge reset) 
begin
	if ( reset) 
	begin
		
		clk_counter = 0;
		sample_ENABLE = 0;
		baud_select_prev = 3'b000;
	end
	else

	if ( baud_select != baud_select_prev)
	begin
		clk_counter = 0;
		sample_ENABLE = 0;
		baud_select_prev = baud_select;
	end

	else
	case ( baud_select )

		3'b000 : 
		begin
			if (clk_counter == BAUD_RATE_000)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end

		3'b001 : 
		begin
			if (clk_counter == BAUD_RATE_001)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end

		3'b010 : 
		begin
			if (clk_counter == BAUD_RATE_010)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end
	 
		3'b011 : 
		begin
			if (clk_counter == BAUD_RATE_011)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end
	 
		3'b100 : 
		begin
			if (clk_counter == BAUD_RATE_100)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end
	 
		3'b101 : 
		begin
			if (clk_counter == BAUD_RATE_101)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end
	 
		3'b110 : 
		begin
			if (clk_counter == BAUD_RATE_110)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end
	 
		3'b111 : 
		begin
			if (clk_counter == BAUD_RATE_111)
			begin

				clk_counter = 0;
				sample_ENABLE = 1;

			end
			else 
			begin
				
				clk_counter = clk_counter + 1;
				sample_ENABLE = 0;

			end
		end
	endcase	
	
end

endmodule