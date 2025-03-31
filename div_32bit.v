module div_32bit(
    input  signed [31:0] Ra, // Dividend
    input  signed [31:0] Rb, // Divisor
    output reg   signed [63:0] Rz //remainder, quotient
);
    integer i; 
    reg sign_dividend;
    reg sign_divisor;
    reg sign_quotient;
    reg [31:0] abs_dividend;
    reg [31:0] abs_divisor;
    reg signed [31:0] remainder_int;
    reg signed [31:0] quotient_int;

    always @(*) begin
        sign_dividend  = Ra[31]; // Extract the signs
        sign_divisor   = Rb[31];
        sign_quotient  = sign_dividend ^ sign_divisor;  // XOR for quotient sign

        // Absolute values
        abs_dividend = (sign_dividend) ? -Ra : Ra;  
        abs_divisor  = (sign_divisor ) ? -Rb : Rb; 
        remainder_int = 0;
        quotient_int  = 0;

        for (i = 31; i >= 0; i = i - 1) begin
            // Shift remainder left by 1
            remainder_int = remainder_int <<< 1;

            // Bring down next highest bit
            remainder_int[0] = abs_dividend[i];

            // Tentative subtract
            remainder_int = remainder_int - abs_divisor;

            if (remainder_int < 0) begin
                //if negative restore remainder
                remainder_int = remainder_int + abs_divisor;

                //shift quotient left and put a 0 in the new LSB
                quotient_int = quotient_int <<< 1;
                quotient_int[0] = 0;
            end
            else begin
                // If still greater than 0 accept the subtraction
                // Shift quotient left and put a 1 in the new LSB
                quotient_int = quotient_int <<< 1;
                quotient_int[0] = 1;
            end
        end
        if (sign_dividend)
            remainder_int = -remainder_int; 

        if (sign_quotient)
            quotient_int = -quotient_int;

        Rz[63:32] = remainder_int;  // top half = remainder
        Rz[31: 0] = quotient_int;   // low half = quotient
    end
endmodule
