`timescale 1ns/1ps

module mdr_tb;

   // Clock and reset
   reg  clock, clear;

   // Control signals for the MDR
   reg  MDR_enable;   // enables loading the MDR at next rising clock
   reg  Read;         // selects Bus (Read=0) vs. Mdatain (Read=1)
   
   reg  [31:0] MDR_data_in;
//   wire [31:0] MDR_data_out; 

   wire [31:0] bus_data;

   reg  [31:0] encoder_input;

   datapath UUT (
       .clock       (clock),
       .clear       (clear),

       // One-hot bus select
       .encoder_input (encoder_input),

       // MDR control signals
       .MDR_enable  (MDR_enable),
       .Read        (Read),
       .MDR_data_in (MDR_data_in),

       // The bus output
       .bus_data    (bus_data)
   );

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

      force UUT.C_sign_extended = 32'h11111111;

      encoder_input = 32'h00800000; 

      Read = 0;
   
      MDR_enable = 1;
      #10;   
      MDR_enable = 0;
      
      encoder_input = 32'h00200000; 
      #10; // observe bus_data in waveforms

      MDR_data_in = 32'hDEADBEEF;
      Read = 1;
      MDR_enable = 1;
      #10;
      MDR_enable = 0;

      encoder_input = 32'h00200000; 
      #10; // check bus_data
     
      #20;
      $stop;
   end

endmodule
