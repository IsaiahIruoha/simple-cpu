module alu(
    input  wire         clk,
    input  wire         clear,
    input  wire [31:0]  A_reg,      // Operand A
    input  wire [31:0]  B_reg,      // Operand B
    input  wire [4:0]   opcode,     // Operation code
    output reg  [63:0]  C_reg       // ALU result 
);

    parameter ADD  = 5'b00011,
              SUB  = 5'b00100,
              SHR  = 5'b01001, // Logical Shift Right
              SHL  = 5'b01011, // Shift Left
				  ROR  = 5'b00111, // Rotate Right
              ROL  = 5'b01000, // Rotate Left
              AND  = 5'b00101,
              OR   = 5'b00110,
              MUL  = 5'b10000,
              DIV  = 5'b01111,
              NEG  = 5'b10001, // 2’s complement
              NOT  = 5'b10010, // bitwise invert
              SHRA = 5'b01010; // Arithmetic Shift Right

  
    // Stage 1 registers: holds inputs from the outside
  
    reg [31:0] stage1_A, stage1_B;
    reg [4:0]  stage1_opcode;

    // Stage 2 register: holds the "Execute" result
    reg [63:0] stage2_result;

    // 3) Wires: Outputs of Combinational Submodules

    wire [31:0] add_out, sub_out, add_carry, sub_carry;
    wire [31:0] and_out, or_out;
    wire [31:0] not_out, neg_out;
    wire [63:0] mul_out, div_out;
    wire [31:0] shr_out, shra_out, shl_out, ror_out, rol_out;


    // 4) Stage 1 (Fetch/Decode): Latch inputs

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            stage1_A      <= 32'd0;
            stage1_B      <= 32'd0;
            stage1_opcode <= 5'd0;
        end
        else begin
            stage1_A      <= A_reg;
            stage1_B      <= B_reg;
            stage1_opcode <= opcode;
        end
    end
  
    // 5) Stage 2 (Execute): Perform selected ALU operation

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            stage2_result <= 64'd0;
        end 
        else begin
            case (stage1_opcode)
                ADD:  stage2_result <= {32'd0, add_out};
                SUB:  stage2_result <= {32'd0, sub_out};
                MUL:  stage2_result <= mul_out;
                DIV:  stage2_result <= div_out;
                AND:  stage2_result <= {32'd0, and_out};
                OR:   stage2_result <= {32'd0, or_out};
                NEG:  stage2_result <= {32'd0, neg_out};
                NOT:  stage2_result <= {32'd0, not_out};
                SHR:  stage2_result <= {32'd0, shr_out};
                SHRA: stage2_result <= {32'd0, shra_out};
                SHL:  stage2_result <= {32'd0, shl_out};
					 ROR:  stage2_result <= {32'd0, ror_out};
                ROL:  stage2_result <= {32'd0, rol_out};

                default: stage2_result <= 64'd0;
            endcase
        end
    end

    // 6) Stage 3 (Write Back): Latch result into output register

    always @(posedge clk or posedge clear) begin
        if (clear)
            C_reg <= 64'd0;
        else
            C_reg <= stage2_result;
    end


    // 7) Instantiate the Combinational Submodules
    //    (driven by stage1_A and stage1_B)
  
    add_32bit   u_add   (.Ra(stage1_A), .Rb(stage1_B), .cin({1'd0}), .sum(add_out), .cout(add_carry));
    sub_32bit   u_sub   (.Ra(stage1_A), .Rb(stage1_B), .sum(sub_out), .cout(sub_carry));
    mul_32bit   u_mul   (.Ra(stage1_A), .Rb(stage1_B), .Rz(mul_out));
    div_32bit   u_div   (.Ra(stage1_A), .Rb(stage1_B), .Rz(div_out));
    and_32bit   u_and   (.Ra(stage1_A), .Rb(stage1_B), .Rz(and_out));
    or_32bit    u_or    (.Ra(stage1_A), .Rb(stage1_B), .Rz(or_out));
    not_32bit   u_not   (.Ra(stage1_B), .Rz(not_out));
    negate_32bit u_neg  (.Ra(stage1_B), .Rz(neg_out));
    shr_32bit   u_shr   (.Ra(stage1_A), .Rb(stage1_B), .Rz(shr_out));
    shra_32bit  u_shra  (.Ra(stage1_A), .Rb(stage1_B), .Rz(shra_out));
    shl_32bit   u_shl   (.Ra(stage1_A), .Rb(stage1_B), .Rz(shl_out));
	 ror_32bit   u_ror   (.Ra(stage1_A), .Rb(stage1_B), .Rz(ror_out));
    rol_32bit   u_rol   (.Ra(stage1_A), .Rb(stage1_B), .Rz(rol_out));

endmodule
