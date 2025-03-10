module condition_decoder(
    input wire [1:0] C2,     // extracted from IR[22:19]
    input wire [31:0] bus_data,  
    output wire D      
);

    assign D = (C2 == 2'b00) ? (bus_data == 0) :       // (Branch if Zero)
               (C2 == 2'b01) ? (bus_data != 0) :       // (Branch if Nonzero)
               (C2 == 2'b10) ? (bus_data > 0) :        // (Branch if Positive)
               (C2 == 2'b11) ? (bus_data < 0) : 0;     // (Branch if Negative)
endmodule
