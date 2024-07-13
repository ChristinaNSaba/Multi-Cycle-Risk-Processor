module _4x1MUX (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [1:0] selectionLine,
    output reg [31:0] out
);

    always @(a or b or c or selectionLine)
    begin
        case (selectionLine)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            
        endcase;
    end

endmodule
