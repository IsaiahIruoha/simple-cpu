module register_R0_32bit(
    input wire clear,
    input wire clock,
    input wire R0in,
    input wire BAout,
    input wire [31:0] BusMuxOut,
    output wire [31:0] BusMuxIn_R0
);
    
    wire [31:0] Q;
    wire BAout_not;
    
    neg_register_32bit R0 (
        .clear(clear),
        .clock(clock),
        .enable(R0in),
        .BusMuxOut(BusMuxOut),
        .BusMuxIn(Q)
    );
    
    not (BAout_not, BAout);
    
    assign BusMuxIn_R0 = Q & {32{BAout_not}};
    
endmodule