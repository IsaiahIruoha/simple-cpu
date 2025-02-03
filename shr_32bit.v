module shr_32bit(
    input wire [31:0] Ra,      // Input value to shift
    input wire [31:0] Rb,   // Shift amount (only lower 5 bits are used)
    output wire [31:0] Rz         // Output after shift
);

    // Use only the lower 5 bits of num_shifts to limit shifts (0 to 31)
    assign Rz = Ra >> Rb[4:0];

endmodule
