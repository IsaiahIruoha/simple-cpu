`timescale 1ns/1ps

module register_transfer_tb;

    // Declare inputs as reg type for driving signals
    reg clock, clear;
    reg [31:0] encoder_input;
    reg MDR_enable, Read;
    reg [31:0] MDR_data_in;

    // Declare the outputs as wire
    wire [31:0] bus_data;
    wire [31:0] MDR_data_out;

    // Declare the enable signals for various registers
    reg R0_enable, R1_enable, R2_enable, R3_enable, R4_enable, R5_enable;
    reg R6_enable, R7_enable, R8_enable, R9_enable, R10_enable, R11_enable;
    reg R12_enable, R13_enable, R14_enable, R15_enable;

    // Clock generation
    always begin
        #5 clock = ~clock;
    end

    // Instantiate the DUT (Device Under Test)
    datapath_mdr_test uut (
        .clock(clock),
        .clear(clear),
        .encoder_input(encoder_input),
        .MDR_enable(MDR_enable),
        .Read(Read),
        .MDR_data_in(MDR_data_in),
        .bus_data(bus_data)
    );

    // Test sequence
    initial begin
        // Initialize signals
        clock = 0;
        clear = 1;
        encoder_input = 32'h0;
        MDR_enable = 0;
        Read = 0;
        MDR_data_in = 32'h0;
        R0_enable = 0;
        R1_enable = 0;
        R2_enable = 0;
        R3_enable = 0;
        R4_enable = 0;
        R5_enable = 0;
        R6_enable = 0;
        R7_enable = 0;
        R8_enable = 0;
        R9_enable = 0;
        R10_enable = 0;
        R11_enable = 0;
        R12_enable = 0;
        R13_enable = 0;
        R14_enable = 0;
        R15_enable = 0;

        // Apply reset
        #10 clear = 0;

        // Test 1: Test R0 register enable
        #10 R0_enable = 1;
        MDR_data_in = 32'h12345678;  // Sample input data for MDR
        // Let the clock run to capture data
        #10 R0_enable = 0;

        // Test 2: Test MDR operation (enable and read data)
        #10 MDR_enable = 1;
        Read = 1;
        // Let the clock run to capture data
        #10 MDR_enable = 0;
        Read = 0;

        // Test 3: Test encoder input driving the mux
        #10 encoder_input = 32'hA5A5A5A5;
        // Let the clock run to see the result
        #10 encoder_input = 32'h5A5A5A5A;

        // Test 4: Test R1 register enable
        #10 R1_enable = 1;
        MDR_data_in = 32'h87654321;
        // Let the clock run to capture data
        #10 R1_enable = 0;

        // Test 5: Test R0 and R1 together for bus data
        #10 R0_enable = 1;
        R1_enable = 1;
        MDR_data_in = 32'hFEDCBA98;
        // Let the clock run to capture data
        #10 R0_enable = 0;
        R1_enable = 0;

        // Finish the simulation
        #10 $finish;
    end

    // Monitor the bus data for debugging
    initial begin
        $monitor("At time %t, Bus Data: %h", $time, bus_data);
    end
endmodule
