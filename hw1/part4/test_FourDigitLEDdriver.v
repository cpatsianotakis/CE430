`timescale 1ns / 100 ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:49:05 10/09/2018
// Design Name:   FourDigitLEDdriver
// Module Name:   /home/inf2015/cpatsianotakis/ce430/fourDigitLEDdriver/test_fourDigitLEDdriver.v
// Project Name:  fourDigitLEDdriver
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FourDigitLEDdriver
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_fourDigitLEDdriver;

	//Local statements
	integer i;

	// Inputs
	reg reset;
	reg clk;

	// Outputs
	wire an3;
	wire an2;
	wire an1;
	wire an0;
	wire a;
	wire b;
	wire c;
	wire d;
	wire e;
	wire f;
	wire g;
	wire dp;

	// Instantiate the Unit Under Test (UUT)
	FourDigitLEDdriver top_level_instance (
		.reset(reset), 
		.clk(clk), 
		.an3(an3), 
		.an2(an2), 
		.an1(an1), 
		.an0(an0), 
		.a(a), 
		.b(b), 
		.c(c), 
		.d(d), 
		.e(e), 
		.f(f), 
		.g(g), 
		.dp(dp)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		clk = 0;

		#20
		reset = 1;

		#20
        reset = 0;

        #20 
        reset = 1;

        #40 
        reset = 0;

        #20
        reset = 1;

        #50
        reset = 0;

        #4
        reset = 1;

        #2
        reset = 0;

        #1
        reset = 1;

        #7
        reset = 0;

        #30
        reset = 1;

        #60
        reset = 0;

	end
	
	always
	begin
		#10 clk = ~clk;
	end
      
endmodule

