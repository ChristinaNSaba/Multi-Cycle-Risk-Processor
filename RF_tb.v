`timescale 1ns / 1ps

module RF_TestBench;

    // Inputs
    reg clk;
    reg reg_write1;
    reg reg_write2;
    reg [3:0] Rs1;
    reg [3:0] Rs2;
    reg [3:0] Rd;
    reg [31:0] Bus_W;
    reg [31:0] Bus_W1;

    // Outputs
    wire [31:0] Bus_A;
    wire [31:0] Bus_B;

    // Instantiate the RF module
    RF uut (
        .clk(clk), 
        .reg_write1(reg_write1),
        .reg_write2(reg_write2),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .Rd(Rd),
        .Bus_W(Bus_W),
        .Bus_W1(Bus_W1),
        .Bus_A(Bus_A),
        .Bus_B(Bus_B)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Generate a clock with a period of 20 ns
    end

    // Test cases
    initial begin
        // Initialize Inputs
        reg_write1 = 0;
        reg_write2 = 0;
        Rs1 = 0;
        Rs2 = 0;
        Rd = 0;
        Bus_W = 0;
        Bus_W1 = 0;

        // Test Case 1: Write to register and read back
        #20;
        reg_write1 = 1;
        Rd = 4'b0001;
        Bus_W = 32'h12345678;
        #20;
        reg_write1 = 0;

        // Test Case 2: Read from two registers simultaneously
        #40;
        Rs1 = 4'b0001;
        Rs2 = 4'b0010; // Assuming register 2 has some data

        // Add more test cases as needed

        // Complete the simulation
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, Reg_Write1 = %b, Reg_Write2 = %b, Rs1 = %d, Rs2 = %d, Rd = %d, Bus_W = %h, Bus_W1 = %h, Bus_A = %h, Bus_B = %h", 
                 $time, reg_write1, reg_write2, Rs1, Rs2, Rd, Bus_W, Bus_W1, Bus_A, Bus_B);
    end

endmodule
