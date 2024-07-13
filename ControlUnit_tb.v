`timescale 1ns / 1ps

module ControlUnit_TestBench;

    // Inputs
    reg [5:0] opcode;
    reg zeroFlag;
    reg carryFlag;
    reg negFlag;
    reg [2:0] state;

    // Outputs
    wire [1:0] PC_src;
    wire ext_src;
    wire RegW1;
    wire RegW2;
    wire read;
    wire write;
    wire reg_des;
    wire ALU_src;
    wire [1:0] wb_data;
    wire j_src;
    wire [2:0] next_state;

    // Instantiate the ControlUnit module
    ControlUnit uut (
        .opcode(opcode), 
        .zeroFlag(zeroFlag), 
        .carryFlag(carryFlag), 
        .negFlag(negFlag), 
        .state(state), 
        .PC_src(PC_src), 
        .ext_src(ext_src), 
        .RegW1(RegW1), 
        .RegW2(RegW2), 
        .read(read), 
        .write(write), 
        .reg_des(reg_des), 
        .ALU_src(ALU_src), 
        .wb_data(wb_data), 
        .j_src(j_src), 
        .next_state(next_state)
    );

    // Test cases
    initial begin
        // Initialize Inputs
        opcode = 0;
        zeroFlag = 0;
        carryFlag = 0;
        negFlag = 0;
        state = 0;

        // Wait 100 ns for global reset
        #100;
        
        // Test Case: R-Type Instructions
        opcode = 6'b000000; // Example R-type opcode
        state = 3'b000; // IF_STAGE
        #10;
        state = 3'b001; // ID_STAGE
        #10;
        state = 3'b010; // EX_STAGE
        #10;
        state = 3'b100; // WB_STAGE
        #10;

        // Test Case: ADDI Instruction
        opcode = 6'b000011; // ADDI opcode
        state = 3'b000; // IF_STAGE
        #10;
        state = 3'b001; // ID_STAGE
        #10;
        state = 3'b010; // EX_STAGE
        #10;
        state = 3'b100; // WB_STAGE
        #10;

        // Test Case: Branch Instruction - BEQ with zeroFlag
        opcode = 6'b001010; // BEQ opcode
        zeroFlag = 1; // Set zeroFlag
        state = 3'b000; // IF_STAGE
        #10;
        state = 3'b001; // ID_STAGE
        #10;
        state = 3'b010; // EX_STAGE
        #10;
        state = 3'b100; // WB_STAGE
        #10;

        // Test Case: Load Word (LW)
        opcode = 6'b000101; // LW opcode
        state = 3'b000; // IF_STAGE
        #10;
        state = 3'b001; // ID_STAGE
        #10;
        state = 3'b010; // EX_STAGE
        #10;
        state = 3'b011; // MEM_STAGE
        #10;
        state = 3'b100; // WB_STAGE
        #10;

        // Test Case: Jump (JMP)
        opcode = 6'b001100; // JMP opcode
        state = 3'b000; // IF_STAGE
        #10;
        state = 3'b001; // ID_STAGE
        #10;

        // Add additional test cases as needed

        // Complete the simulation
        $finish;
    end

    // Monitor changes
    initial begin
       
            // Additional Test Cases:

    // Test Case: Store Word (SW)
    opcode = 6'b000111; // SW opcode
    state = 3'b000; // IF_STAGE
    #10;
    state = 3'b001; // ID_STAGE
    #10;
    state = 3'b010; // EX_STAGE
    #10;
    state = 3'b011; // MEM_STAGE
    #10;

    // Test Case: Branch Instruction - BNE with zeroFlag not set
    opcode = 6'b001011; // BNE opcode
    zeroFlag = 0; // Reset zeroFlag
    state = 3'b000; // IF_STAGE
    #10;
    state = 3'b001; // ID_STAGE
    #10;
    state = 3'b010; // EX_STAGE
    #10;

    // Test Case: Branch Instruction - BLT with negFlag set
    opcode = 6'b001001; // BLT opcode
    negFlag = 1; // Set negFlag
    state = 3'b000; // IF_STAGE
    #10;
    state = 3'b001; // ID_STAGE
    #10;
    state = 3'b010; // EX_STAGE
    #10;

    // Test Case: Return (RET)
    opcode = 6'b001110; // RET opcode
    state = 3'b000; // IF_STAGE
    #10;
    state = 3'b001; // ID_STAGE
    #10;

    // Test Case: Pop (POP)
    opcode = 6'b010000; // POP opcode
    state = 3'b000; // IF_STAGE
    #10;
    state = 3'b001; // ID_STAGE
    #10;
    state = 3'b010; // EX_STAGE
    #10;
    state = 3'b100; // WB_STAGE
    #10;

    // Add additional specific test cases to cover all opcodes and scenarios

    // Complete the simulation
    $finish;
    end

 $monitor("Time = %t, Opcode = %b, ZeroFlag = %b, CarryFlag = %b, NegFlag = %b, State = %b, PC_src = %b, Ext_src = %b, RegW1 = %b, RegW2 = %b, Read = %b, Write = %b, Reg_des = %b, ALU_src = %b, Wb_data = %b, J_src = %b, Next_state = %b", 
                 $time, opcode, zeroFlag, carryFlag, negFlag, state, PC_src, ext_src, RegW1, RegW2, read, write,
                reg_des, ALU_src, wb_data, j_src, next_state);
end

endmodule
