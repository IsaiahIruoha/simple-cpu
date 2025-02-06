`timescale 1ns/10ps

module alu(
    input  wire         clk,         
    input  wire         clear,       
    input  wire [31:0]  A_reg,       
    input  wire [31:0]  B_reg,       
    input  wire [4:0]   opcode,      
    output reg  [63:0]  C_reg        
);
    parameter ADD  = 5'b00011,
              SUB  = 5'b00100,
              SHR  = 5'b01001, 
              SHL  = 5'b01011, 
              ROR  = 5'b00111, 
              ROL  = 5'b01000, 
              AND  = 5'b00101,
              OR   = 5'b00110,
              MUL  = 5'b10000,
              DIV  = 5'b01111,
              NEG  = 5'b10001, 
              NOT  = 5'b10010, 
              SHRA = 5'b01010; 
	
    wire [31:0] add_out,  add_carry;
    wire [31:0] sub_out,  sub_carry;
    wire [31:0] and_out,  or_out;
    wire [31:0] not_out,  neg_out;
    wire [63:0] mul_out,  div_out;
    wire [31:0] shr_out,  shra_out, shl_out, ror_out, rol_out;

    always @(*) begin
        if (clear) begin
            C_reg = 64'd0;
        end
        else begin
            C_reg = 64'd0; // Default result
		case (opcode) // Select operation based on opcode
                ADD:  begin // 32-bit add
                    C_reg[31:0]   = add_out;
                    C_reg[63:32] = 32'd0;
                end
                SUB:  begin // 32-bit subtract
                    C_reg[31:0]   = sub_out;
                    C_reg[63:32] = 32'd0;
                end
                MUL:  begin // 64-bit multiply
                    C_reg = mul_out; 
                end
                DIV:  begin // 64-bit divide
                    C_reg = div_out; 
                end
                AND:  begin // Logical AND
                    C_reg[31:0]   = and_out;
                    C_reg[63:32] = 32'd0;
                end
                OR:   begin // Logical OR
                    C_reg[31:0]   = or_out;
                    C_reg[63:32] = 32'd0;
                end
                NEG:  begin // 2's complement
                    C_reg[31:0]   = neg_out;
                    C_reg[63:32] = 32'd0;
                end
                NOT:  begin // Bitwise invert
                    C_reg[31:0]   = not_out;
                    C_reg[63:32] = 32'd0;
                end
                SHR:  begin // Shift Right (logical)
                    C_reg[31:0]   = shr_out;
                    C_reg[63:32] = 32'd0;
                end
                SHRA: begin // Shift Right (arithmetic)
                    C_reg[31:0]   = shra_out;
                    C_reg[63:32] = 32'd0;
                end
                SHL:  begin // Shift Left
                    C_reg[31:0]   = shl_out;
                    C_reg[63:32] = 32'd0;
                end
                ROR:  begin // Rotate Right
                    C_reg[31:0]   = ror_out;
                    C_reg[63:32] = 32'd0;
                end
                ROL:  begin // Rotate Left
                    C_reg[31:0]   = rol_out;
                    C_reg[63:32] = 32'd0;
                end
                default: begin // Default
                    C_reg = 64'd0;
                end
            endcase
        end
    end
  
    add_32bit   u_add   (.Ra(A_reg), .Rb(B_reg), .cin(1'b0), .sum(add_out), .cout(add_carry));
    sub_32bit   u_sub   (.Ra(A_reg), .Rb(B_reg), .sum(sub_out), .cout(sub_carry));
    mul_32bit   u_mul   (.Ra(A_reg), .Rb(B_reg), .Rz(mul_out));
    div_32bit   u_div   (.Ra(A_reg), .Rb(B_reg), .Rz(div_out));
    and_32bit   u_and   (.Ra(A_reg), .Rb(B_reg), .Rz(and_out));
    or_32bit    u_or    (.Ra(A_reg), .Rb(B_reg), .Rz(or_out));
    not_32bit   u_not   (.Ra(B_reg), .Rz(not_out));
    negate_32bit u_neg  (.Ra(B_reg), .Rz(neg_out));
    shr_32bit   u_shr   (.Ra(A_reg), .Rb(B_reg), .Rz(shr_out));
    shra_32bit  u_shra  (.Ra(A_reg), .Rb(B_reg), .Rz(shra_out));
    shl_32bit   u_shl   (.Ra(A_reg), .Rb(B_reg), .Rz(shl_out));
    ror_32bit   u_ror   (.Ra(A_reg), .Rb(B_reg), .Rz(ror_out));
    rol_32bit   u_rol   (.Ra(A_reg), .Rb(B_reg), .Rz(rol_out));

endmodule
