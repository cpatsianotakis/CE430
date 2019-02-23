module resetForDCM(clk, inputReset, outputReset);

input clk, inputReset;
output outputReset;

reg outputResetReg;

reg [2:0] counter;

always @(posedge clk) 
begin
	
	if(inputReset)
	begin
		counter = 1;	
		outputResetReg = 1;
	end

	else
	begin

		if(counter != 0)
		begin

			if(counter > 3)
			begin
				outputResetReg = 0;
				counter = 0;
			end

			else 
			begin
				outputResetReg = 1;
				counter = counter + 1;
			end

		end

		else 
		begin
			outputResetReg = 0;	
		end
			
	end
	
end

assign outputReset = outputResetReg;

endmodule
