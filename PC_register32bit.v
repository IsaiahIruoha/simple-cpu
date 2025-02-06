module PC_register_32bit(
    input  wire        clock,
    input  wire        clear,
    input  wire        enable,
    input  wire        IncPC,
    // If IncPC is 0 but enable is 1, we load this external value into the PC
    input  wire [31:0] external_val,
    output wire [31:0] PC_out
);
    wire [31:0] currentPC;   
    wire [31:0] adder_sum;   
    wire        adder_cout; 
    reg  [31:0] nextPC_in;   

    register_32bit #(
        .DATA_WIDTH_IN(32),
        .DATA_WIDTH_OUT(32),
        .INIT(32'h00000000)       // Initial PC value
    ) u_pc_reg (
        .clear(clear),
        .clock(clock),
        .enable(enable),
        .BusMuxOut(nextPC_in),    // The input to the register
        .BusMuxIn(currentPC)      // The output from the register
    );

    // Instantiate your 32-bit adder to compute currentPC + 1
    add_32bit pc_adder (
        .Ra(currentPC),
        .Rb(32'd1),
        .cin(1'b0),
        .sum(adder_sum),
        .cout(adder_cout)
    );

    // Choose between adder_sum or external_val
    always @(*) begin
        if (IncPC)
            nextPC_in = adder_sum;      // currentPC + 1
        else
            nextPC_in = external_val;   // some external load value
    end

    // The register output is our PC
    assign PC_out = currentPC;

endmodule
