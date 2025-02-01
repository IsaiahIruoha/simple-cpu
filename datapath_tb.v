`timescale 1ns/1ps

module datapath_tb;

   reg clock, clear;
   reg R0_enable, R1_enable, R2_enable, R3_enable;
   reg [4:0] mux_select_signal;
   reg [31:0] external_data;

   // Wires to observe
   wire [31:0] R0_data, R1_data, R2_data, R3_data;
   wire [31:0] bus_data;

   // Instantiate the datapath
   datapath UUT (
       .clock(clock),
       .clear(clear),
       .R0_enable(R0_enable),
       .R1_enable(R1_enable),
       .R2_enable(R2_enable),
       .R3_enable(R3_enable),
       .mux_select_signal(mux_select_signal),
       .external_data(external_data),
       .R0_data(R0_data),
       .R1_data(R1_data),
       .R2_data(R2_data),
       .R3_data(R3_data),
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
       R0_enable = 0; R1_enable = 0; R2_enable = 0; R3_enable = 0;
       mux_select_signal = 5'b00000; 
       external_data = 32'h00000000;

       // Wait a couple of clock edges
       #10;
       clear = 0;  // release reset

       // 1) Load R0 with some external data
       external_data = 32'hDEADBEEF;       // data we want to store
       mux_select_signal = 5'b10111;       // select 'external_data' input in the mux
       R0_enable = 1;                     // turn on R0's load
       #10;                               // wait one clock edge
       R0_enable = 0;                     // latch done

       // 2) Now drive R0 → bus → R1
       //    We pick R0's output in the mux:
       mux_select_signal = 5'b00000;  // 00000 = R0
       R1_enable = 1;
       #10;                          // wait a clock 
       R1_enable = 0;

       // 3) Check that R1 got the value from R0
       //    We can just wait and observe waveforms, 
       //    or do a quick if-check here:
       #1;  // small delay to let the register update
       if (R1_data == 32'hDEADBEEF)
           $display("PASS: R1 got DEADBEEF from R0!");
       else
           $display("FAIL: R1 != DEADBEEF! R1=%h", R1_data);

       // 4) Optionally do more transfers...
       // e.g., R1 → bus → R2, or external_data → R3, etc.

       // End simulation
       #20;
       $stop;
   end

endmodule
