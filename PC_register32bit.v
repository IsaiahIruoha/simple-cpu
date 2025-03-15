module PC_register_32bit #(
    parameter INIT_PC = 32'h00000000 // Default initial PC value
)(
    input  wire        clock,
    input  wire        clear,
    input  wire        enable,
    input  wire        IncPC,
    input  wire [31:0] external_val,  // If IncPC is 0 but enable is 1, load this external value
    output wire [31:0] PC_out
);
    wire [31:0] currentPC;   
    wire [31:0] adder_sum;   
    wire        adder_cout; 
    reg  [31:0] nextPC_in;   

    register_32bit #(
        .DATA_WIDTH_IN(32),
        .DATA_WIDTH_OUT(32),
        .INIT(INIT_PC)  // Use the parameter for initial PC value
    ) pc_reg (
        .clear(clear),
        .clock(clock),
        .enable(enable),
        .BusMuxOut(nextPC_in),    // The input to the register
        .BusMuxIn(currentPC)      // The output from the register
    );

    add_32bit pc_adder ( // Instantiate adder to increment PC by 1
        .Ra(currentPC),
        .Rb(32'd1),
        .cin(1'b0),
        .sum(adder_sum),
        .cout(adder_cout)
    );

    always @(*) begin // Choose between adder_sum or external_val
        if (IncPC)
            nextPC_in = adder_sum;      // currentPC + 1
        else
            nextPC_in = external_val;   // some external load value
    end

    assign PC_out = currentPC; // The register output is our PC
endmodule
