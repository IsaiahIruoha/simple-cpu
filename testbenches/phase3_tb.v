`timescale 1ns/10ps

module phase3_tb;
	reg clock, reset, stop;
	wire [31:0] device_data, OutPort_data_out;
	
	wire [31:0] mdr_data_out, PC_data, bus_data, IR_data, mar_data, R4_data, Z_data;
	wire [7:0] present_state;
	wire [4:0] operation;
	wire [63:0] c_data;
	wire Zin, Read, MDRin;

datapath DUT(.clock(clock), .reset(reset), .stop(stop), .device_data(inport_data), .OutPort_data_out(OutPort_data));

 assign mdr_data_out = DUT.mdr_unit.MDRout;
 assign bus_data = DUT.bus_data;
 assign PC_data = DUT.PC_data_out;
 assign present_state = DUT.control.present_state;
 assign IR_data = DUT.IR_data_out;
 assign mar_data = DUT.MAR_data_out;
 assign R4_data = DUT.R4_data_out;
 assign Z_data = DUT.ZLow_data_out;
 assign operation = DUT.operation;
 assign c_data = DUT.c_data_out;
 assign Zin = DUT.Z_low_enable;
 assign Read = DUT.Read;
 assign MDRin = DUT.MDR_enable;
 
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