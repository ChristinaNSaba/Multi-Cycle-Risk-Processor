`timescale 1ns / 1ps

module ALU_TestBench;

    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg [5:0] opcode;

    // Outputs
    wire [31:0] result;
    wire carry;
    wire zero;
    wire negative;
    wire overflow;

    // Instantiate the ALU module
    ALU uut (
        .A(A), 
        .B(B), 
        .opcode(opcode), 
        .result(result), 
        .carry(carry), 
        .zero(zero), 
        .negative(negative), 
        .overflow(overflow)
    );

    // Test cases
    initial begin
        // Initialize Inputs
        A = 0;
        B = 0;
        opcode = 0;

        // Wait 100 ns for global reset
        #100;

        // Test Case 1: ADD
        A = 32'h00000001;
        B = 32'h00000001;
        opcode = 6'b000001;
        #10;

        // Test Case 2: SUB
        A = 32'h00000003;
        B = 32'h00000001;
        opcode = 6'b000010;
        #10;

        // Test Case 3: AND
        A = 32'h0000FFFF;
        B = 32'h00FF00FF;
        opcode = 6'b000000;
        #10;

        // Test Case 4: ADDI
        A = 32'h00000001;
        B = 32'h00000002;
        opcode = 6'b000100;
        #10;

        // Test Case 5: BGT (Greater than)
        A = 32'h00000005;
        B = 32'h00000003;
        opcode = 6'b001000;
        #10;

        // Test Case 6: BLT (Less than)
        A = 32'h00000002;
        B = 32'h00000004;
        opcode = 6'b001001;
        #10;

        // Test Case 7: BEQ (Equal)
        A = 32'h00000005;
        B = 32'h00000005;
        opcode = 6'b001010;
        #10;

        // Test Case 8: BNE (Not Equal)
        A = 32'h00000005;
        B = 32'h00000003;
        opcode = 6'b001011;
        #10;

        // Test Case 9: Overflow in ADD
        A = 32'h7FFFFFFF;
        B = 32'h00000001;
        opcode = 6'b000001;
        #10;

        // Test Case 10: Negative Result in SUB
        A = 32'h00000001;
        B = 32'h00000002;
        opcode = 6'b000010;
        #10;

        // Test Case 11: Zero Result
        A = 32'h00000002;
        B = 32'h00000002;
        opcode = 6'b000010;
        #10;

        // Add additional test cases as needed

        // Complete the simulation
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, A = %h, B = %h, Opcode = %b, Result = %h, Carry = %b, Zero = %b, Negative = %b, Overflow = %b", 
                 $time, A, B, opcode, result, carry, zero, negative, overflow);
    end

endmodule
