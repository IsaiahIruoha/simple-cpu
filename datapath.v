`timescale 1ns/1ps

module datapath(
    input  wire clock, clear,

    input  wire [31:0] external_data,
    
    // We will expose these so you can watch them in simulation
	 input wire R0_enable,
	 input wire R1_enable,
	 input wire R2_enable,
	 output wire [31:0] R0_data,
    output wire [31:0] R1_data,
    output wire [31:0] R2_data,
	 
	 input wire [31:0] encoder_input,
	 
    // The bus output from the mux
    output wire [31:0] bus_data
);

    // 1) Instantiate 32-bit registers R0..R3
    // Each register’s “BusMuxOut” port is the bus input,
    // and “BusMuxIn” is that register’s output signal.

    register_32bit r0 (clear, clock, R0_enable, bus_data, R0_data);
	 register_32bit r1 (clear, clock, R1_enable, bus_data, R1_data);
	 register_32bit r2 (clear, clock, R2_enable, bus_data, R2_data);
    
	 
	 
	 wire [4:0] mux_select_signal;
	 
	 encoder_32_to_5 bus_encoder(encoder_input, mux_select_signal);

    // 2) Instantiate the 32-to-1 MUX 
    
    mux_32_to_1 bus_mux (
        .BusMuxIn_R0      (R0_data),
        .BusMuxIn_R1      (R1_data),
        .BusMuxIn_R2      (R2_data),
		   // Tie off the unused ones to 32'b0
        .BusMuxIn_R3      (32'b0),
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
        
        // The 5-bit select from encoder
        .mux_select_signal(mux_select_signal)
    );

endmodule
