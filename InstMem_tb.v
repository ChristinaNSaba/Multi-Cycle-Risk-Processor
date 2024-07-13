`timescale 1ns / 1ps

module InstMem_TestBench;

    // Inputs
    reg memWrite;
    reg [31:0] address;
    reg [31:0] Data_in;

    // Output
    wire [31:0] Data_out;

    // Instantiate the InstMem module
    InstMem uut (
        .address(address),
        .memWrite(memWrite),
        .Data_in(Data_in),
        .Data_out(Data_out)
    );

    // Test cases
    initial begin
        // Initialize Inputs
        memWrite = 0;
        address = 0;
        Data_in = 0;

        // Test Case 1: Write to memory
        #10;
        memWrite = 1;
        address = 32'h00000004;
        Data_in = 32'h12345678;
        #10;
        memWrite = 0;

        // Test Case 2: Read from memory
        #20;
        address = 32'h00000004;
        #10;

        // Add more test cases as needed

        // Complete the simulation
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, Address = %h, Write Enable = %b, Data In = %h, Data Out = %h", 
                 $time, address, memWrite, Data_in, Data_out);
    end

endmodule
