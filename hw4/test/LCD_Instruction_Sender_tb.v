module LCD_Instruction_Sender_tb;

reg clk;
reg reset;
reg instruction_valid;
reg [9:0] instruction;
reg init_mode;

wire LCD_RS;
wire [3:0] DB;
wire LCD_RW;
wire LCD_E;
wire busy;

initial
begin
	
	reset = 0;
	clk = 0;

	#40;
	reset = 1;

	#100;
	reset = 0;

	init_mode = 1;

	// INIT MODE //

	#60;
	instruction = 10'b00_0000_0100;
	instruction_valid = 1;
	#20;
	instruction_valid = 0;

	#42000;
	instruction = 10'b00_0010_1101;
	instruction_valid = 1;
	#20;
	instruction_valid = 0;

	#42000;
	instruction = 10'b11_0010_1101;
	instruction_valid = 1;
	#20;
	instruction_valid = 0;

	#42000;
	instruction = 10'b00_0010_1101;
	instruction_valid = 0;

	#42000;
	instruction = 10'b11_0010_1101;
	instruction_valid = 0;

	// OTHER MODE //

	#42000;
	init_mode = 0;
	instruction = 10'b10_0010_1101;
	instruction_valid = 1;
	#20;
	instruction_valid = 0;

	#42000;
	instruction = 10'b00_0101_0000;
	instruction_valid = 1;
	#20;
	instruction_valid = 0;

	#42000;
	instruction = 10'b00_0000_1010;
	instruction_valid = 1;
	#20;
	instruction_valid = 0;

	#42000;
	instruction = 10'b01_0000_0000;
	instruction_valid = 1;
	#20;
	instruction_valid = 0;

	#42000;
	instruction = 10'b01_1010_1010;
	instruction_valid = 0;

	#42000;

	$finish;

end

LCD_Instruction_Sender LCD_Instruction_Sender_INST
(
	.clk ( clk ),
	.reset ( reset ),
	.instruction_valid ( instruction_valid ),
	.instruction ( instruction ),
	.init_mode ( init_mode ),
	.LCD_RS ( LCD_RS ),
	.DB ( DB ),
	.LCD_RW ( LCD_RW ),
	.LCD_E ( LCD_E ),
	.busy ( busy )
);

always #10 clk = ~clk;

endmodule