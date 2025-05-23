module mul_32bit (
    input  wire [31:0] Ra,
    input  wire [31:0] Rb,
    output reg  [63:0] Rz
);

	reg  signed [32:0] multiplicand;    // 33 bit sign extended A
	reg  signed [32:0] negMultiplicand; // -A/ 2s complement
    reg  signed [63:0] partialProduct; 
    reg  signed [63:0] product;
	 reg [2:0] bits0, bits;              
    reg signed [33:0] recodedVal;
    integer i;

    always @(*) begin
	    multiplicand    = {Ra[31], Ra};   // sign extend to 33 bits
        negMultiplicand = -multiplicand;  // 2's complement negative
        product = 64'd0; 

        for (i = 0; i < 16; i = i + 1) begin
             
            
            // Gather the 3 bits for this pair
            if (i == 0)
                bits0 = {Rb[1], Rb[0], 1'b0}; 
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
				
				case (bits0)
                3'b000: recodedVal = 34'd0;
                3'b010: recodedVal = multiplicand;      // +1 * A
                3'b100: recodedVal = negMultiplicand <<< 1; // -2 * A
                3'b110: recodedVal = negMultiplicand;   // -1 * A
            endcase

            partialProduct = {{(64-34){recodedVal[33]}}, recodedVal};

            partialProduct = partialProduct <<< (2*i);

            product = product + partialProduct;
        end
        Rz = product;
    end
endmodule

