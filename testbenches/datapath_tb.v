`timescale 1ns/1ps

module datapath_tb;

   reg clock, clear;
	reg R0_enable, R1_enable, R2_enable;
	reg [31:0] encoder_input;
   reg [31:0] external_data;

   // Wires to observe
	wire [31:0] r0_data, r1_data, r2_data;
   wire [31:0] bus_data;

   // Instantiate the datapath
   datapath UUT (
       .clock(clock),
       .clear(clear),
		 .R0_enable(R0_enable),
		 .R1_enable(R1_enable),
		 .R2_enable(R2_enable),
       .external_data(external_data),
		 .R0_data(r0_data),
		 .R1_data(r1_data),
		 .R2_data(r2_data),
		 .encoder_input(encoder_input),
       .bus_data(bus_data)
   );

   // Generate a clock
   initial begin
       clock = 0;
       forever #5 clock = ~clock;  // 10ns period
   end

   // Test stimulus
   initial begin
       // Initialize
       clear = 1;   // reset all registers to 0
		 R0_enable = 0; R1_enable = 0; R2_enable = 0; 
       encoder_input = 32'h00000000;
       external_data = 32'h00000000;

       // Wait a couple of clock edges
       #10;
       clear = 0;  // release reset

       // 1) Load R0 with some external data
       external_data = 32'hDEADBEEF;       // data we want to store
       encoder_input = 32'b00000000100000000000000000000000;       // select 'external_data' input in the mux
       R0_enable = 1;
		 #10;                               // wait one clock edge
		 R0_enable = 0;

       // 2) Now drive R0 → bus → R1
       //    We pick R0's output in the mux:
       encoder_input = 32'h00000001;  // 00000 = R0
		 R1_enable = 1;
		 #10;                               // wait one clock edge
		 R1_enable = 0;

       // End simulation
       #20;
       $stop;
   end

endmodule
