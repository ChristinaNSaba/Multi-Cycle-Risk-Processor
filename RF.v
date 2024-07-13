module RF(
    input wire clk, reg_write1, reg_write2,
    input [3:0] Rs1, Rs2, Rd,
    input [31:0] Bus_W,	Bus_W1,
    output wire [31:0] Bus_A, Bus_B
);		

reg [31:0] register_file [0:15]; // 16 registers, each 32 bits wide	 
integer i=0;
    
initial
    begin
		for(i=0;i<32; i=i+1)
			register_file[i]=0;	
	end

    // Write operation (on rising edge of clk)
    always @(posedge clk) begin
        if (reg_write1 && Rd != 4'b0) begin // write to Rd 
            register_file[Rd] <= Bus_W;
        end	 
		else if (reg_write2 && Rs1 != 4'b0) begin // write to Rs1 if LW.POI
            register_file[Rs1] <= Bus_W1;
        end
    end

    // Read operation (asynchronous)
	assign Bus_A = (Rs1 != 4'b0) ? register_file[Rs1] : 32'b0;
	assign Bus_B = (Rs2 != 4'b0) ? register_file[Rs2] : 32'b0;


endmodule