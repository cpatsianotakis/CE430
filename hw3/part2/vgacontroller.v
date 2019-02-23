//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:32 11/19/2018 
// Design Name: 
// Module Name:    vgacontroller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vgacontroller(
    resetbutton,
    clk,
    VGA_RED,
    VGA_GREEN,
    VGA_BLUE,
    VGA_HSYNC,
    VGA_VSYNC
    );

input resetbutton;
input clk;
output VGA_RED;
output VGA_GREEN;
output VGA_BLUE;
output VGA_HSYNC;
output VGA_VSYNC;

wire [13:0] VRAM_ADDR;
wire [6:0] HPIXEL;
wire [6:0] VPIXEL;

wire reset_synchronous;

reg [6:0] v_counter;

reset_synchronizer reset_synchronizer_INST(
      resetbutton,
      clk,
      reset_synchronous
);

assign VPIXEL = v_counter;
assign VRAM_ADDR = { VPIXEL, HPIXEL };

horizontal_controller hc_INST (
      reset_synchronous,
      clk,
      HPIXEL,
      VGA_HSYNC
      );

always @(negedge VGA_HSYNC or posedge reset_synchronous) 
begin
      if ( reset_synchronous ) 
      begin
            v_counter = 0;
            
      end

      else
      begin
            if ( v_counter == 95)
            begin
                  v_counter = 0;
            end
            else
            begin
                  v_counter = v_counter + 1;
            end
      end
end


RAMB16_S1 #(
      .INIT(1'b0),  // Value of output RAM registers at startup
      .SRVAL(1'b0), // Output value upon SSR assertion
      .WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

      // The forllowing INIT_xx declarations specify the initial contents of the RAM
      // Address 0 to 4095
      .INIT_00(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_01(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_02(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_03(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_04(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_05(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_06(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_07(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_08(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_09(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_0A(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_0B(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_0C(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0D(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0E(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0F(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      // Address 4096 to 8191
      .INIT_10(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_11(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_12(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_13(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_14(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0001_0000_0000_0000_0000_0000),
      .INIT_15(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_16(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_17(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_18(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_19(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1A(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1B(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1C(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1D(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1E(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1F(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      // Address 8192 to 12287
      .INIT_20(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_21(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_22(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_23(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_24(256'h0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF),
      .INIT_25(256'h0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000),
      .INIT_26(256'h0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF),
      .INIT_27(256'h0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000),
      .INIT_28(256'h0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF),
      .INIT_29(256'h0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000),
      .INIT_2A(256'h0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF),
      .INIT_2B(256'h0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000),
      .INIT_2C(256'h0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF),
      .INIT_2D(256'h0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000),
      .INIT_2E(256'h0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF),
      .INIT_2F(256'h0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000)

   ) VRAM_RED_INST (
      .DO ( VGA_RED ),      // 1-bit Data Output
      .ADDR ( VRAM_ADDR ),  // 14-bit Address Input
      .CLK ( clk ),    // Clock
      .EN ( 1'b1 ) ,      // RAM Enable Input
      .SSR ( reset_synchronous )    // Synchronous Reset Input
   );


RAMB16_S1 #(
      .INIT(1'b0),  // Value of output RAM registers at startup
      .SRVAL(1'b0), // Output value upon SSR assertion
      .WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

      // The forllowing INIT_xx declarations specify the initial contents of the RAM
      // Address 0 to 4095
      // Address 0 to 4095
      .INIT_00(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_01(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_02(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_03(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_04(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_05(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_06(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_07(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_08(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_09(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0A(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0B(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0C(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_0D(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_0E(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_0F(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      // Address 4096 to 8191
      .INIT_10(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_11(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_12(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_13(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_14(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_15(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_16(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_17(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_18(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_19(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1A(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1B(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1C(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1D(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1E(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_1F(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      // Address 8192 to 12287
      .INIT_20(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_21(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_22(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_23(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_24(256'h0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF),
      .INIT_25(256'h0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000),
      .INIT_26(256'h0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF),
      .INIT_27(256'h0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000),
      .INIT_28(256'h0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF),
      .INIT_29(256'h0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000),
      .INIT_2A(256'h0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF),
      .INIT_2B(256'h0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000),
      .INIT_2C(256'h0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF),
      .INIT_2D(256'h0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000),
      .INIT_2E(256'h0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF_0000_FFFF),
      .INIT_2F(256'h0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000)

   ) VRAM_GREEN_INST (
      .DO ( VGA_GREEN ),      // 1-bit Data Output
      .ADDR ( VRAM_ADDR ),  // 14-bit Address Input
      .CLK ( clk ),    // Clock
      .EN ( 1'b1 ) ,      // RAM Enable Input
      .SSR ( reset_synchronous )    // Synchronous Reset Input
   );


RAMB16_S1 #(
      .INIT(1'b0),  // Value of output RAM registers at startup
      .SRVAL(1'b0), // Output value upon SSR assertion
      .WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

      // The forllowing INIT_xx declarations specify the initial contents of the RAM
      // Address 0 to 4095
      .INIT_00(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_01(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_02(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_03(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_04(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_05(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_06(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_07(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_08(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_09(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0A(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0B(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0C(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0D(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0E(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_0F(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      // Address 4096 to 8191
      .INIT_10(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_11(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_12(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_13(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_14(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_15(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_16(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_17(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0000_0000_0000),
      .INIT_18(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_19(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_1A(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_1B(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_1C(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_1D(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_1E(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_1F(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      // Address 8192 to 12287
      .INIT_20(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_21(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_22(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_23(256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
      .INIT_24(256'hFFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF),
      .INIT_25(256'hFFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000),
      .INIT_26(256'hFFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF),
      .INIT_27(256'hFFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000),
      .INIT_28(256'hFFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF),
      .INIT_29(256'hFFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000),
      .INIT_2A(256'hFFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF),
      .INIT_2B(256'hFFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000),
      .INIT_2C(256'hFFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF),
      .INIT_2D(256'hFFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000),
      .INIT_2E(256'hFFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF_FFFF_0000_0000_FFFF),
      .INIT_2F(256'hFFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000_FFFF_0000_0000_0000)

   ) VRAM_BLUE_INST (
      .DO ( VGA_BLUE ),      // 1-bit Data Output
      .ADDR ( VRAM_ADDR ),  // 14-bit Address Input
      .CLK ( clk ),    // Clock
      .EN ( 1'b1 ) ,      // RAM Enable Input
      .SSR ( reset_synchronous )    // Synchronous Reset Input
   );


endmodule