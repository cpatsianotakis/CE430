module LCD_Instruction_Fetch
(
	clk,
	reset,
	instruction_done,
	instruction,
	instruction_valid,
	init_mode
);

input clk;
input reset;
input instruction_done;

output reg [9:0] instruction;
output reg instruction_valid;
output init_mode;

wire config_busy, config_activator;

wire [9:0] instruction_init;
wire instruction_valid_init;

wire [9:0] instruction_config;
wire instruction_valid_config;

wire [9:0] instruction_dataDisplayer;
wire instruction_valid_dataDisplayer;

reg DataDisplayer_enable;

LCD_Initializer LCD_Initializer_INST
(
	.clk ( clk ),
	.reset ( reset ),
	.instruction ( instruction_init ),
	.instruction_valid ( instruction_valid_init ),
	.busy (init_mode)
);

LCD_Configurator_Activator LCD_Configurator_Activator_INST
(
	.clk ( clk ),
	.reset ( init_mode ),
	.activator ( config_activator ),
	.instruction_done ( instruction_done )
);

LCD_Configurator LCD_Configurator_INST
(
	.clk ( clk ),
	.reset ( reset ),
	.activator ( config_activator ),
	.instruction_done ( instruction_done ),
	.instruction ( instruction_config ),
	.instruction_valid ( instruction_valid_config ),
	.busy ( config_busy )
);

LCD_DataDisplayer LCD_DataDisplayer_INST
(
	.clk ( clk ),
	.reset ( reset ),
	.enable ( DataDisplayer_enable ),
	.instruction_done ( instruction_done ),
	.instruction ( instruction_dataDisplayer ),
	.instruction_valid ( instruction_valid_dataDisplayer )
);

always @( init_mode or config_busy or instruction_valid_init or instruction_init or instruction_valid_config or instruction_config or instruction_valid_dataDisplayer or instruction_dataDisplayer ) begin
	
	if ( init_mode )
	begin
		
		instruction_valid = instruction_valid_init;
		instruction = instruction_init;
		DataDisplayer_enable = 0;

	end

	else
	begin
		
		if ( config_busy )
		begin
			
			instruction_valid = instruction_valid_config;
			instruction = instruction_config;
			DataDisplayer_enable = 0;

		end
		else
		begin
			
			instruction_valid = instruction_valid_dataDisplayer;
			instruction = instruction_dataDisplayer;
			DataDisplayer_enable = 1;

		end
	end
end

endmodule


