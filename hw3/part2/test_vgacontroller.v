module test_vgacontroller;

//Inputs
reg resetbutton;
reg clk;

//Ouputs
wire VGA_RED;
wire VGA_GREEN;
wire VGA_BLUE;

vgacontroller top_level_INST(
    .resetbutton ( resetbutton ),
    .clk ( clk ),
    .VGA_RED ( VGA_RED ),
    .VGA_GREEN ( VGA_GREEN ),
    .VGA_BLUE ( VGA_BLUE ),
    .VGA_HSYNC (VGA_HSYNC ),
    .VGA_VSYNC ( VGA_VSYNC )
    );

initial
begin

	clk = 0;
	resetbutton = 0;

	#20;
	resetbutton = 1;

	#100;
	resetbutton = 0;

	
end

always #10 clk = ~clk;

endmodule