`timescale 1ns / 10ps

module test_uart_receiver;

reg reset;
reg clk;
reg [7:0] Rx_DATA;
reg [2:0] baud_select;
reg Rx_EN;
reg RxD;

wire Rx_PERROR;
wire Rx_FERROR;
wire Rx_VALID;

integer j;
reg [11:0] check_box;
reg [11:0] input_table1_correct;
reg [11:0] input_table2_correct;
reg [11:0] input_table1_false;
reg [11:0] input_table2_false;
reg [11:0] input_table3_false;

parameter period_of_baud_select_000 = 208333;
parameter period_of_baud_select_001 = 52083;
parameter period_of_baud_select_010 = 13021;
parameter period_of_baud_select_011 = 6510;
parameter period_of_baud_select_100 = 3255;
parameter period_of_baud_select_101 = 1628;
parameter period_of_baud_select_110 = 1085;
parameter period_of_baud_select_111 = 543;

integer errors;

uart_receiver top_module(
	.reset(reset), 
	.clk(clk), 
	.Rx_DATA(Rx_DATA), 
	.baud_select(baud_select), 
	.Rx_EN(Rx_EN), 
	.RxD(RxD),
	.Rx_FERROR(Rx_FERROR), 
	.Rx_PERROR(Rx_PERROR), 
	.Rx_VALID(Rx_VALID)
);

initial
begin
	
	clk = 0;
	#10 
	reset = 1;
	input_table1_correct = 12'b110101010100; // DATA = 10101010 PARITY = 0 VALID = 1 //
	input_table2_correct = 12'b111000110010; // DATA = 00011001 //
	input_table1_false   = 12'b110111110000; // DATA = 11111000 //
	input_table2_false   = 12'b100101010100; // DATA = 10101010 //
	input_table3_false   = 12'b001101010100; // DATA = 10101010 //
	Rx_EN = 0;
	errors = 0;
	RxD = 1;

	#180 
	reset = 0;

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 000 -----------------------------------//
//******************************************************************************************//

	baud_select = 3'b000;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_000*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 000 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_000*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 000 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of second occasion (input_table2_correct) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_000*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 000 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_000*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 000 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_000*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 000 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fifth occasion (input_table3_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of fifth occasion (input_table3_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fifth occasion (input_table3_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 000 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 001 -----------------------------------//
//******************************************************************************************//

	baud_select = 3'b001;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_001*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 001 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_001*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 001 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of second occasion (input_table2_correct) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_001*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 001 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_001*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 001 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_001*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 001 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fifth occasion (input_table3_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of fifth occasion (input_table3_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fifth occasion (input_table3_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 001 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 010 -----------------------------------//
//******************************************************************************************//

	baud_select = 3'b010;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_010*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 010 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_010*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 010 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_010*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 010 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_010*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 010 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_010*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 010 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fifth occasion (input_table3_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of fifth occasion (input_table3_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fifth occasion (input_table3_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 010 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 011 -----------------------------------//
//******************************************************************************************//

	baud_select = 3'b011;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_011*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 011 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_011*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 011 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_011*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 000 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_011*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 011 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_011*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 011 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fifth occasion (input_table3_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of fifth occasion (input_table3_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fifth occasion (input_table3_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 011 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 100 ------------------------------------//
//******************************************************************************************//

	baud_select = 3'b100;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_100*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 100 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_100*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 100 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_100*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 100 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_100*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 100 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_100*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 100 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nData of fifth occasion (input_table3_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nPERROR of fifth occasion (input_table3_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nFERROR of fifth occasion (input_table3_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 100 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 101 ------------------------------------//
//******************************************************************************************//

	baud_select = 3'b101;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_101*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 101 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_101*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 101 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_101*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 101 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_101*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 101 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 101 is not ok!\n");
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 101 is not ok!\n");
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 101 is not ok!\n");
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_101*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 101 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nData of fifth occasion (input_table3_false) for baud select 101 is not ok!\n");
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nPERROR of fifth occasion (input_table3_false) for baud select 101 is not ok!\n");
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nFERROR of fifth occasion (input_table3_false) for baud select 101 is not ok!\n");
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 101 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 110 ------------------------------------//
//******************************************************************************************//

	baud_select = 3'b110;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_110*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 110 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_110*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 110 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_110*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 110 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_110*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 110 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_110*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 110 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nData of fifth occasion (input_table3_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nPERROR of fifth occasion (input_table3_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nFERROR of fifth occasion (input_table3_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 110 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

//******************************************************************************************//
//----------------------------------- BAUD SELECT = 111 -----------------------------------//
//******************************************************************************************//

	baud_select = 3'b111;

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_111*16)
		RxD = input_table1_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nFirst occasion (input_table1_correct) for baud select 111 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of first occasion (input_table1_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of first occasion (input_table1_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of first occasion (input_table1_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: VALID of first occasion (input_table1_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_111*16)
		RxD = input_table2_correct[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b00011001 && Rx_VALID == 1 && Rx_PERROR == 0 && Rx_FERROR == 0)
	begin
		$display("\nSecond occasion (input_table2_correct) for baud select 111 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b00011001 )
		begin
			$display("\nError: Data of second occasion (input_table2_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of second occasion (input_table2_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 0 )
		begin
			$display("\nError: FERROR of second occasion (input_table2_correct) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_111*16)
		RxD = input_table1_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b11111000 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 0)
	begin
		$display("\nThird occasion (input_table1_false) for baud select 111 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b11111000 )
		begin
			$display("\nError: Data of third occasion (input_table1_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of third occasion (input_table1_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 1 )
		begin
			$display("\nError: FERROR of third occasion (input_table1_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of third occasion (input_table1_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end 

	end
	Rx_EN = 0;
	#2000

	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_111*16)
		RxD = input_table2_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 0 && Rx_FERROR == 1)
	begin
		$display("\nFourth occasion (input_table2_false) for baud select 111 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fourth occasion (input_table2_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 1 )
		begin
			$display("\nError: PERROR of fourth occasion (input_table2_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fourth occasion (input_table2_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fourth occasion (input_table2_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000


	#20 
	Rx_EN = 1;

	for( j = 0; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_111*16)
		RxD = input_table3_false[j];
		$display("Sent data %d at time %d ns", j, $time);
	end
	RxD = 1;

	#20
	if ( Rx_DATA == 8'b10101010 && Rx_VALID == 0 && Rx_PERROR == 1 && Rx_FERROR == 1)
	begin
		$display("\nFifth occasion (input_table3_false) for baud select 110 is ok!\n");
	end
	else 
	begin
		if ( Rx_DATA != 8'b10101010 )
		begin
			$display("\nError: Data of fifth occasion (input_table3_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_PERROR == 0 )
		begin
			$display("\nError: PERROR of fifth occasion (input_table3_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if ( Rx_FERROR == 0 )
		begin
			$display("\nError: FERROR of fifth occasion (input_table3_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end
		if (Rx_VALID == 1 )
		begin
			$display("\nError: VALID of fifth occasion (input_table3_false) for baud select 111 is not ok!\n");
			errors = errors + 1;
		end

	end
	Rx_EN = 0;
	#2000

	$display("Simulation finished with %d errors...\n", errors);

	#1000
	$finish;
end

always
begin

	#10 clk = ~clk;	

end

endmodule