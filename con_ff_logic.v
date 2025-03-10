module con_ff_logic(
    input wire clk,
    input wire [1:0] C2,         // extracted from IR[20:19]
	 input wire CON_in,
    input wire [31:0] bus_data,       
    output wire CON              
);

    wire D;

    // instantiate condition decoder
    condition_decoder decoder (
        .C2(C2),
        .bus_data(bus_data),
        .D(D)
    );

    // instantiate conditional flip-flop
    con_ff flip_flop (
        .clk(clk),
        .D(D),
		  .CON_in(CON_in),
        .Q(CON)
    );

endmodule
