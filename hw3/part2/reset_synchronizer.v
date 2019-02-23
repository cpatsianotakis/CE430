module reset_synchronizer(
	reset_button,
	clk,
	reset_synchronized
	);

input reset_button;
input clk;
output reg reset_synchronized;

reg reset_metastabilitied;

wire metastabily_wire;

always @(posedge clk ) 
begin

	reset_metastabilitied = reset_button;

end

assign metastabily_wire = reset_metastabilitied ;

always @(posedge clk ) 
begin

	reset_synchronized = metastabily_wire;

end

endmodule