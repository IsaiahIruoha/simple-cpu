module Carry_Lookahead_Adder_4bit(
    input wire [3:0] Ra,   // Operand A
    input wire [3:0] Rb,   // Operand B
    input wire cin,        // Carry-in
    output wire [3:0] sum, // Sum output
    output wire cout       // Carry-out
);

    wire [3:0] P, G, c;  // Propagate, Generate, Carry bits

    // Propagate (P) and Generate (G) calculations
    assign P = Ra ^ Rb;
    assign G = Ra & Rb;

    // Carry calculations
    assign c[0] = cin;
    assign c[1] = G[0] | (P[0] & c[0]);
    assign c[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c[0]);
    assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c[0]);

    // Final carry-out
    assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & c[0]);

    // Sum calculation
    assign sum = P ^ c;

endmodule
