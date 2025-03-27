module condition_decoder(
    input wire [1:0] C2,     // extracted from IR[22:19]
    input wire [31:0] bus_data,  
    output wire D      
);

    wire signed [31:0] signed_bus_data;  
    assign signed_bus_data = bus_data;

    assign D = (C2 == 2'b00) ? (bus_data == 0) :       // (Branch if Zero)
               (C2 == 2'b01) ? (bus_data != 0) :       // (Branch if Nonzero)
               (C2 == 2'b10) ? (signed_bus_data > 0) : // (Branch if Positive, signed)
               (C2 == 2'b11) ? (signed_bus_data < 0) : 1'b0; // (Branch if Negative, signed)
endmodule
