module LCD_Controller
(
	clk,
	resetbutton,
	LCD_RS,
	DB,
	LCD_RW,
	LCD_E
);

input clk;
input resetbutton;

output LCD_RS;
output [3:0] DB;
output LCD_RW;
output LCD_E;

wire reset;

wire instruction_valid;
wire [9:0] instruction;
wire init_mode;
wire instruction_done;
wire is_busy;

assign instruction_done = ~is_busy;

inputProtection inputProtection_INST_RESET
(
	.clk ( clk ),
	.inputFromButton ( resetbutton ),
	.inputToCricuit ( reset )
);


LCD_Instruction_Sender LCD_Instruction_Sender_INST
(
	.clk ( clk ),
	.reset ( reset ),
	.instruction_valid ( instruction_valid ),
	.instruction ( instruction ),
	.init_mode ( init_mode ),
	.LCD_RS (LCD_RS ),
	.DB ( DB ),
	.LCD_RW ( LCD_RW ),
	.LCD_E ( LCD_E ),
	.busy ( is_busy )
);

LCD_Instruction_Fetch LCD_Instruction_Fetch_INST
(
	.clk ( clk ),
	.reset ( reset ),
	.instruction_done ( instruction_done ),
	.instruction ( instruction ),
	.instruction_valid ( instruction_valid ),
	.init_mode ( init_mode )
);

endmodule