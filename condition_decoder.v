module condition_decoder(
    input wire [3:0] C2,     // extracted from IR[22:19]
    input wire [31:0] Ra,  
    output wire CON_in       
);

    assign CON_in = (C2 == 4'b0000) ? (Ra == 0) :       // (Branch if Zero)
                    (C2 == 4'b0001) ? (Ra != 0) :       // (Branch if Nonzero)
                    (C2 == 4'b0010) ? (Ra > 0) :        // (Branch if Positive)
                    (C2 == 4'b0011) ? (Ra < 0) : 0;     // (Branch if Negative)
endmodule
