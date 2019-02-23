/*	uart_receiver module
*
*	University of Thessaly 
*	Electrical and Computer Engineering Department
*	CE430 Course
*
*	Patsianotakis Charalampos cpatsianotakis@uth.gr
*
*	Gets the message from uart_receiver and displayes it at 4-Digit LED monitor
*/

module uart_receiver_controller(
	reset,
	clk,
	baud_select,
	RxD,
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

input reset;
input clk;
input [2:0] baud_select;
input RxD;

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

reg Rx_EN;
wire [7:0] Rx_DATA;
wire Rx_VALID;
wire Rx_PERROR;

reg flag;
reg valid_data_to_monitor;
reg [7:0] message_to_monitor;

always @(posedge clk or posedge reset) 
begin
	if ( reset ) 
	begin
		Rx_EN = 1;
		flag = 0;
		valid_data_to_monitor = 0;
		message_to_monitor = 8'b1111_1111;
	end

	else 
	if ( Rx_VALID == 1 ) 
	begin
		if ( flag == 0 )
		begin
			flag = 1;
			message_to_monitor = Rx_DATA;
			valid_data_to_monitor = 1;
		end
		else 
		begin
			valid_data_to_monitor = 0;
		end
	end
	else 
	begin
		flag = 0;
	end
end

uart_receiver uart_receiver_INSTANCE(
	.reset ( reset ), 
	.clk ( clk ), 
	.Rx_DATA ( Rx_DATA ), 
	.baud_select ( baud_select ), 
	.Rx_EN ( Rx_EN ),
	.RxD ( RxD ),
	.Rx_FERROR ( Rx_FERROR ), 
	.Rx_PERROR ( Rx_PERROR ), 
	.Rx_VALID ( Rx_VALID )
);

FourDigitLEDdriver FourDigitLEDdriver_INSTANCE(
	.reset(reset),
	.clk ( clk),
	.new_message ( message_to_monitor ),
	.valid_message (valid_data_to_monitor),
	.an3 ( monitor_an3),
	.an2 ( monitor_an2),
	.an1 ( monitor_an1),
	.an0 ( monitor_an0),
	.a   ( monitor_a),
	.b   ( monitor_b),
	.c   ( monitor_c),
	.d   ( monitor_d),
	.e   ( monitor_e),
	.f   ( monitor_f),
	.g   ( monitor_g),
	.dp  ( monitor_dp)
);

endmodule