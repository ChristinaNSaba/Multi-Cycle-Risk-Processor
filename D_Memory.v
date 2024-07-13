module MemoryWithStack(
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] address,
    inout wire [31:0] data,
    input wire [31:0] pc,            // Program Counter
    input wire [4:0] rd,             // Destination Register for POP
    input wire [5:0] opcode,         // Operation Code
    output reg [31:0] read_data,
    output reg [31:0] sp             // Stack Pointer
);

    // Memory array now byte-addressable
    reg [7:0] memory_array [4095:0]; // Adjusting the size for byte-addressability

    // Adjusted stack pointer initialization for byte-addressable memory
    initial begin
        sp = 10'd4095; // Initialize stack pointer to the top of byte-addressable memory
    end

    always @(posedge clk) begin
        case (opcode)
            6'b001111: begin // PUSH operation code
                // Adjusting for byte-addressable memory
                sp = sp - 4; // Decrement stack pointer by 4 to move one 'word' down
                // Writing data byte by byte
                memory_array[sp] = data[7:0];
                memory_array[sp+1] = data[15:8];
                memory_array[sp+2] = data[23:16];
                memory_array[sp+3] = data[31:24];
            end
            6'b010000: begin // POP operation code
                // Reading data byte by byte and combining into a word
                data = {memory_array[sp+3], memory_array[sp+2], memory_array[sp+1], memory_array[sp]};
                sp = sp + 4; // Increment stack pointer by 4 to move one 'word' up
            end
            // Opcode for Load Word (LW)
        6'b000101: begin // Assuming '000101' is the opcode for LW
            // Calculate address by adding base register (Rs1) and sign-extended immediate value
            // Perform the load operation
            read_data <= memory_array[{address[31:2], 2'b00} + { {14{imm16[15]}}, imm16 }]; // Address is word-aligned
        end
        
        // Opcode for Load Word and Post-Increment (LW.POI)
        6'b000110: begin // Assuming '000110' is the opcode for LW.POI
            // Calculate address, perform the load operation, and set post-increment signal
            read_data <= memory_array[{address[31:2], 2'b00} + { {14{imm16[15]}}, imm16 }]; // Address is word-aligned
            // Post-increment would be handled outside of this module, likely in the register file logic
        end
        
        // Opcode for Store Word (SW)
        6'b000111: begin // Assuming '000111' is the opcode for SW
            // Calculate address and perform the store operation
            memory_array[{address[31:2], 2'b00} + { {14{imm16[15]}}, imm16 }] <= data; // Address is word-aligned
        end
        endcase
    end

    // Logic for memory read and write, adjusted for byte-addressable memory
    always @(posedge clk) begin
        if (mem_read) begin
            // Combine bytes into a single word for reading
            read_data <= {memory_array[address+3], memory_array[address+2], memory_array[address+1], memory_array[address]};
        end
        if (mem_write) begin
            // Write data byte by byte
            memory_array[address] <= data[7:0];
            memory_array[address+1] <= data[15:8];
            memory_array[address+2] <= data[23:16];
            memory_array[address+3] <= data[31:24];
        end
    end

    // Tri-state buffer for data bus, adjusted for byte-addressable memory
    assign data = (mem_read ? read_data : 32'z);

endmodule
