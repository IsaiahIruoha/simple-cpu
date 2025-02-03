module sub_32bit(
    input wire [31:0] Ra,  
    input wire [31:0] Rb,   
    output wire [31:0] sum, 
    output wire cout       
);

    wire [31:0] negated_Rb; // Holds negated Rb

  // Two’s complement negation (Rb into -Rb)
    negate_32bit negate (
        .Ra(Rb),
        .Rz(negated_Rb)
    );

    // Perform A + (-B) = A - B
    add_32bit add (
        .Ra(Ra), 
        .Rb(negated_Rb),
        .cin({1'd0}), 
        .sum(sum), 
        .cout(cout)
    );

endmodule
