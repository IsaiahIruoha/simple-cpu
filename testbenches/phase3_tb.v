`timescale 1ns/10ps

module phase3_tb;
	reg clock, reset, stop;
	wire [31:0] device_data, OutPort_data_out;
	
	wire [31:0] mdr_data_out, PC_data, bus_data, IR_data, mar_data, R0_data, R1_data, R2_data, R3_data, R4_data, R5_data, R6_data, R7_data, R8_data, R9_data, R10_data, Z_data, Y_data;
	wire [7:0] present_state;
	wire [4:0] operation;
	wire [63:0] c_data;
	wire Zin, Read, MDRin, CONout, Yin, CONin;

datapath DUT(.clock(clock), .reset(reset), .stop(stop), .device_data(inport_data), .OutPort_data_out(OutPort_data));

 assign mdr_data_out = DUT.mdr_unit.MDRout;
 assign bus_data = DUT.bus_data;
 assign PC_data = DUT.PC_data_out;
 assign present_state = DUT.control.present_state;
 assign IR_data = DUT.IR_data_out;
 assign mar_data = DUT.MAR_data_out;
 assign R0_data = DUT.R0_data_out;
 assign R1_data = DUT.R1_data_out;
 assign R2_data = DUT.R2_data_out;
 assign R3_data = DUT.R3_data_out;
 assign R4_data = DUT.R4_data_out;
 assign R5_data = DUT.R5_data_out;
 assign R6_data = DUT.R6_data_out;
 assign R7_data = DUT.R7_data_out;
 assign R8_data = DUT.R8_data_out;
 assign R9_data = DUT.R9_data_out;
 assign R10_data = DUT.R10_data_out;
 assign Z_data = DUT.ZLow_data_out;
 assign operation = DUT.operation;
 assign c_data = DUT.c_data_out;
 assign Zin = DUT.Z_low_enable;
 assign Read = DUT.Read;
 assign MDRin = DUT.MDR_enable;
 assign Y_data = DUT.Y_data_out;
 assign CONout = DUT.CON_output;
 assign Yin = DUT.Y_enable;
 assign CONin = DUT.CON_in;
// assign D = DUT.conff_unit.flip_flop.D;
// assign Q = DUT.conff_unit.flip_flop.Q;
// assign CON = DUT.conff_unit.CON;
 
initial
	begin
		clock = 0;
		reset = 1;
		stop = 0;
		#20 reset = 0;
end

always
		#10 clock <= ~clock;

endmodule