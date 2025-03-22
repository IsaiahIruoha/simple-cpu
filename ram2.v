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

	 //=========================================
	 //              PHASE 3
	 //=========================================
//    mem['h00] = 32'h09800065; // ldi   R3, 0x65
//    mem['h01] = 32'h09980003; // ldi   R3, 3(R3)
//    mem['h02] = 32'h01000054; // ld    R2, 0x54
//    mem['h03] = 32'h09100001; // ldi   R2, 1(R2)
//    mem['h04] = 32'h0017FFFA; // ld    R0, -6(R2)
//    mem['h05] = 32'h08800003; // ldi   R1, 3
//    mem['h06] = 32'h09800057; // ldi   R3, 0x57
//    mem['h07] = 32'h99980003; // brmi  R3, 3
//    mem['h08] = 32'h09980003; // ldi   R3, 3(R3)
//    mem['h09] = 32'h021FFFFA; // ld    R4, -6(R3)
//    mem['h0A] = 32'hD0000000; // nop
//    mem['h0B] = 32'h9A100002; // brpl  R4, 2    ; branches to @E
//    mem['h0C] = 32'h0B180007; // ldi   R6, 7(R3)   (skipped if branch taken)
//    mem['h0D] = 32'h0AB7FFFC; // ldi   R5, -4(R6)  (skipped if branch taken)
//
//    // "target" @E through @29:
//    mem['h0E] = 32'h19988000; // add   R3, R3, R1
//    mem['h0F] = 32'h62200002; // addi  R4, R4, 2
//    mem['h10] = 32'h8A200000; // neg   R4, R4
//    mem['h11] = 32'h92200000; // not   R4, R4
//    mem['h12] = 32'h6A20000F; // andi  R4, R4, 0xF
//    mem['h13] = 32'h39008000; // ror   R2, R0, R1
//    mem['h14] = 32'h72100007; // ori   R4, R2, 7
//    mem['h15] = 32'h51208000; // shra  R2, R4, R1
//    mem['h16] = 32'h49988000; // shr   R3, R3, R1
//    mem['h17] = 32'h11800092; // st    0x92, R3   ; writes to mem['h92]
//    mem['h18] = 32'h41808000; // rol   R3, R0, R1
//    mem['h19] = 32'h32880000; // or    R5, R1, R0
//    mem['h1A] = 32'h29180000; // and   R2, R3, R0
//    mem['h1B] = 32'h12900054; // st    0x54(R2), R5 ; writes to mem['h54]
//    mem['h1C] = 32'h201A8000; // sub   R0, R3, R5
//    mem['h1D] = 32'h59188000; // shl   R2, R3, R1
//    mem['h1E] = 32'h0A800008; // ldi   R5, 8
//    mem['h1F] = 32'h0B000017; // ldi   R6, 0x17
//    mem['h20] = 32'h83280000; // mul   R6, R5
//    mem['h21] = 32'hCA000000; // mfhi  R4
//    mem['h22] = 32'hC3800000; // mflo  R7
//    mem['h23] = 32'h7B280000; // div   R6, R5
//    mem['h24] = 32'h0D280001; // ldi   R10, 1(R5)
//    mem['h25] = 32'h0DB7FFFD; // ldi   R11, -3(R6)
//    mem['h26] = 32'h0E380001; // ldi   R12, 1(R7)
//    mem['h27] = 32'h0EA00004; // ldi   R13, 4(R4)
//    mem['h28] = 32'hA6000000; // jal   R12         ; calls subA @ mem['hB9]
//    mem['h29] = 32'hD8000000; // halt
//
    //-----------------------------------------------------------
    // Subroutine subA at @B9 (hex) through @BC
    //-----------------------------------------------------------
    mem['hB9] = 32'h1FD60000; // add   R15, R10, R12
    mem['hBA] = 32'h275E8000; // sub   R14, R11, R13
    mem['hBB] = 32'h27FF0000; // sub   R15, R15, R14
    mem['hBC] = 32'hAC000000; // jr    R8

//    //-----------------------------------------------------------
//    // Data Words at @54 and @92 (hex)
//    //-----------------------------------------------------------
    mem['h54] = 32'h00000097;
    mem['h92] = 32'h00000046;
	 mem['hF0] = 32'h000000FF;
	 
	 
	 
	 
	 //=========================================
	 //              PHASE 4
	 //=========================================
	 mem['h00] = 32'h09800065; // ldi   R3, 0x65 
    mem['h01] = 32'h09980003; // ldi   R3, 3(R3)
    mem['h02] = 32'h01000054; // ld    R2, 0x54
    mem['h03] = 32'h09100001; // ldi   R2, 1(R2)
    mem['h04] = 32'h0017FFFA; // ld    R0, -6(R2)
    mem['h05] = 32'h08800003; // ldi   R1, 3
    mem['h06] = 32'h09800057; // ldi   R3, 0x57
    mem['h07] = 32'h99980003; // brmi  R3, 3
    mem['h08] = 32'h09980003; // ldi   R3, 3(R3)
    mem['h09] = 32'h021FFFFA; // ld    R4, -6(R3)
    mem['h0A] = 32'hD0000000; // nop
    mem['h0B] = 32'h9A100002; // brpl  R4, 2    ; branches to @E
    mem['h0C] = 32'h0B180007; // ldi   R6, 7(R3)   (skipped if branch taken)
    mem['h0D] = 32'h0AB7FFFC; // ldi   R5, -4(R6)  (skipped if branch taken)

    // "target" @E through @29:
    mem['h0E] = 32'h19988000; // add   R3, R3, R1
    mem['h0F] = 32'h62200002; // addi  R4, R4, 2
    mem['h10] = 32'h8A200000; // neg   R4, R4
    mem['h11] = 32'h92200000; // not   R4, R4
    mem['h12] = 32'h6A20000F; // andi  R4, R4, 0xF
    mem['h13] = 32'h39008000; // ror   R2, R0, R1
    mem['h14] = 32'h72100007; // ori   R4, R2, 7
    mem['h15] = 32'h51208000; // shra  R2, R4, R1
    mem['h16] = 32'h49988000; // shr   R3, R3, R1
    mem['h17] = 32'h11800092; // st    0x92, R3   ; writes to mem['h92]
    mem['h18] = 32'h41808000; // rol   R3, R0, R1
    mem['h19] = 32'h32880000; // or    R5, R1, R0
    mem['h1A] = 32'h29180000; // and   R2, R3, R0
    mem['h1B] = 32'h12900054; // st    0x54(R2), R5 ; writes to mem['h54]
    mem['h1C] = 32'h201A8000; // sub   R0, R3, R5
    mem['h1D] = 32'h59188000; // shl   R2, R3, R1
    mem['h1E] = 32'h0A800008; // ldi   R5, 8
    mem['h1F] = 32'h0B000017; // ldi   R6, 0x17
    mem['h20] = 32'h83280000; // mul   R6, R5
    mem['h21] = 32'hCA000000; // mfhi  R4
    mem['h22] = 32'hC3800000; // mflo  R7
    mem['h23] = 32'h7B280000; // div   R6, R5
    mem['h24] = 32'h0D280001; // ldi   R10, 1(R5)
    mem['h25] = 32'h0DB7FFFD; // ldi   R11, -3(R6)
    mem['h26] = 32'h0E380001; // ldi   R12, 1(R7)
    mem['h27] = 32'h0EA00004; // ldi   R13, 4(R4)
    mem['h28] = 32'hA6000000; // jal   R12
    mem['h29] = 32'hB2000000; // in    R4
    mem['h2A] = 32'h12000055; // st    0x55, R4
    mem['h2B] = 32'h0880002E; // ldi   R1, 0x2E
    mem['h2C] = 32'h0B800001; // ldi   R7, 1
    mem['h2D] = 32'h0A800028; // ldi   R5, 40
    
    // loop @2E through @38:
    mem['h2E] = 32'hBA000000; // out   R4
    mem['h2F] = 32'h0AAFFFFF; // ldi   R5, -1(R5)
    mem['h30] = 32'h9A800008; // brzr  R5, 8
    mem['h31] = 32'h030000F0; // ld    R6, 0xF0
	 // loop 2
    mem['h32] = 32'h0B37FFFF; // ldi   R6, -1(R6)
    mem['h33] = 32'hD0000000; // nop
    mem['h34] = 32'h9B0FFFFD; // brnz  R6, -3
    mem['h35] = 32'h4A238000; // shr   R4, R4, R7
    mem['h36] = 32'h9A0FFFF7; // brnz  R4, -9
    mem['h37] = 32'h02000055; // ld    R4, 0x55
    mem['h38] = 32'hA8800000; // jr    R1
    
    // done @39 through @3B:
    mem['h39] = 32'h0A0000AA; // ldi   R4, 0xAA
    mem['h3A] = 32'hBA000000; // out   R4
    mem['h3B] = 32'hD8000000; // halt

	 
	 
	 
	 
	 

    // Old Memory 
    // mem[0] = 32'h02000054; // ld R4, 0x54
    // mem[1] = 32'h03100063; // ld r6, 0x63(R2)
    // mem[2] = 32'h0A000054; // ldi R4, 0x54
    // mem[3] = 32'h0B100063; // ldi r6, 0x63(R2)
    // mem[4] = 32'h11800034; // st 0x34, R3
    // mem[5] = 32'h11980034; // st 0x34(R3), R3
    // mem[6] = 32'h62B7FFF9; // addi R5, R6, -7
    // mem[7] = 32'h6AB00095; // andi R5, R6, 0x95
    // mem[8] = 32'h32B00095; // ori R5, R6, 0x95
    // mem[9] = 32'hAC000000; // jr R8
    // mem[10] = 32'hA2800000; // jal R5
    // mem[11] = 32'hC9800000; // mfhi R3
    // mem[12] = 32'hC1000000; // mflo R2
    // mem[13] = 32'hBB000000; // out R6
    // mem[14] = 32'hB1800000; // in R3
    // mem[15] = 32'h9880001B; // brzr R1, 27
    // mem[16] = 32'h9888001B; // brnz R1, 27
    // mem[17] = 32'h9890001B; // brpl R1, 27	 
    // mem[18] = 32'h9898001B; // brmi R1, 27
    // mem[104] = 32'h00000055; 
    // mem[52] = 32'h00000025; //st case one [4]
    // mem[84] = 32'h00000097; //ld case one [0]
    // mem[219] = 32'h00000046; //ld case two [1]
    // mem[234] = 32'h00000019; //st case two [5]
	
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
