module add_32bit(
    input wire [31:0] Ra,    // Operand A
    input wire [31:0] Rb,    // Operand B
    input wire cin,          // Carry-in
    output wire [31:0] sum,  // Sum output
    output wire cout         // Carry-out
);

    wire cout1;  // Intermediate carry between 16-bit adders

    // Two 16-bit CLA instances to construct a 32-bit adder
    Carry_Lookahead_Adder_16bit CLA1 (
        .Ra(Ra[15:0]), 
        .Rb(Rb[15:0]), 
        .cin(cin), 
        .sum(sum[15:0]), 
        .cout(cout1)
    );

    Carry_Lookahead_Adder_16bit CLA2 (
        .Ra(Ra[31:16]), 
        .Rb(Rb[31:16]), 
        .cin(cout1), 
        .sum(sum[31:16]), 
        .cout(cout)
    );

endmodule
