module LCD_Configurator_Activator
(
	clk,
	reset,
	activator,
	instruction_done
);

input clk;
input reset;
input instruction_done;
output reg activator;

parameter MAX_CV = 50000000;

reg [25:0] counter;
reg [25:0] next_counter;

always @(posedge clk or posedge reset )
begin
	if ( reset ) 
	begin
		
		counter = MAX_CV;	
	end
	else 
	begin
		
		counter = next_counter;
		
	end
end

always @( counter or instruction_done )
begin
	
	if ( counter == 0 )
	begin

		if ( instruction_done )
		begin
			activator = 1;
			next_counter = counter + 1;
		end
		else
		begin
			activator = 0;
			next_counter = counter;
		end
	end
	else
	begin
		
		activator = 0;

		if ( counter == MAX_CV )
			next_counter = 0;
		else			
			next_counter = counter + 1;

	end

end

endmodule
