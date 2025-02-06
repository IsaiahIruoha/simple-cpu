module shra_32bit(
    input wire [31:0] Ra,      // Input value to shift
    input wire [31:0] Rb,   // Shift amount (only lower 5 bits used)
    output wire [31:0] Rz         // Output after shift
);

    assign Rz = $signed(Ra) >>> Rb;

endmodule
