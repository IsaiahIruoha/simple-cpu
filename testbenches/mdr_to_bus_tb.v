`timescale 1ns/1ps

module mdr_to_bus_tb;

   // Clock and reset
   reg  clock, clear;

   // Control signals for the MDR
   reg  MDR_enable;   // enables loading the MDR at next rising clock
   reg  Read;         // selects Bus (Read=0) vs. Mdatain (Read=1)

   // The data to be loaded into the MDR
   reg  [31:0] MDR_data_in;
	
	wire [31:0] MDR_data_out;

	// trying to see outputs
	wire [4:0] encoder_output;
	wire [31:0] r0_output;

   // The datapath’s bus output
   wire [31:0] bus_data;

   // Encoder input for selecting the bus source
   reg  [31:0] encoder_input;

   // Instantiate the datapath (which includes MDR)
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
	
//	assign MDR_data_out = UUT.mdr_unit.MDRout;
	assign encoder_output = UUT.bus_encoder.encoderOutput;
	assign r0_output = UUT.R0_data_out;
	assign bus_data = UUT.bus_data;

   // Generate a clock (10 ns period)
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

      // Wait a couple of clock cycles
      #20 clear = 0;  // de-assert reset

      // Load MDR with a value from Mdatain
      MDR_data_in = 32'hA5A5A5A5; // Example data
      Read = 1; // Select Mdatain
      MDR_enable = 1;
      #10;
//      MDR_enable = 0;

      // Now place MDR data onto the bus
      encoder_input = 32'h00200000; // Select MDRout
      #10; // Observe bus_data in waveforms
     
      #20;
      $stop;
   end

endmodule
