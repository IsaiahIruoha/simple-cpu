`timescale 1ns/1ps

module datapath(
    input  wire        clock,
    input  wire        clear, 
    // Enables for a few registers
    input  wire        R0_enable,
    input  wire        R1_enable,
    input  wire        R2_enable,
    input  wire        R3_enable,
    // Mux select signal to pick which source goes onto the bus
    input  wire [4:0]  mux_select_signal,

    input  wire [31:0] external_data,
    
    // We will expose these so you can watch them in simulation
    output wire [31:0] R0_data,
    output wire [31:0] R1_data,
    output wire [31:0] R2_data,
    output wire [31:0] R3_data,
    // The bus output from the mux
    output wire [31:0] bus_data
);

    // 1) Instantiate 32-bit registers R0..R3
    // Each register’s “BusMuxOut” port is the bus input,
    // and “BusMuxIn” is that register’s output signal.

    register_32bit r0 (
        .clear(clear),
        .clock(clock),
        .enable(R0_enable),
        .BusMuxOut(bus_data),
        .BusMuxIn(R0_data)
    );
    
    register_32bit r1 (
        .clear(clear),
        .clock(clock),
        .enable(R1_enable),
        .BusMuxOut(bus_data),
        .BusMuxIn(R1_data)
    );
    
    register_32bit r2 (
        .clear(clear),
        .clock(clock),
        .enable(R2_enable),
        .BusMuxOut(bus_data),
        .BusMuxIn(R2_data)
    );
    
    register_32bit r3 (
        .clear(clear),
        .clock(clock),
        .enable(R3_enable),
        .BusMuxOut(bus_data),
        .BusMuxIn(R3_data)
    );

    // 2) Instantiate the 32-to-1 MUX 
    
    mux_32_to_1 bus_mux (
        .BusMuxIn_R0      (R0_data),
        .BusMuxIn_R1      (R1_data),
        .BusMuxIn_R2      (R2_data),
        .BusMuxIn_R3      (R3_data),
        // Tie off the unused ones to 32'b0
        .BusMuxIn_R4      (32'b0),
        .BusMuxIn_R5      (32'b0),
        .BusMuxIn_R6      (32'b0),
        .BusMuxIn_R7      (32'b0),
        .BusMuxIn_R8      (32'b0),
        .BusMuxIn_R9      (32'b0),
        .BusMuxIn_R10     (32'b0),
        .BusMuxIn_R11     (32'b0),
        .BusMuxIn_R12     (32'b0),
        .BusMuxIn_R13     (32'b0),
        .BusMuxIn_R14     (32'b0),
        .BusMuxIn_R15     (32'b0),
        .BusMuxIn_HI      (32'b0),
        .BusMuxIn_LO      (32'b0),
        .BusMuxIn_Z_high  (32'b0),
        .BusMuxIn_Z_low   (32'b0),
        .BusMuxIn_PC      (32'b0),
        .BusMuxIn_MDR     (32'b0),
        .BusMuxIn_InPort  (32'b0),
        // Use 'C_sign_extended' as the external data input
        .C_sign_extended  (external_data),
        
        // The bus output
        .BusMuxOut        (bus_data),
        
        // The 5-bit select from outside
        .mux_select_signal(mux_select_signal)
    );

endmodule
