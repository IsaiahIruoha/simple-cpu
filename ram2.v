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
    mem[11] = 32'hC9800000; // mfhi R3
	 mem[12] = 32'hC1000000; // mflo R2
	 mem[13] = 32'hBB000000; // out R6
	 mem[14] = 32'hB1800000; // in R3
	 mem[15] = 32'h9880001B; // brzr R1, 27
    mem[16] = 32'h9888001B; // brnz R1, 27
	 mem[17] = 32'h9890001B; // brpl R1, 27	 
    mem[18] = 32'h9898001B; // brmi R1, 27

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