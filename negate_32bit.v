module negate_32bit(
    input wire [31:0] Ra,   // Input value to negate
    output wire [31:0] Rz   // Output negated value
);

    wire [31:0] temp;  // Inverted bits  to get 1s complement
    wire cout;         // Carry out

    // Bitwise NOT
    not_32bit not_op (
        .Ra(Ra),
        .Rz(temp)
    );

    // Add 1 to get two’s complement
    add_32bit add_op (
        .Ra(temp), 
        .Rb(32'd1), 
        .cin({1'd0}), 
        .sum(Rz), 
        .cout(cout)  
    );

endmodule
