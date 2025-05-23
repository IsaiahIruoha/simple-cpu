module mdr_32bit (
    input wire clock, clear, MDRin, Read,
    input wire [31:0] BusMuxOut, Mdatain,
    output wire [31:0] MDRout
);

wire [31:0] mux_out;

mux_2_to_1 md_mux (
    .in1(BusMuxOut),
    .in2(Mdatain),
    .signal(Read),
    .out(mux_out)
);

neg_register_32bit #(
    .DATA_WIDTH_IN(32),
    .DATA_WIDTH_OUT(32),
    .INIT(32'h0)
) md_register (
    .clear(clear),
    .clock(clock),
    .enable(MDRin),
    .BusMuxOut(mux_out),
    .BusMuxIn(MDRout)
);

endmodule
