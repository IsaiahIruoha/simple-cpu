`timescale 1ns/1ps

module datapath(
    input  wire PCout, ZLowout, MDRout, MAR_enable, Z_low_enable, PC_enable, MDR_enable, IR_enable, Y_enable, IncPC, Read, AND, clock,
    input wire ZHighout,LOout,HIout,Cout,InPortout,
	 input wire GRA, GRB, GRC, Rin, Rout, BAout,
    input wire[31:0] MDR_data_in, 
    input wire[4:0] operation,
    input wire[31:0] encoder_input,
	 input wire[15:0] register_enable_signals,
	 input wire[15:0] ir_enable_signals,
	 input wire[15:0] ir_output_signals
);
	

	 wire [31:0] bus_data;
	 wire [63:0] c_data_out;
	 
	 reg [15:0] RinSignals, RoutSignals;
	 
	 always@(*)begin		
			if (Rin)
				RinSignals<=ir_enable_signals;
			else
				RinSignals<=register_enable_signals;
			if (ir_output_signals)
				RoutSignals<=ir_output_signals;
			else
				RoutSignals<=16'b0;
	 end 

	 // enables for various registers
	 wire HI_enable, LO_enable, Input_port_enable;

	 //5 bits that go from encoder to mux
	 wire [4:0] mux_select_signal;

	 wire [31:0] Y_data_out;
	 wire [31:0] IR_data_out;

	 //input to 32 to 1 multiplexer
	 wire [31:0] R0_data_out;
	 wire [31:0] R1_data_out;
	 wire [31:0] R2_data_out;
	 wire [31:0] R3_data_out;
	 wire [31:0] R4_data_out;
	 wire [31:0] R5_data_out;
	 wire [31:0] R6_data_out;
	 wire [31:0] R7_data_out;
	 wire [31:0] R8_data_out;
	 wire [31:0] R9_data_out;
	 wire [31:0] R10_data_out;
	 wire [31:0] R11_data_out;
	 wire [31:0] R12_data_out;
	 wire [31:0] R13_data_out;
	 wire [31:0] R14_data_out;
	 wire [31:0] R15_data_out;
	 wire [31:0] HI_data_out;
	 wire [31:0] LO_data_out;
	 wire [31:0] ZHigh_data_out;
	 wire [31:0] ZLow_data_out;
	 wire [31:0] PC_data_out;
	 wire [31:0] MDR_data_out;
	 wire [31:0] MAR_data_out;
	 wire [31:0] InPort_data_out;
	 wire [31:0] C_sign_extended;

    // Instantiate 32-bit registers
         register_32bit r0 (clear, clock, RinSignals[0], bus_data, R0_data_out);
	 register_32bit r1 (clear, clock, RinSignals[1], bus_data, R1_data_out);
	 register_32bit r2 (clear, clock, RinSignals[2], bus_data, R2_data_out);
	 register_32bit r3 (clear, clock, RinSignals[3], bus_data, R3_data_out);
	 register_32bit r4 (clear, clock, RinSignals[4], bus_data, R4_data_out);
	 register_32bit r5 (clear, clock, RinSignals[5], bus_data, R5_data_out);
	 register_32bit r6 (clear, clock, RinSignals[6], bus_data, R6_data_out);
	 register_32bit r7 (clear, clock, RinSignals[7], bus_data, R7_data_out);
	 register_32bit r8 (clear, clock, RinSignals[8], bus_data, R8_data_out);
	 register_32bit r9 (clear, clock, RinSignals[9], bus_data, R9_data_out);
	 register_32bit r10 (clear, clock, RinSignals[10], bus_data, R10_data_out);
	 register_32bit r11 (clear, clock, RinSignals[11], bus_data, R11_data_out);
	 register_32bit r12 (clear, clock, RinSignals[12], bus_data, R12_data_out);
	 register_32bit r13 (clear, clock, RinSignals[13], bus_data, R13_data_out);
	 register_32bit r14 (clear, clock, RinSignals[14], bus_data, R14_data_out);
	 register_32bit r15 (clear, clock, RinSignals[15], bus_data, R15_data_out);
	 
	 neg_register_32bit Y_register (clear, clock, Y_enable, bus_data, Y_data_out);
	 
	 register_32bit HI_register (clear, clock, HI_enable, bus_data, HI_data_out);
	 register_32bit LO_register (clear, clock, LO_enable, bus_data, LO_data_out);
	 neg_register_32bit Z_high_register (clear, clock, Z_high_enable, c_data_out[63:32], ZHigh_data_out);
	 neg_register_32bit Z_low_register (clear, clock, Z_low_enable, c_data_out[31:0], ZLow_data_out);
	 
	 PC_register_32bit PC_register (clock, clear, PC_enable, IncPC, bus_data, PC_data_out);
	 register_32bit IR_register (clear, clock, IR_enable, bus_data, IR_data_out);
	 
	 select_encode_ir ir_encode(IR_data_out, GRA, GRB, GRC, Rin, Rout, BAout, ir_enable_signals, ir_output_signals, C_sign_extended);
	 
	 register_32bit Input_port_register (clear, clock, Input_port_enable, bus_data, InPort_data_out);
 
	 register_32bit MAR_register (clear, clock, MAR_enable, bus_data, MAR_data_out);
	 
	 mdr_32bit mdr_unit(clock, clear, MDR_enable, Read, bus_data, MDR_data_in, MDR_data_out);
	
	 encoder_32_to_5 bus_encoder({{8{1'b0}},Cout,InPortout,MDRout,PCout,ZLowout,ZHighout,LOout,HIout,RoutSignals}, mux_select_signal);

    // Instantiate the 32-to-1 MUX
    mux_32_to_1 bus_mux (
        .BusMuxIn_R0      (R0_data_out),
        .BusMuxIn_R1      (R1_data_out),
        .BusMuxIn_R2      (R2_data_out),
        .BusMuxIn_R3      (R3_data_out),
        .BusMuxIn_R4      (R4_data_out),
        .BusMuxIn_R5      (R5_data_out),
        .BusMuxIn_R6      (R6_data_out),
        .BusMuxIn_R7      (R7_data_out),
        .BusMuxIn_R8      (R8_data_out),
        .BusMuxIn_R9      (R9_data_out),
        .BusMuxIn_R10     (R10_data_out),
        .BusMuxIn_R11     (R11_data_out),
        .BusMuxIn_R12     (R12_data_out),
        .BusMuxIn_R13     (R13_data_out),
        .BusMuxIn_R14     (R14_data_out),
        .BusMuxIn_R15     (R15_data_out),
        .BusMuxIn_HI      (HI_data_out),
        .BusMuxIn_LO      (LO_data_out),
        .BusMuxIn_Z_high  (ZHigh_data_out),
        .BusMuxIn_Z_low   (ZLow_data_out),
        .BusMuxIn_PC      (PC_data_out),
        .BusMuxIn_MDR     (MDR_data_out),
        .BusMuxIn_InPort  (InPort_data_out),
        .C_sign_extended  (C_sign_extended),
        .BusMuxOut        (bus_data),
        .mux_select_signal(mux_select_signal)
    );

    // Instantiate the ALU
    alu alu_unit(.clk(clock), .clear(clear), .A_reg(Y_data_out), .B_reg(bus_data), .opcode(operation), .C_reg(c_data_out));
	
endmodule