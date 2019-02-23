`timescale 1ns / 1ps

module test_uart_channel;

	// Inputs
	reg reset_u;
	reg clk;


	wire baud_0_u;
	wire baud_1_u;
	wire baud_2_u;

	// Outputs
	wire monitor_an3;
	wire monitor_an2;
	wire monitor_an1;
	wire monitor_an0;
	wire monitor_a;
	wire monitor_b;
	wire monitor_c;
	wire monitor_d;
	wire monitor_e;
	wire monitor_f;
	wire monitor_g;
	wire monitor_dp;

	integer i;

	reg [2:0] baud;

	assign baud_0_u = baud[0];
	assign baud_1_u = baud[1];
	assign baud_2_u = baud[2];

	// Instantiate the Unit Under Test (UUT)
	uart_channel uut (
		.reset_u(reset_u), 
		.clk(clk), 
		.baud_0_u(baud_0_u), 
		.baud_1_u(baud_1_u), 
		.baud_2_u(baud_2_u), 
		.monitor_an3(monitor_an3), 
		.monitor_an2(monitor_an2), 
		.monitor_an1(monitor_an1), 
		.monitor_an0(monitor_an0), 
		.monitor_a(monitor_a), 
		.monitor_b(monitor_b), 
		.monitor_c(monitor_c), 
		.monitor_d(monitor_d), 
		.monitor_e(monitor_e), 
		.monitor_f(monitor_f), 
		.monitor_g(monitor_g), 
		.monitor_dp(monitor_dp)
	);

	initial begin
		// Initialize Inputs
		reset_u = 0;
		clk = 0;
		baud = 3'b111;

		#20;
		reset_u = 1;

		// Wait 100 ns for global reset to finish
		#100;
		reset_u = 0;

		#1410065408;
		baud = 3'b000;
     	
     	for ( i = 0; i < 8; i = i + 1)
		begin
			#1410065408;
			baud = baud + 1;
		end

		$finish;

	end


always
	#10 clk = ~clk;



	
endmodule

