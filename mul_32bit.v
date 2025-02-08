module mul_32bit (
    input  wire [31:0] Ra,
    input  wire [31:0] Rb,
    output reg  [63:0] Rz
);

    reg  signed [32:0] multiplicand;    // 33-bit sign-extended A
    reg  signed [32:0] negMultiplicand; // -A (2's complement)
    reg  signed [63:0] partialProduct; 
    reg  signed [63:0] product;
    integer i;

    always @(*) begin
        multiplicand    = {Ra[31], Ra};   // sign-extend to 33 bits
        negMultiplicand = -multiplicand;  // 2's complement negative
        product = 64'd0; 

        // Booth's bit-pair recoding inspects (b_{2i+1}, b_{2i}, b_{2i-1}).
        // For i=0, we use an implicit b_{-1}=0.
        // We'll generate 16 partial products, each shifted by 2*i bits.

        for (i = 0; i < 16; i = i + 1) begin
            reg [2:0] bits;              
            reg signed [33:0] recodedVal; 
            
            // Gather the 3 bits for this pair
            if (i == 0)
                bits = {Rb[1], Rb[0], 1'b0}; 
            else
                bits = {Rb[2*i+1], Rb[2*i], Rb[2*i-1]};

            // Recode those bits into -2, -1, 0, +1, +2 times A
            case (bits)
                3'b000: recodedVal = 34'd0;
                3'b001: recodedVal = multiplicand;      // +1 * A
                3'b010: recodedVal = multiplicand;      // +1 * A
                3'b011: recodedVal = multiplicand <<< 1; // +2 * A
                3'b100: recodedVal = negMultiplicand <<< 1; // -2 * A
                3'b101: recodedVal = negMultiplicand;   // -1 * A
                3'b110: recodedVal = negMultiplicand;   // -1 * A
                3'b111: recodedVal = 34'd0;
            endcase

            // Sign-extend from 34 bits up to 64
            partialProduct = {{(64-34){recodedVal[33]}}, recodedVal};

            // Shift the partial product left by 2*i
            partialProduct = partialProduct <<< (2*i);

            // Accumulate into final product
            product = product + partialProduct;
        end
        Rz = product;
    end
endmodule

