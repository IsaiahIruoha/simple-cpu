module ror_32bit(
  input wire [31:0] Ra,           // Input value to rotate
  input wire [31:0] Rb,           // Rotation amount (only lower 5 bits used)
  output wire [31:0] Rz         // Rotated output
);

    // Rotate Right
  assign Rz = (Ra >> Rb[4:0]) | (Ra << (32 - Rb[4:0]));

endmodule
