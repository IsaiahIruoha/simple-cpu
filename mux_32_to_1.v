// 32-1 MUX used for bus

module mux_32_to_1( 

  // 16 General Purpose Registers 
  input [31:0] BusMuxIn_R0,
	input [31:0] BusMuxIn_R1,
	input [31:0] BusMuxIn_R2,
	input [31:0] BusMuxIn_R3, 
	input [31:0] BusMuxIn_R4,
	input [31:0] BusMuxIn_R5,
	input [31:0] BusMuxIn_R6,
	input [31:0] BusMuxIn_R7,
	input [31:0] BusMuxIn_R8,
	input [31:0] BusMuxIn_R9,
	input [31:0] BusMuxIn_R10,
	input [31:0] BusMuxIn_R11,
	input [31:0] BusMuxIn_R12,
	input [31:0] BusMuxIn_R13,
	input [31:0] BusMuxIn_R14,
	input [31:0] BusMuxIn_R15,

	input [31:0] BusMuxIn_HI,
	input [31:0] BusMuxIn_LO,
	input [31:0] BusMuxIn_Z_high,
	input [31:0] BusMuxIn_Z_low,
	input [31:0] BusMuxIn_PC,
	input [31:0] BusMuxIn_MDR,	
	input [31:0] BusMuxIn_InPort,
	input [31:0] C_sign_extended,

  // Define Mux Output into Bus
  output reg [31:0] BusMuxOut,

  // Select signal (from encoder) 
  input wire [4:0] mux_select_signal
);

  always @(*) begin
    case (mux_select_signal)
        5'b00000 : BusMuxOut <= BusMuxIn_R0[31:0];
        5'b00001 : BusMuxOut <= BusMuxIn_R1[31:0];
        5'b00010 : BusMuxOut <= BusMuxIn_R2[31:0];
        5'b00011 : BusMuxOut <= BusMuxIn_R3[31:0];
        5'b00100 : BusMuxOut <= BusMuxIn_R4[31:0];
        5'b00101 : BusMuxOut <= BusMuxIn_R5[31:0];
        5'b00110 : BusMuxOut <= BusMuxIn_R6[31:0];
        5'b00111 : BusMuxOut <= BusMuxIn_R7[31:0];
        5'b01000 : BusMuxOut <= BusMuxIn_R8[31:0];
        5'b01001 : BusMuxOut <= BusMuxIn_R9[31:0];
        5'b01010 : BusMuxOut <= BusMuxIn_R10[31:0];
        5'b01011 : BusMuxOut <= BusMuxIn_R11[31:0];
        5'b01100 : BusMuxOut <= BusMuxIn_R12[31:0];
        5'b01101 : BusMuxOut <= BusMuxIn_R13[31:0];
        5'b01110 : BusMuxOut <= BusMuxIn_R14[31:0];
        5'b01111 : BusMuxOut <= BusMuxIn_R15[31:0];
        5'b10000 : BusMuxOut <= BusMuxIn_HI[31:0];
        5'b10001 : BusMuxOut <= BusMuxIn_LO[31:0];
        5'b10010 : BusMuxOut <= BusMuxIn_Z_high[31:0];
        5'b10011 : BusMuxOut <= BusMuxIn_Z_low[31:0];
        5'b10100 : BusMuxOut <= BusMuxIn_PC[31:0];
        5'b10101 : BusMuxOut <= BusMuxIn_MDR[31:0];
        5'b10110 : BusMuxOut <= BusMuxIn_InPort[31:0];
        5'b10111 : BusMuxOut <= C_sign_extended[31:0];
        default  : BusMuxOut <= 32'b0; 
    endcase
  end
endmodule
  
