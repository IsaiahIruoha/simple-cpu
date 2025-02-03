module Carry_Lookahead_Adder_16bit(
    input wire [15:0] Ra,  // Operand A
    input wire [15:0] Rb,  // Operand B
    input wire cin,        // Carry-in
    output wire [15:0] sum, // Sum output
    output wire cout       // Carry-out
);

    wire cout1, cout2, cout3;  // Intermediate carries between 4-bit adders

    // Four 4-bit CLA instances to construct a 16-bit adder
    Carry_Lookahead_Adder_4bit CLA1 (.Ra(Ra[3:0]), .Rb(Rb[3:0]), .cin(cin),   .sum(sum[3:0]),  .cout(cout1));
    Carry_Lookahead_Adder_4bit CLA2 (.Ra(Ra[7:4]), .Rb(Rb[7:4]), .cin(cout1), .sum(sum[7:4]),  .cout(cout2));
    Carry_Lookahead_Adder_4bit CLA3 (.Ra(Ra[11:8]), .Rb(Rb[11:8]), .cin(cout2), .sum(sum[11:8]), .cout(cout3));
    Carry_Lookahead_Adder_4bit CLA4 (.Ra(Ra[15:12]), .Rb(Rb[15:12]), .cin(cout3), .sum(sum[15:12]), .cout(cout));

endmodule
