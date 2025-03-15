`timescale 1ns/1ps

module datapath(
    input  wire PCout, ZLowout, MDRout, MAR_enable, Z_low_enable, PC_enable, MDR_enable, IR_enable, Y_enable, IncPC, Read, Write, AND, clock,
    input wire ZHighout,LOout,HIout,Cout,InPortout,
	 input wire GRA, GRB, GRC, Rin, Rout, BAout, 
    input wire[4:0] operation,
    input wire[31:0] encoder_input,
	 input wire[15:0] register_enable_signals,
	 input wire CON_in
);
	

	 wire [31:0] bus_data;
	 wire [63:0] c_data_out;
	 wire CON_output;
	 
	 wire[31:0] RAM_data_out;
	 
	 reg [15:0] RinSignals, RoutSignals;
	 wire[15:0] ir_enable_signals;
	 wire[15:0] ir_output_signals;
	 
	 always@(*)begin		
			if (ir_enable_signals)
				RinSignals<=ir_enable_signals;
			else
				RinSignals<=register_enable_signals;
			if (ir_output_signals)
				RoutSignals<=ir_output_signals;
			else
				RoutSignals<=16'b0;
	 end 

	 // enables for various registers
	 wire HI_enable, LO_enable, Output_port_enable;
	 wire Input_port_strobe; //will need to be coming from device later
	 
	 wire [31:0] OutPort_data_out, device_data;  //going to feed to external device later
	

	 //5 bits that go from encoder to mux
	 wire [4:0] mux_select_signal;

	 wire [31:0] Y_data_out;
	 wire [31:0] IR_data_out;

	 //input to 32 to 1 multiplexer, go onto bus
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
	 wire [31:0] InPort_data_out;  //going to come from external device later
	 wire [31:0] C_sign_extended;
	 
	 

    // Instantiate 32-bit registers
    register_R0_32bit r0 (clear, clock, RinSignals[0], BAout, bus_data, R0_data_out);
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
	 
	 PC_register_32bit #(.INIT_PC(32'h00000000)) PC_register (clock, clear, PC_enable, IncPC, bus_data, PC_data_out);
	 
	 register_32bit IR_register (clear, clock, IR_enable, bus_data, IR_data_out);
	 select_encode_ir ir_encode(IR_data_out, GRA, GRB, GRC, Rin, Rout, BAout, ir_enable_signals, ir_output_signals, C_sign_extended);
	 con_ff_logic conff_unit(clock, IR_data_out[20:19], CON_in, bus_data, CON_output);
	 
	 register_32bit Input_port_register (clear, clock, Input_port_strobe, device_data, InPort_data_out);
	 register_32bit Output_port_register (clear, clock, Output_port_enable, bus_data, OutPort_data_out);
 
	 register_32bit MAR_register (clear, clock, MAR_enable, bus_data, MAR_data_out);
	 
	 mdr_32bit mdr_unit(clock, clear, MDR_enable, Read, bus_data, RAM_data_out, MDR_data_out);
	
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
	 
	 // RAM
	 ram2 memory(
	   .RAM_data_out(RAM_data_out),
		.address(MAR_data_out[7:0]),
		.clk(clock),
		.RAM_data_in(MDR_data_out),
		.write_enable(Write),
		.read_enable(Read)
	 );
	 
	 
	 
	 //ld case 2
//	 defparam PC_register.INIT_PC = 32'h00000001;
//	 defparam r2.INIT = 32'h00000078;

	//ldi case 1
//	 defparam PC_register.INIT_PC = 32'h00000002;
	 
	 //ldi case 2
//	 defparam PC_register.INIT_PC = 32'h00000003;
//	 defparam r2.INIT = 32'h00000078;

	 //st case 1
//	 defparam PC_register.INIT_PC = 32'h00000004;
//	 defparam r3.INIT = 32'h000000B6;
	 
	 //st case 2
//	 defparam PC_register.INIT_PC = 32'h00000005;
//	 defparam r3.INIT = 32'h000000B6;

	//addi
//	defparam PC_register.INIT_PC = 32'h00000006;
//	defparam r6.INIT = 32'h00000001;

	//andi
//	defparam PC_register.INIT_PC = 32'h00000007;
//	defparam r6.INIT = 32'hFFFFFFFF;
	
	//andi
//	defparam PC_register.INIT_PC = 32'h00000008;
//	defparam r6.INIT = 32'h00000000;

	//jr
//	defparam PC_register.INIT_PC = 32'h00000009;
//	defparam r8.INIT = 32'h00000036;
	
	//jal
	defparam PC_register.INIT_PC = 32'h0000000A;
	defparam r8.INIT = 32'h00000036;
	defparam r5.INIT = 32'h00000015;



	
endmodule