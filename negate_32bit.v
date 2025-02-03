module negate_32bit(
    input wire [31:0] Ra,   // Input value to negate
    output wire [31:0] Rz   // Output negated value
);

    wire [31:0] temp;  // Inverted bits (one’s complement)
    wire cout;         // Carry-out from addition (unused in negation)

    // Step 1: Bitwise NOT (one’s complement)
    not_32bit not_op (
        .Ra(Ra),
        .Rz(temp)
    );

    // Step 2: Add 1 to get two’s complement
    add_32_bit add_op (
        .Ra(temp), 
        .Rb(32'd1), 
        .sum(Rz), 
        .cout(cout)  // Carry-out is not used
    );

endmodule
