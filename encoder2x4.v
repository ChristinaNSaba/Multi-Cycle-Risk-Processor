module encoder2x4(
    input [1:0] in,  // 2-bit input
    output reg [3:0] out // 4-bit output
);

always @(*) begin
    case(in)
        2'b00: out = 4'b0001; // Output is 1 when input is 00
        2'b01: out = 4'b0010; // Output is 2 when input is 01
        2'b10: out = 4'b0100; // Output is 4 when input is 10
        2'b11: out = 4'b1000; // Output is 8 when input is 11
        default: out = 4'b0000; // Default case to handle undefined inputs
    endcase
end

endmodule
