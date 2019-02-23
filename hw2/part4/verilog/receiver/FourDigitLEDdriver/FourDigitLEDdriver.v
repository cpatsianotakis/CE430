/*	FourDigitLEDdriver module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Drives the four digits LED monitor.
* The message data is 16 bit, 4 for each digit.
* Gets a 8 bit message input and adds it in the 16 bit message
* by shifting it.
*/

module FourDigitLEDdriver(
  reset,
  clk,
  new_message,
  valid_message,
  an3,
  an2,
  an1,
  an0,
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  dp
);


input clk, reset;
input [7:0] new_message;
input valid_message;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;

wire [6:0] LEDdecoded;
wire [3:0] an;
wire system_clk;

wire CLK0;
wire CDD = CLK0;
wire reset_mul_three;

reg [15:0] message;
wire [3:0]  outMessage;

always @( posedge clk or posedge reset_mul_three ) 
begin
  if ( reset_mul_three == 1)
  begin
    message = 16'b1111_1111_1111_1111;
  end

  else
  if ( valid_message == 1) 
  begin
    message[15:8] = message[7:0];
    message[7:0]  = new_message; 
  end
end


resetForDCM resetForDCM_INSTANCE(
	.clk(clk),
	.inputReset(reset), 
	.outputReset(reset_mul_three)
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
  .CLKDV(system_clk),   // Divided DCM CLK out (CLKDV_DIVIDE)
  .CLKFB(CDD),   // DCM clock feedback
  .CLKIN(clk),   // Clock input (from IBUFG, BUFG or DCM)
  .RST(reset_mul_three)        // DCM asynchronous reset input
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
