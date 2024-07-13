module Adder(	 
	
	input [32-1:0] input1, input2,
	output reg [32-1:0] finalOutput
	
	
	);
	
	assign finalOutput = input1 + input2;
	endmodule