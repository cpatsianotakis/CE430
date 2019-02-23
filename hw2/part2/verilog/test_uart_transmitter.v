`timescale 1ns / 10ps


module test_uart_transmitter;

reg reset;
reg clk;
reg [7:0] Tx_DATA;
reg [2:0] baud_select;
reg Tx_WR;
reg Tx_EN;

wire TxD;
wire Tx_BUSY;

integer j;
reg [11:0] check_box;

integer errors;

parameter period_of_baud_select_000 = 208333;
parameter period_of_baud_select_001 = 52083;
parameter period_of_baud_select_010 = 13021;
parameter period_of_baud_select_011 = 6510;
parameter period_of_baud_select_100 = 3255;
parameter period_of_baud_select_101 = 1628;
parameter period_of_baud_select_110 = 1085;
parameter period_of_baud_select_111 = 543;

uart_transmitter top_module(
	.reset (reset), 
	.clk (clk), 
	.Tx_DATA (Tx_DATA), 
	.baud_select (baud_select), 
	.Tx_WR (Tx_WR), 
	.Tx_EN (Tx_EN), 
	.TxD (TxD), 
	.Tx_BUSY (Tx_BUSY)
);

initial
begin
	
	clk = 0;
	#10 
	reset = 1;
	Tx_DATA = 8'b10101010;
	Tx_EN = 0;
	Tx_WR = 0;
	errors = 0;

	#180 
	reset = 0;

//-------------------- BAUD SELECT = 000 --------------------//
	baud_select = 3'b000;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Move 1 period for STATE_IDLE //
	while( top_module.sample_send == 0 )
	begin
		#20
		Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20
		Tx_WR = 0;
	end

	#(period_of_baud_select_000*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_000*8)
	check_box[0] = TxD;
	$display("Taken check_box %d at time %d", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_000*16)
		check_box[j] = TxD;
		$display("Taken check_box %d at time %d", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 000!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 000");
		$display("Check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:     110101010100\n");
		errors = errors + 1;
	end

//-------------------- BAUD SELECT = 001 --------------------//
	baud_select = baud_select + 1;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Move 1 period for STATE_IDLE //
	while( top_module.sample_send == 0 )
	begin
		#20
		Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20
		Tx_WR = 0;
	end

	#(period_of_baud_select_001*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_001*8)
	check_box[0] = TxD;
	$display("Taken check_box %d at time %d ns", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_001*16)
		check_box[j] = TxD;
		$display("Taken check_box %d at time %d ns", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 001!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 001");
		$display("check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:    110101010100\n");
		errors = errors + 1;
	end


//-------------------- BAUD SELECT = 010 --------------------//
	baud_select = baud_select + 1;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Move 1 period for STATE_IDLE //
	while( top_module.sample_send == 0 )
	begin
		#20
		Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20
		Tx_WR = 0;
	end

	#(period_of_baud_select_010*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_010*8)
	check_box[0] = TxD;
	$display("Taken check_box %d at time %d ns", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_010*16)
		check_box[j] = TxD;
		$display("Taken check_box %d at time %d ns", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 010!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 010");
		$display("check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:    110101010100\n");
		errors = errors + 1;
	end


//-------------------- BAUD SELECT = 011 --------------------//
	baud_select = baud_select + 1;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Move 1 period for STATE_IDLE //
	while( top_module.sample_send == 0 )
	begin
		#20
		Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20
		Tx_WR = 0;
	end

	#(period_of_baud_select_011*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_011*8)
	check_box[0] = TxD;
	$display("Taken check_box %d at time %d ns", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_011*16)
		check_box[j] = TxD;
		$display("Taken check_box %d at time %d ns", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 011!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 011");
		$display("check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:    110101010100\n");
		errors = errors + 1;
	end


//-------------------- BAUD SELECT = 100 --------------------//
	baud_select = baud_select + 1;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Move 1 period for STATE_IDLE //
	while( top_module.sample_send == 0 )
	begin
		#20
		Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20
		Tx_WR = 0;
	end

	#(period_of_baud_select_100*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_100*8)
	check_box[0] = TxD;
	$display("Taken check_box[%d] at time %d ns", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_100*16)
		check_box[j] = TxD;
		$display("Taken check_box[%d] at time %d ns", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 100!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 100");
		$display("check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:    110101010100\n");
		errors = errors + 1;
	end

//-------------------- BAUD SELECT = 101 --------------------//
	baud_select = baud_select + 1;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Move 1 period for STATE_IDLE //
	while( top_module.sample_send == 0 )
	begin
		#20
		Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20
		Tx_WR = 0;
	end

	#(period_of_baud_select_101*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_101*8)
	check_box[0] = TxD;
	$display("Taken check_box %d at time %d ns", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_101*16)
		check_box[j] = TxD;
		$display("Taken check_box %d at time %d ns", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 101!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 101");
		$display("check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:    110101010100\n");
		errors = errors + 1;
	end

//-------------------- BAUD SELECT = 110 --------------------//
	baud_select = baud_select + 1;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Move 1 period for STATE_IDLE //
	while( top_module.sample_send == 0 )
	begin
		#20
		Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20
		Tx_WR = 0;
	end

	#(period_of_baud_select_110*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_110*8)
	check_box[0] = TxD;
	$display("Taken check_box %d at time %d ns", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_110*16)
		check_box[j] = TxD;
		$display("Taken check_box %d at time %d ns", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 110!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 110");
		$display("check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:    110101010100\n");
		errors = errors + 1;
	end


//-------------------- BAUD SELECT = 111 --------------------//
	baud_select = baud_select + 1;

	#20 
	Tx_WR = 1;
	Tx_EN = 1;

	#20
	Tx_WR = 0;

	#3000
	Tx_EN = 0;

	#960
	Tx_WR = 1;
	Tx_EN = 1;

	// Wait untill IDLE begins //
	while( top_module.sample_send == 0 )
	begin
		#20 Tx_WR = 0;
	end
	$display("Sample detected here! %d ns", $time);

	if ( Tx_WR == 1 )
	begin
		#20 Tx_WR = 0;
	end

	#(period_of_baud_select_111*16)
	j = 0;

	// Set sample pointer at the middle of signal //
	#(period_of_baud_select_111*8)
	check_box[0] = TxD;
	$display("Taken check_box %d at time %d ns", 0, $time);

	// As sample pointer is at middle of signal, move it one period each time //
	for( j = 1; j < 12; j = j + 1)
	begin
		#(period_of_baud_select_111*16)
		check_box[j] = TxD;
		$display("Taken check_box %d at time %d ns", j, $time);
	end

	Tx_EN = 0;
	#2000

	if ( check_box == 12'b110101010100)
		$display("\nSystem worked ok for baud select 111!\n");
	else 
	begin
		$display("\nError: System did not work ok for baud select 111");
		$display("Check_box is %d%d%d%d%d%d%d%d%d%d%d%d", check_box[11], check_box[10], check_box[9], check_box[8], check_box[7], check_box[6], check_box[5], check_box[4], check_box[3], check_box[2], check_box[1], check_box[0]);
		$display("Should be:     110101010100\n");
		errors = errors + 1;
	end


	$display("Simulation finished with %d errors...", errors);
	#1000
	$finish;
end

always
begin

	#10 clk = ~clk;	

end

endmodule