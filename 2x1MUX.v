module MUX2x1 (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire selectionLine,
    output reg [31:0] out
);

    always @(a or b or selectionLine)
    begin
        if (selectionLine)
            out = b;
        else
            out = a;
    end

endmodule
