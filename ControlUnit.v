module ControlUnit(
    input [5:0] opcode,
    input zeroFlag,
    input carryFlag,
    input negFlag,
    input [2:0] state,
    input [1:0] mode,
    output reg [1:0] PC_src = 2'b00,
    output reg ext_src = 0,
    output reg RegW1 = 0,
    output reg RegW2 = 0,
    output reg read = 0,
    output reg write = 0,
    output reg reg_des = 0,
    output reg ALU_src = 0,
    output reg [1:0] wb_data = 2'b00,
    output reg j_src = 0,
    output reg [2:0] next_state = 3'b000
);

    parameter IF_STAGE = 3'b000;
    parameter ID_STAGE = 3'b001;
    parameter EX_STAGE = 3'b010;
    parameter MEM_STAGE = 3'b011;
    parameter WB_STAGE = 3'b100;

    always @(state) begin
        case (state)
            IF_STAGE: begin
                next_state = ID_STAGE;
            end
            ID_STAGE: begin
                if (opcode == 6'b001100)  begin
                    next_state = IF_STAGE;
                end
                else
                    next_state = EX_STAGE;
            end
            EX_STAGE: begin
                if (opcode == 6'b000000 || opcode == 6'b000001 || opcode == 6'b000010 || opcode == 6'b000011 || opcode == 6'b000100)    
                    next_state = WB_STAGE;
                else if (opcode == 6'b000101 || opcode == 6'b000110 || opcode == 6'b000111 || opcode == 6'b001101 || opcode == 6'b001110 || opcode == 6'b001111)  
                    next_state = MEM_STAGE;
                else 
                    next_state = IF_STAGE;
            end
            MEM_STAGE: begin
                if (opcode == 6'b000101 || opcode == 6'b000110 || opcode == 6'b010000)
                    next_state = WB_STAGE;     
                else 
                    next_state = IF_STAGE;
            end
            WB_STAGE: begin
                next_state = IF_STAGE;
            end
        endcase
    end

    always @* begin
        case (opcode)
            6'b000000, 6'b000001, 6'b000010: begin //R_type
                reg_des <= 2'b00;
                ALU_src <= 1;
                wb_data <= 2'b00;
            end
            6'b000011, 6'b000100: begin //ADDI ANDI
                reg_des <= 2'b01;
                ALU_src <= 1;
                ext_src <= 1; 
                wb_data <= 2'b00;
            end
            6'b000101: begin // LW--> write to Rd
                reg_des <= 2'b01;
                ALU_src <= 1;
                ext_src <= 1; 
                wb_data <= 2'b01;
                read <= 1; 
                write <= 0; 
                if (next_state == WB_STAGE) begin
                    RegW1 <= 1;
                end
            end
            6'b000110: begin //LWPOI
                reg_des <= 2'b01;
                ALU_src <= 1;
                ext_src <= 1; 
                wb_data <= 2'b01; 
                read <= 1; 
                write <= 1; 
                if (next_state == WB_STAGE) begin
                    RegW1 <= 1;     
                    RegW2 <= 1;
                end
            end
            6'b000111: begin //SW
                reg_des <= 2'b01;
                ALU_src <= 1;
                ext_src <= 1; 
                RegW1 <= 0;     
                RegW2 <= 0;
                read <= 0; 
                if (next_state == MEM_STAGE) begin
                    write <= 1; 
                end    
            end
            6'b001000, 6'b001001, 6'b001010, 6'b001011: begin //Branch
                reg_des <= 2'b01;
                ALU_src <= 1;
                ext_src <= 1;
                read <= 0;
                write <= 0;
                RegW1 <= 0;
                RegW2 <= 0;
            end
            6'b001100: begin // JMP
                j_src <= 1;
            end
            6'b001110: begin // RET
                j_src <= 0;
            end
            6'b010000: begin //POP
                wb_data <= 2'b10;
                if (next_state == WB_STAGE)  begin
                    RegW1 <= 1;
                end
            end
            default: begin
                // Handle other opcodes or set default values
            end
        endcase
    end

    always @* begin
        if (next_state == IF_STAGE) begin
            case (opcode)
                6'b001100, 6'b001101, 6'b001110: begin // JMP RET CALL
                    PC_src <= 2'b01;
                end
                6'b001000: begin //BGT 
                    if (carryFlag == 0) begin
                        PC_src <= 2'b10;
                    end
                    else begin
                        PC_src <= 2'b00;
                    end
                end
                6'b001001: begin //BLT
                    if (negFlag == 1) begin
                        PC_src <= 2'b10;
                    end
                    else begin
                        PC_src <= 2'b00;
                    end
                end
                6'b001010: begin //BEQ
                    if (zeroFlag == 1) begin
                        PC_src <= 2'b10;
                    end
                    else begin
                        PC_src <= 2'b00;
                    end
                end
                6'b001011: begin //BNE
                    if (zeroFlag == 0) begin
                        PC_src <= 2'b10;
                    end
                    else begin
                        PC_src <= 2'b00;
                    end
                end
                default: begin
                    // Handle other opcodes or set default values
                    PC_src <= 2'b00;
                end
            endcase
        end
    end
endmodule
