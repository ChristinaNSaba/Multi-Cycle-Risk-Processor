`timescale 1ns / 1ps

module MemoryWithStack_TestBench;

    // Inputs
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [31:0] address;
    reg [31:0] data_in;
    reg [31:0] pc;
    reg [4:0] rd;
    reg [5:0] opcode;

    // Outputs
    wire [31:0] read_data;
    wire [31:0] sp;

    // Bidirectional Data Bus
    wire [31:0] data;
    assign data = mem_read ? read_data : 32'bz;
    assign read_data = mem_read ? data : 32'bz;

    // Instantiate the MemoryWithStack module
    MemoryWithStack uut (
        .clk(clk), 
        .mem_read(mem_read), 
        .mem_write(mem_write), 
        .address(address), 
        .data(data), 
        .pc(pc), 
        .rd(rd), 
        .opcode(opcode), 
        .read_data(read_data), 
        .sp(sp)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with a period of 10 ns
    end

    // Test cases
    initial begin
        // Initialize Inputs
        mem_read = 0;
        mem_write = 0;
        address = 0;
        data_in = 0;
        pc = 0;
        rd = 0;
        opcode = 0;

        // Test Case 1: Write to memory
        #10;
        mem_write = 1;
        address = 32'h00000004;
        data_in = 32'h12345678;
        #10;
        mem_write = 0;

        // Test Case 2: Read from memory
        #20;
        mem_read = 1;
        address = 32'h00000004;
        #10;
        mem_read = 0;

        // Test Case 3: PUSH operation
        #30;
        opcode = 6'b001111; // PUSH opcode
        data_in = 32'hAABBCCDD; // Data to push
        #10;
        opcode = 0;

        // Test Case 4: POP operation
        #40;
        opcode = 6'b010000; // POP opcode
        rd = 5'd1; // Destination register (example)
        #10;
        opcode = 0;

        // Add more test cases for different memory locations and data...

        // Complete the simulation
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, Read Data = %h, Stack Pointer = %h, Address = %h, Data = %h", 
                 $time, read_data, sp, address, data);
    end

    // Assign data_in to data bus when writing
    always @(posedge clk) begin
        if (mem_write) begin
            data <= data_in;
        end
    end

endmodule
