module mul_32bit(
    input signed [31:0] Ra, Rb,  // 32-bit signed inputs
    output reg signed [63:0] Rz // 64-bit signed product output
);
    reg [1:0] booth_code[15:0];  // Store 2-bit Booth encoded values
    reg signed [32:0] partial_prod[15:0];  // Partial products (sign-extended)
    reg signed [63:0] shifted_partial[15:0]; // Shifted partial products
    reg signed [63:0] final_product; // Final accumulated result

    integer j, i;
    wire signed [32:0] neg_Ra;
    assign neg_Ra = {~Ra[31], ~Ra} + 1;  // Compute -Ra in two’s complement

    always @(*) begin
        final_product = 64'd0;  // Initialize product to zero
        
        // Generate Booth-encoded groups (2-bit pairs)
        booth_code[0] = {Rb[0], 1'b0}; // First pair with LSB
        for (j = 1; j < 16; j = j + 1)
            booth_code[j] = {Rb[2*j], Rb[2*j-1]}; // Get 2-bit groups

        // Generate partial products
        for (j = 0; j < 16; j = j + 1) begin
            case (booth_code[j])
                2'b01: partial_prod[j] = {Ra[31], Ra}; // Add Ra
                2'b10: partial_prod[j] = neg_Ra; // Subtract Ra
                default: partial_prod[j] = 33'd0; // No operation
            endcase
            shifted_partial[j] = $signed(partial_prod[j]); // Convert to signed 64-bit
            
            // Shift left by 2j
            for (i = 0; i < j; i = i + 1)
                shifted_partial[j] = {shifted_partial[j], 2'b00}; 
        end

        // Accumulate shifted partial products
        for (j = 0; j < 16; j = j + 1)
            final_product = final_product + shifted_partial[j];

        Rz = final_product; // Assign final product
    end
endmodule
