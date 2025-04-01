`timescale 1ns/1ps

module mdr_to_bus_tb;

   reg  clock, clear;

   reg  MDR_enable;   // enables loading the MDR at next rising clock
   reg  Read;         // selects Bus (Read=0) vs. Mdatain (Read=1)

   reg  [31:0] MDR_data_in;
	
	wire [31:0] MDR_data_out;

	wire [4:0] encoder_output;
	wire [31:0] r0_output;

   wire [31:0] bus_data;

   reg  [31:0] encoder_input;

   datapath_mdr_test UUT (
       .clock       (clock),
       .clear       (clear),
       .encoder_input (encoder_input),
       .MDR_enable  (MDR_enable),
       .Read        (Read),
		 .MDR_data_out(MDR_data_out),
       .MDR_data_in (MDR_data_in)
//       .bus_data    (bus_data)
   );
	
	assign encoder_output = UUT.bus_encoder.encoderOutput;
	assign r0_output = UUT.R0_data_out;
	assign bus_data = UUT.bus_data;

   initial begin
      clock = 0;
      forever #5 clock = ~clock;
   end
  
   initial begin
      // 1) Initialize
      clear       = 1;
      MDR_enable  = 0;
      Read        = 0;
      MDR_data_in = 32'h00000000;
      encoder_input = 32'h00000000;

      #20 clear = 0;  // de-assert reset

      MDR_data_in = 32'hA5A5A5A5; // Example data
      Read = 1; // Select Mdatain
      MDR_enable = 1;
      #10;
//      MDR_enable = 0;
      encoder_input = 32'h00200000; // Select MDRout
      #10; // Observe bus_data in waveforms
     
      #20;
      $stop;
   end

endmodule
