module con_ff_logic(
    input wire clk,
    input wire reset,
    input wire [3:0] C2,         // extracted from IR[22:19]
    input wire [31:0] Ra,       
    output wire CON              
);

    wire CON_in;

    // instantiate condition decoder
    condition_decoder decoder (
        .C2(C2),
        .Ra(Ra),
        .CON_in(CON_in)
    );

    // instantiate conditional flip-flop
    con_ff flip_flop (
        .clk(clk),
        .reset(reset),
        .CON_in(CON_in),
        .CON(CON)
    );

endmodule
