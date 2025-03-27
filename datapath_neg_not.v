`timescale 1ns/1ps

module datapath_neg_not(
    input  wire PCout, ZLowout, ZHighout, MDRout, R0out, R5out, MAR_enable, Z_low_enable, Z_high_enable, PC_enable, MDR_enable, IR_enable, Y_enable, IncPC, Read, AND, R0_enable, R5_enable, LO_enable, HI_enable, clock, clear,
    input wire R2out,R1out,R3out,R4out,R6out,R7out,R8out,R9out,R10out,R11out,R12out,R13out,R14out,R15out,LOout,HIout,Cout,InPortout,
    input wire[31:0] MDR_data_in, 
    input wire[4:0] operation,
    input wire[31:0] encoder_input
);
	 wire [31:0] bus_data;
	 wire [63:0] c_data_out;

	 // enables for various registers
//	 wire HI_enable, LO_enable, 
	 wire Input_port_enable;
	 
	 //enables for 15 GPR (in)
	 wire R1_enable, R2_enable, R3_enable, R4_enable, R6_enable, R7_enable,
	 R8_enable, R9_enable, R10_enable, R11_enable, R12_enable, R13_enable, R14_enable, R15_enable;

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
         register_32bit r0 (clear, clock, R0_enable, bus_data, R0_data_out);
	 register_32bit r1 (clear, clock, R1_enable, bus_data, R1_data_out);
	 register_32bit r2 (clear, clock, R2_enable, bus_data, R2_data_out);
	 register_32bit r3 (clear, clock, R3_enable, bus_data, R3_data_out);
	 register_32bit r4 (clear, clock, R4_enable, bus_data, R4_data_out);
	 register_32bit r5 (clear, clock, R5_enable, bus_data, R5_data_out);
	 register_32bit r6 (clear, clock, R6_enable, bus_data, R6_data_out);
	 register_32bit r7 (clear, clock, R7_enable, bus_data, R7_data_out);
	 register_32bit r8 (clear, clock, R8_enable, bus_data, R8_data_out);
	 register_32bit r9 (clear, clock, R9_enable, bus_data, R9_data_out);
	 register_32bit r10 (clear, clock, R10_enable, bus_data, R10_data_out);
	 register_32bit r11 (clear, clock, R11_enable, bus_data, R11_data_out);
	 register_32bit r12 (clear, clock, R12_enable, bus_data, R12_data_out);
	 register_32bit r13 (clear, clock, R13_enable, bus_data, R13_data_out);
	 register_32bit r14 (clear, clock, R14_enable, bus_data, R14_data_out);
	 register_32bit r15 (clear, clock, R15_enable, bus_data, R15_data_out);
	 
	 neg_register_32bit Y_register (clear, clock, Y_enable, bus_data, Y_data_out);
	 
	 register_32bit HI_register (clear, clock, HI_enable, bus_data, HI_data_out);
	 register_32bit LO_register (clear, clock, LO_enable, bus_data, LO_data_out);
	 neg_register_32bit Z_high_register (clear, clock, Z_high_enable, c_data_out[63:32], ZHigh_data_out);
	 neg_register_32bit Z_low_register (clear, clock, Z_low_enable, c_data_out[31:0], ZLow_data_out);
	 
	 PC_register_32bit PC_register (clock, clear, PC_enable, IncPC, bus_data, PC_data_out);
	 register_32bit IR_register (clear, clock, IR_enable, bus_data, IR_data_out);
	 
	 register_32bit Input_port_register (clear, clock, Input_port_enable, bus_data, InPort_data_out);
 
	 register_32bit MAR_register (clear, clock, MAR_enable, bus_data, MAR_data_out);
	 
	 mdr_32bit mdr_unit(clock, clear, MDR_enable, Read, bus_data, MDR_data_in, MDR_data_out);
	
	 encoder_32_to_5 bus_encoder({{8{1'b0}},Cout,InPortout,MDRout,PCout,ZLowout,ZHighout,LOout,HIout,R15out,R14out,R13out,R12out,R11out,R10out,R9out,R8out,R7out,R6out,R5out,R4out,R3out,R2out,R1out,R0out}, mux_select_signal);

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
