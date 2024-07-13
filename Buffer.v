module Buffer (
    input wire [31:0] DataIn,
    output reg [31:0] DataOut,	
	input wire clk,
	input wire reset
);

always @(posedge clk or posedge reset)
	begin
        if (reset) begin
            // Reset the buffer
            DataOut <= 32'b0;
        end 
	    else begin
            // Store the input
            DataOut <= DataIn;
        end
    end

endmodule