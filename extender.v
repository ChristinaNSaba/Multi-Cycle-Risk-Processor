module sign_extender (
    input [31:0] in,
    input extSrc, 
    output reg [31:0] out
);
    integer i;
    integer j = 16;

    always @(*)
    begin
        for(i = 0; i < j; i = i + 1)
        begin
            out[i] = in[i];
        end

        if (extSrc)
        begin
            for(i = j; i < 32; i = i + 1)   // signed extension
            begin
                out[i] = in[j-1];
            end
        end
        else
        begin
            for(i = j; i < 32; i = i + 1)  // unsigned extension 
            begin
                out[i] = 1'b0;
            end
        end
    end
endmodule
