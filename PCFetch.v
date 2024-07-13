// output is assigned to fetch the input 
//PC
module PCFetch(input wire [31:0] PC_input, output reg [31:0] PC_output, wire clk);
 
    always @(posedge clk ) begin
     
        PC_output <= PC_input;
    end
    
  endmodule
