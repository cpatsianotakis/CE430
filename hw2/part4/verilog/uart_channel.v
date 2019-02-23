module uart_channel(
	reset_u,
	clk,
	baud_0_u,
	baud_1_u,
	baud_2_u,
	monitor_an3,
	monitor_an2,
	monitor_an1,
	monitor_an0,
	monitor_a,
	monitor_b,
	monitor_c,
	monitor_d,
	monitor_e,
	monitor_f,
	monitor_g,
	monitor_dp
);

input reset_u;
input clk;
input baud_0_u;
input baud_1_u;
input baud_2_u;

output monitor_an3;
output monitor_an2;
output monitor_an1;
output monitor_an0;
output monitor_a;
output monitor_b;
output monitor_c;
output monitor_d;
output monitor_e;
output monitor_f;
output monitor_g;
output monitor_dp;

wire reset;
wire [2:0] baud;

wire data_channel;

inputProtection protectReset(
	.clk ( clk ),
	.inputFromButton ( reset_u ),
	.inputToCricuit ( reset )
);

inputProtection protectBaud0(
	.clk ( clk ),
	.inputFromButton ( baud_0_u ),
	.inputToCricuit ( baud[0] )
);

inputProtection protectBaud1(
	.clk ( clk ),
	.inputFromButton ( baud_1_u ),
	.inputToCricuit ( baud[1] )
);

inputProtection protectBaud2(
	.clk ( clk ),
	.inputFromButton ( baud_2_u ),
	.inputToCricuit ( baud[2] )
);

uart_transmitter_controller transmitter_controller_INSTANCE(
	.reset (reset),
	.clk (clk),
	.baud_select (baud),
	.TxD (data_channel)
);

uart_receiver_controller receiver_controller_INSTANCE(
	.reset (reset),
	.clk (clk),
	.baud_select (baud),
	.RxD (data_channel),
	.monitor_an3 (monitor_an3),
	.monitor_an2 (monitor_an2),
	.monitor_an1 (monitor_an1),
	.monitor_an0 (monitor_an0),
	.monitor_a (monitor_a),
	.monitor_b (monitor_b),
	.monitor_c (monitor_c),
	.monitor_d (monitor_d),
	.monitor_e (monitor_e),
	.monitor_f (monitor_f),
	.monitor_g (monitor_g),
	.monitor_dp (monitor_dp)
);



endmodule