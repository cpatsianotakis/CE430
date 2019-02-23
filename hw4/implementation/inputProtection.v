/*	InputProtection module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Module to check for metastabilities and bouncing from external environment.
*/

module inputProtection(clk, inputFromButton, inputToCricuit);

parameter NBounces = 3;
parameter CounterBit = 1;

input inputFromButton, clk;
output inputToCricuit;

//Regs and wire for metastability
reg input_metastability, input_without_metastability;
wire input_metastability_w, input_without_metastability_w;

reg [CounterBit:0] counter;
reg inputToCricuitreg;

reg can_be_driven_flag;


//METASTABILITY
always @(posedge clk)
begin
	input_metastability = inputFromButton;
end

assign input_metastability_w = input_metastability;

always @(posedge clk)
begin
	input_without_metastability = input_metastability_w;
end

assign input_without_metastability_w = input_without_metastability;

//DEBOUNCER
always @(posedge clk)
begin
	if (input_without_metastability_w == 0)
	begin
		counter = 0;
		inputToCricuitreg = 0;
		can_be_driven_flag = 1;
	end

	else
	begin
		
		if(counter == (NBounces-1) && can_be_driven_flag) //Have reached at NBounces bounces
		begin
			counter = 0;
			inputToCricuitreg = 1;
			can_be_driven_flag = 0;
		end
		else 
		begin
			counter = counter + 1;
			inputToCricuitreg = 0;
		end

	end
end

assign inputToCricuit = inputToCricuitreg;
	

endmodule

