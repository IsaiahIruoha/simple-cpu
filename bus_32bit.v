module Bus (
    // Mux Inputs: 24 sources, each 32 bits
    input [31:0] BusMuxInR0, input [31:0] BusMuxInR1, input [31:0] BusMuxInR2, 
    input [31:0] BusMuxInR3, input [31:0] BusMuxInR4, input [31:0] BusMuxInR5, 
    input [31:0] BusMuxInR6, input [31:0] BusMuxInR7, input [31:0] BusMuxInR8, 
    input [31:0] BusMuxInR9, input [31:0] BusMuxInR10, input [31:0] BusMuxInR11, 
    input [31:0] BusMuxInR12, input [31:0] BusMuxInR13, input [31:0] BusMuxInR14, 
    input [31:0] BusMuxInR15, input [31:0] BusMuxInHI, input [31:0] BusMuxInLO, 
    input [31:0] BusMuxInZhigh, input [31:0] BusMuxInZlow, input [31:0] BusMuxInPC, 
    input [31:0] BusMuxInMDR, input [31:0] BusMuxInInPort, input [31:0] C_sign_extended,

    // Control signals from the 32-to-5 Encoder
    input R0out, input R1out, input R2out, input R3out, input R4out, input R5out, 
    input R6out, input R7out, input R8out, input R9out, input R10out, input R11out, 
    input R12out, input R13out, input R14out, input R15out, input HIout, input LOout, 
    input Zhighout, input Zlowout, input PCout, input MDRout, input InPortout, input Cout,

    // Output of the multiplexer
    output reg [31:0] BusMuxOut
);

always @ (*) begin
    case ({Cout, InPortout, MDRout, PCout, Zlowout, Zhighout, LOout, HIout,
           R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, 
           R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out})
        24'b000000000000000000000001: BusMuxOut = BusMuxInR0;
        24'b000000000000000000000010: BusMuxOut = BusMuxInR1;
        24'b000000000000000000000100: BusMuxOut = BusMuxInR2;
        24'b000000000000000000001000: BusMuxOut = BusMuxInR3;
        24'b000000000000000000010000: BusMuxOut = BusMuxInR4;
        24'b000000000000000000100000: BusMuxOut = BusMuxInR5;
        24'b000000000000000001000000: BusMuxOut = BusMuxInR6;
        24'b000000000000000010000000: BusMuxOut = BusMuxInR7;
        24'b000000000000000100000000: BusMuxOut = BusMuxInR8;
        24'b000000000000001000000000: BusMuxOut = BusMuxInR9;
        24'b000000000000010000000000: BusMuxOut = BusMuxInR10;
        24'b000000000000100000000000: BusMuxOut = BusMuxInR11;
        24'b000000000001000000000000: BusMuxOut = BusMuxInR12;
        24'b000000000010000000000000: BusMuxOut = BusMuxInR13;
        24'b000000000100000000000000: BusMuxOut = BusMuxInR14;
        24'b000000001000000000000000: BusMuxOut = BusMuxInR15;
        24'b000000010000000000000000: BusMuxOut = BusMuxInHI;
        24'b000000100000000000000000: BusMuxOut = BusMuxInLO;
        24'b000001000000000000000000: BusMuxOut = BusMuxInZhigh;
        24'b000010000000000000000000: BusMuxOut = BusMuxInZlow;
        24'b000100000000000000000000: BusMuxOut = BusMuxInPC;
        24'b001000000000000000000000: BusMuxOut = BusMuxInMDR;
        24'b010000000000000000000000: BusMuxOut = BusMuxInInPort;
        24'b100000000000000000000000: BusMuxOut = C_sign_extended;
        default: BusMuxOut = 32'h00000000; // Default case
    endcase
end

endmodule
