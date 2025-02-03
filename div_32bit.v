module div_32_bit(
    input signed [31:0] Ra, // Dividend
    input signed [31:0] Rb, // Divisor
    output reg signed [31:0] Rz // Quotient
);
    reg signed [63:0] remainder_reg; // Stores remainder internally (for calculations)
    reg signed [31:0] quotient_reg;  // Stores quotient
    integer i;
    
    always @(*) begin
        // Initialize remainder with zero and load dividend
        remainder_reg = {32'b0, Ra}; 
        quotient_reg = 32'b0;
        
        // Perform 32-bit division
        for (i = 0; i < 32; i = i + 1) begin
            // Shift left (Bring in next bit of dividend)
            remainder_reg = remainder_reg << 1;
            quotient_reg = quotient_reg << 1;
            
            // Subtract divisor
            remainder_reg[31:0] = remainder_reg[31:0] - Rb;
            
            // If remainder is positive, set quotient bit to 1
            if (remainder_reg[31] == 0) 
                quotient_reg[0] = 1;
            else
                remainder_reg[31:0] = remainder_reg[31:0] + Rb; // Restore remainder
        end
        
        // Handle sign of quotient
      if ((Ra[31] ^ Rb[31]) == 1) // Different signs then Negative quotient
            Rz = -quotient_reg;
        else
            Rz = quotient_reg;
    end
endmodule
