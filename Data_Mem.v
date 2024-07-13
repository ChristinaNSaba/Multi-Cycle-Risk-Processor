module DataMemStack(
    input wire memRead, memWrite, clk,
    input [31:0] address, data, //data = Rd
    input wire [31:0] PC,
    input wire [31:0] Rs1,
    input wire [5:0] opcode,
    output reg [31:0] Data_out,
    output reg [31:0] stackOut,
    output reg [31:0] addRs1
);

    reg [7:0] memory_array [1023:0];
    reg [31:0] sp;
    reg [31:0] newPC;

    initial begin
        sp = 10'd1023;
    end

    always @(posedge clk) begin
        case (opcode)
            6'b001111: begin // PUSH operation code
                sp = sp - 4;
                memory_array[sp] = data[7:0];
                memory_array[sp+1] = data[15:8];
                memory_array[sp+2] = data[23:16];
                memory_array[sp+3] = data[31:24];
            end
            6'b010000: begin // POP operation code
                Data_out = {memory_array[sp+3], memory_array[sp+2], memory_array[sp+1], memory_array[sp]};
                sp = sp + 4;
            end
            6'b001101: begin // CALL
                sp = sp - 4;
                newPC = PC + 1;
                memory_array[sp]   = newPC[7:0];
                memory_array[sp+1] = newPC[15:8];
                memory_array[sp+2] = newPC[23:16];
                memory_array[sp+3] = newPC[31:24];
            end
            6'b000101: begin // LW
                if (memRead) begin
                    Data_out = {memory_array[address+3], memory_array[address+2], memory_array[address+1], memory_array[address]};
                end
            end
            6'b000110: begin // LW.POI
                if (memRead) begin
                    Data_out = {memory_array[address+3], memory_array[address+2], memory_array[address+1], memory_array[address]};
                    addRs1 = Rs1 + 1;
                end
            end
            6'b000111: begin // SW
                if (memWrite) begin
                    memory_array[address]   = data[7:0];
                    memory_array[address+1] = data[15:8];
                    memory_array[address+2] = data[23:16];
                    memory_array[address+3] = data[31:24];
                end
            end
            6'b001110: begin // RET
                stackOut = {memory_array[sp+3], memory_array[sp+2], memory_array[sp+1], memory_array[sp]};
                sp = sp + 4;
            end
        endcase
    end

    assign Dout = (memRead) ? {memory_array[address+3], memory_array[address+2], memory_array[address+1], memory_array[address]} : 32'hzzzzzzzz;

endmodule
