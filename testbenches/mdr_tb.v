`timescale 1ns/1ps

module mdr_testbench;

   // Clock and reset
   reg  clock, clear;

   // Control signals for the MDR
   reg  MDR_enable;   // enables loading the MDR at next rising clock
   reg  Read;         // selects Bus (Read=0) vs. Mdatain (Read=1)

   // The data we want to load if Read=1
   reg  [31:0] MDR_data_in;

   // We'll watch this to see what's in MDR
   wire [31:0] MDR_data_out; 

   // The datapath’s bus output
   wire [31:0] bus_data;

   // encoder input (32 bits) for selecting the bus source
   reg  [31:0] encoder_input;

   // Instantiate the datapath (which includes MDR)
   // NOTE: We’re using all registers or signals, 
   datapath UUT (
       .clock       (clock),
       .clear       (clear),

       // One-hot bus select
       .encoder_input (encoder_input),

       // MDR control signals
       .MDR_enable  (MDR_enable),
       .Read        (Read),
       .MDR_data_in (MDR_data_in),
       .MDR_data_out(MDR_data_out),

       // The bus output
       .bus_data    (bus_data)
   );

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

      // We'll “force” the bus to have a known value by selecting
      // the "C_sign_extended" input.  In the datapath code,
      // "C_sign_extended" is an internal wire named that, so we can 
      force UUT.C_sign_extended = 32'h11111111;

      // Now pick that as the bus source by setting bit 23 => 2^23:
      encoder_input = 32'h00800000;  // bit 23 => "C_sign_extended"
      // We want the MDR to load from the bus, so Read=0:
      Read = 0;
      // Enable the MDR for one clock
      MDR_enable = 1;
      #10;   // Wait one rising edge
      MDR_enable = 0;

      // At this point, the MDR should contain 0x11111111.
      // If we want to see that on the bus, set bit 21 => “MDRout” in the MUX:
      encoder_input = 32'h00200000;  // bit 21 => MDR_data_out -> bus
      #10; // observe bus_data in waveforms

      // Now we’ll put a new value into Mdatain 
      // and set Read=1 so the MDR mux picks Mdatain.
      MDR_data_in = 32'hDEADBEEF;
      Read = 1;
      MDR_enable = 1;
      #10;
      MDR_enable = 0;

      // MDR now holds 0xDEADBEEF.  Show it on the bus again:
      encoder_input = 32'h00200000; // pick MDR -> bus
      #10; // check bus_data
     
      #20;
      $stop;
   end

endmodule
