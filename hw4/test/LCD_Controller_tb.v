module LCD_Controller_tb;

reg clk;
reg reset;

wire LCD_RS;
wire [3:0] DB;
wire LCD_RW;
wire LCD_E;

initial
begin
	
	reset = 0;
	clk = 0;

	#40;
	reset = 1;

	#100;
	reset = 0;

	#1000000000;
	#1000000000;
	#1000000000 $finish;
end

LCD_Controller LCD_Controller_INST
(
	.clk (clk),
	.resetbutton (reset),
	.LCD_RS (LCD_RS),
	.DB (DB),
	.LCD_RW (LCD_RW),
	.LCD_E (LCD_E)
);

always #10 clk = ~clk;

endmodule
