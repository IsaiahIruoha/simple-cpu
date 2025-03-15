module ram2 #(parameter init_RAM_data_out = 0) (
    output reg [31:0] RAM_data_out,  // output declaration
    input [31:0] RAM_data_in,        // input declaration
    input [7:0] address,             // address input
    input clk,                     // clock input
    input write_enable,              // write enable input
    input read_enable                // read enable input
);

reg [31:0] mem [511:0];

initial begin
    mem[0] = 32'h02000054; // ld R4, 0x54
    mem[1] = 32'h03100063; // ld r6, 0x63(R2)
    mem[2] = 32'h0A000054; // ldi R4, 0x54
    mem[3] = 32'h0B100063; // ldi r6, 0x63(R2)
    mem[4] = 32'h11800034; // st 0x34, R3
    mem[5] = 32'h11980034; // st 0x34(R3), R3
    mem[6] = 32'h62B7FFF9; // addi R5, R6, -7
    mem[7] = 32'h6AB00095; // andi R5, R6, 0x95
    mem[8] = 32'h32B00095; // ori R5, R6, 0x95
	 mem[9] = 32'hAC000000; // jr R8
	 mem[10] = 32'hA2800000; // jal R5
	 
    mem[11] = 32'h09000005; // (Done manually, might be wrong tho lol) ldi R2, 5(R0) ; this instruction will not execute
    mem[12] = 32'h09880002; // ldi R3, 2(R1) ; this instruction will not execute
    mem[13] = 32'h19918000; // add R3, R2, R3 ; R3 = $BC <------- THIS IS TARGET
    mem[14] = 32'h63B80002; // addi R7, R7, 2 ; R7 = $57
    mem[15] = 32'h8BB80000; // neg R7, R7 ; R7 = $FFFFFFA9
    mem[16] = 32'h93B80000; // not R7, R7 ; R7 = $56
    mem[17] = 32'h6BB8000F; // andi R7, R7, $0F ; R7 = 6
    mem[18] = 32'h50880000; // ror R1, R1, R0 ; R1 = $80000009
    mem[19] = 32'h7388001C; // ori R7, R1, $1C ; R7 = $8000001D
    mem[20] = 32'h43B80000; // shra R7, R7, R0 ; R7 = $E0000007
    mem[21] = 32'h39180000; // shr R2, R3, R0 ; R2 = $2F
    mem[22] = 32'h11000052; // st $52, R2 ; ($52) = $2F new value in memory with address $52
    mem[23] = 32'h59100000; // rol R2, R2, R0 ; R2 = $BC
    mem[24] = 32'h31180000; // or R2, R3, R0 ; R2 = $BE
    mem[25] = 32'h28908000; // and R1, R2, R1 ; R1 = $8
    mem[26] = 32'h11880060; // st $60(R1), R3 ; ($68) = $BC new value in memory with address $68
    mem[27] = 32'h21918000; // sub R3, R2, R3 ; R3 = 2
    mem[28] = 32'h48900000; // shl R1, R2, R0 ; R1 = $2F8
    mem[29] = 32'h0A000006; // ldi R4, 6 ; R4 = 6
    mem[30] = 32'h0A800032; // ldi R5, $32 ; R5 = $32
    mem[31] = 32'h7AA00000; // mul R5, R4 ; HI = 0; LO = $12C
    mem[32] = 32'hC3800000; // mfhi R7 ; R7 = 0
    mem[33] = 32'hCB000000; // mflo R6 ; R6 = $12C
    mem[34] = 32'h82A00000; // div R5, R4 ; HI = 2, LO = 8
    mem[35] = 32'h0C27FFFF; // ldi R8, -1(R4) ; R8 = 5 setting up argument registers
    mem[36] = 32'h0CAFFFED; // ldi R9, -19(R5) ; R9 = $1F R8, R9, R10, and R11
    mem[37] = 32'h0D300000; // ldi R10, 0(R6) ; R10 = $12C
    mem[38] = 32'h0DB80000; // ldi R11, 0(R7) ; R11 = 0
    mem[39] = 32'hAD000000; // jal R10 ; address of subroutine subA in R10 - return address in R15
    mem[40] = 32'hD8000000; // halt, upon return, the program halts

    // // subprogram: procedure subA
    mem[300] = 32'h1EC50000; // add R13, R8, R10 ; R12 and R13 are return value registers
    mem[301] = 32'h264D8000; // sub R12, R9, R11 ; R13 = $131, R12 = $1F
    mem[302] = 32'h26EE0000; // sub R13, R13, R12 ; R13 = $112
    mem[303] = 32'hA7800000; // jr R15 ; return from procedure

    mem[104] = 32'h00000055;
	 
	 mem[52] = 32'h00000025; //st case one [4]
    mem[84] = 32'h00000097; //ld case one [0]
	 mem[219] = 32'h00000046; //ld case two [1]
	 mem[234] = 32'h00000019; //st case two [5]
	 

    RAM_data_out = init_RAM_data_out;

end


always @(posedge clk) begin

    if (write_enable == 1) begin
        mem[address] <= RAM_data_in;
    end

    if(read_enable == 1) begin
        RAM_data_out <= mem[address];
    end
end

endmodule