module InstMem(address, memWrite, Data_in, Data_out);  
	input wire memWrite = 0;
	input [31:0] address, Data_in;
	output wire [31:0] Data_out;	 
	
	integer i=0;
	reg [7:0] MEM_Inst [1023:0]; 
	
	initial
		begin
		for(i=0; i < 1024; i=i+1)
			MEM_Inst[i] = 0;	
		end	
	
	always @(*) begin
	    if (memWrite)
		begin
	    MEM_Inst[address] <= Data_in[7:0];
	    MEM_Inst[address+1] <= Data_in[15:8];
	    MEM_Inst[address+2] <= Data_in[23:16];
	    MEM_Inst[address+3] <= Data_in[31:24];
  	end
end
	
   	assign Data_out = {MEM_Inst[address+3],MEM_Inst[address+2],MEM_Inst[address+1],MEM_Inst[address]};
		 
endmodule