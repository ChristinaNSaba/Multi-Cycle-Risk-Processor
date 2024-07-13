module Adder_4(	 
	
	input [32-1:0] input1,
	output reg [32-1:0] finalOutput
	
	
	);
	
	assign finalOutput = input1 + 4;
	endmodule