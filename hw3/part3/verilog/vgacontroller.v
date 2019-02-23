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

wire V_Frame_ON, H_Frame_ON;
wire reset_synchronous;

wire VRAM_RED, VRAM_GREEN, VRAM_BLUE;

reset_synchronizer reset_synchronizer_INST(
      resetbutton,
      clk,
      reset_synchronous
);

assign VRAM_ADDR = { VPIXEL, HPIXEL };

assign VGA_RED = (V_Frame_ON & H_Frame_ON) ? VRAM_RED : 0;
assign VGA_GREEN = (V_Frame_ON & H_Frame_ON) ? VRAM_GREEN : 0;
assign VGA_BLUE = (V_Frame_ON & H_Frame_ON) ? VRAM_BLUE : 0;

horizontal_controller hc_INST (
      .reset (reset_synchronous),
      .clk ( clk ),
      .V_Frame_ON ( V_Frame_ON ),
      .addr ( HPIXEL ),
      .HSYNC ( VGA_HSYNC ),
      .H_Frame_ON ( H_Frame_ON )
      );

vertical_controller vc_INST(
      .reset ( reset_synchronous ),
      .clk ( clk ),
      .HSYNC ( VGA_HSYNC ),
      .addr ( VPIXEL ),
      .VSYNC ( VGA_VSYNC ),
      .Frame_ON ( V_Frame_ON )
);

vram vram_INST(
      .reset ( reset_synchronous ),
      .clk ( clk ),
      .VRAM_ADDR ( VRAM_ADDR ),
      .VGA_RED ( VRAM_RED ),
      .VGA_GREEN ( VRAM_GREEN ),
      .VGA_BLUE ( VRAM_BLUE )
      );


endmodule
