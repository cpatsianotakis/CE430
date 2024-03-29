/*	InputAntiBouncer module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Module to check for metastabilities and bouncing from external environment.
*/

module FourDigitLEDdriver(reset, clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
input clk, reset;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;

wire change_msg;

wire [6:0] LEDdecoded;
wire [3:0] an;
wire system_clk;

wire CLK0;
wire CDD = CLK0;
wire reset_antibounced, reset_mul_three;

wire [15:0] message;
wire [3:0]  outMessage;

inputAntiBouncer resetAntiBouncerINSTANCE(
	.clk(clk), 
	.inputFromButton(reset), 
	.inputToCricuit(reset_antibounced)
	);



resetForDCM resetForDCM_INSTANCE(
	.clk(clk),
	.inputReset(reset_antibounced), 
	.outputReset(reset_mul_three)
	);

change_msg_generator change_msg_generator_INSTANCE(
	.clk(system_clk),
	.reset(reset_mul_three),
	.change_msg(change_msg)
	);


DCM #(
  .SIM_MODE("SAFE"),  // Simulation: "SAFE" vs. "FAST", see "Synthesis and Simulation Design Guide" for details
  .CLKDV_DIVIDE(16.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                      //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
  .CLKFX_DIVIDE(1),   // Can be any integer from 1 to 32
  .CLKFX_MULTIPLY(4), // Can be any integer from 2 to 32
  .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
  .CLKIN_PERIOD(0.0),  // Specify period of input clock
  .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift of NONE, FIXED or VARIABLE
  .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
  .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                        //   an integer from 0 to 15
  .DFS_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for frequency synthesis
  .DLL_FREQUENCY_MODE("LOW"),  // HIGH or LOW frequency mode for DLL
  .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, TRUE or FALSE
  .FACTORY_JF(16'hC080),   // FACTORY JF values
  .PHASE_SHIFT(0),     // Amount of fixed phase shift from -255 to 255
  .STARTUP_WAIT("FALSE")   // Delay configuration DONE until DCM LOCK, TRUE/FALSE
) DCM_inst (
  .CLK0(CLK0),     // 0 degree DCM CLK output
  //.CLK180(CLK180), // 180 degree DCM CLK output
  //.CLK270(CLK270), // 270 degree DCM CLK output
  //.CLK2X(CLK2X),   // 2X DCM CLK output
  //.CLK2X180(CLK2X180), // 2X, 180 degree DCM CLK out
  //.CLK90(CLK90),   // 90 degree DCM CLK output
  .CLKDV(system_clk),   // Divided DCM CLK out (CLKDV_DIVIDE)
  //.CLKFX(CLKFX),   // DCM CLK synthesis out (M/D)
  //.CLKFX180(CLKFX180), // 180 degree CLK synthesis out
  //.LOCKED(LOCKED), // DCM LOCK status output
  //.PSDONE(PSDONE), // Dynamic phase adjust done output
  //.STATUS(STATUS), // 8-bit DCM status bits output
  .CLKFB(CDD),   // DCM clock feedback
  .CLKIN(clk),   // Clock input (from IBUFG, BUFG or DCM)
  //.PSCLK(PSCLK),   // Dynamic phase adjust clock input
  //.PSEN(PSEN),     // Dynamic phase adjust enable input
  //.PSINCDEC(PSINCDEC), // Dynamic phase adjust increment/decrement
  .RST(reset_mul_three)        // DCM asynchronous reset input
);

memory messageMemoryINSTANCE(
	.reset(reset_mul_three),
	.clk(system_clk),
	.re(change_msg),
	.out_data(message)
	);

anCounter counterINSTANCE (
	.reset(reset_mul_three), 
	.clk(system_clk), 
	.an(an),
	.inMessage(message), 
	.outMessage(outMessage)
	);

assign an0 = an[0];
assign an1 = an[1];
assign an2 = an[2];
assign an3 = an[3];

LEDdecoder LEDdecoderINSTANCE (
	.char(outMessage), 
	.LED(LEDdecoded)
	);

assign a = LEDdecoded[6];
assign b = LEDdecoded[5];
assign c = LEDdecoded[4];
assign d = LEDdecoded[3];
assign e = LEDdecoded[2];
assign f = LEDdecoded[1];
assign g = LEDdecoded[0];
assign dp = 1;


endmodule
