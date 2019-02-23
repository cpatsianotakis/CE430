`timescale 1ns / 10ps

module baud_controller_test;

// INPUTS //
reg reset;
reg clk;
reg [2:0] baud_select;

// OUTPUTS //
wire sample_ENABLE;

integer i;

baud_controller top_level_instance ( 
	.reset(reset),
	.clk(clk),
	.baud_select(baud_select),
	.sample_ENABLE(sample_ENABLE)
);

initial
begin
	
	reset = 0;
	clk   = 0;
	baud_select = 3'b000;

	#20
	reset = 1;

	#180
	reset = 0;

	for ( i = 0; i < 8; i = i + 1)
	begin
		#1000000
		baud_select = baud_select + 1;
	end

	$finish;

end

always
begin
	#10 clk = ~clk;
end

endmodule