`timescale 1ns/10ps
module and_tb;
 reg PCout, Zlowout, MDRout, R3out, R7out;
 reg MARin, Zin, PCin, MDRin, IRin, Yin;
 reg IncPC, Read, AND, R3in, R4in, R7in;
 reg Clock;
 reg [31:0] Mdatain;
 wire [4:0] operation;
 wire [31:0] bus_data;
 wire [31:0] mdr_data_out;
 wire [4:0] encoder_output;
 reg [31:0] encoder_input;
 wire [31:0] reg3_data;

parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
 Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
 T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
 
 reg [3:0] Present_state = Default;

datapath DUT(PCout, Zlowout, MDRout, R3out, R7out, MARin, Zin, PCin, MDRin, IRin, Yin, IncPC, Read, AND, R3in,
R4in, R7in, Clock, Mdatain, operation, encoder_input);

initial begin
    Clock = 0;
    forever #10 Clock = ~Clock;
end

always @(posedge Clock) begin
    case (Present_state)
        Default : Present_state = Reg_load1a;
        Reg_load1a : Present_state = Reg_load1b;
        Reg_load1b : Present_state = Reg_load2a;
        Reg_load2a : Present_state = Reg_load2b;
        Reg_load2b : Present_state = Reg_load3a;
        Reg_load3a : Present_state = Reg_load3b;
        Reg_load3b : Present_state = T0;
        T0 : Present_state = T1;
        T1 : Present_state = T2;
        T2 : Present_state = T3;
        T3 : Present_state = T4;
        T4 : Present_state = T5;
    endcase
end

 assign mdr_data_out = DUT.mdr_unit.MDRout;
 assign bus_data = DUT.bus_data;
 assign encoder_output = DUT.bus_encoder.encoderOutput;
 assign reg3_data = DUT.R3_data_out;

always @(Present_state) begin
    case (Present_state)
        Default: begin
            PCout <= 0; Zlowout <= 0; MDRout <= 0;
            R3out <= 0; R7out <= 0; MARin <= 0; Zin <= 0;
            PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
            IncPC <= 0; Read <= 0; AND <= 0;
            R3in <= 0; R4in <= 0; R7in <= 0; 
            Mdatain <= 32'h00000000;
        end

        // Load value 0x22 into R3
        Reg_load1a: begin
            Mdatain <= 32'h00000022;
            Read <= 1; MDRin <= 1; // place value in MDR
				encoder_input = 32'h00200000; //place on bus
//            #5 Read <= 0; MDRin <= 0;
        end
        Reg_load1b: begin
				R3in <= 1;
            #10 MDRout <= 0; R3in <= 0;
        end

        // Load value 0x24 into R7
        Reg_load2a: begin
				R3in <= 1;
            Mdatain <= 32'h00000024;
            Read <= 1; MDRin <= 1;
            #10 Read <= 0; MDRin <= 0;
        end
        Reg_load2b: begin
            MDRout <= 1; R7in <= 1;
            #10 MDRout <= 0; R7in <= 0;
        end

        // Load value 0x28 into R4
        Reg_load3a: begin
            Mdatain <= 32'h00000028;
            Read <= 1; MDRin <= 1;
            #10 Read <= 0; MDRin <= 0;
        end
        Reg_load3b: begin
            MDRout <= 1; R4in <= 1;
            #10 MDRout <= 0; R4in <= 0;
        end

        // Start AND operation (AND R4, R3, R7)
        T0: begin
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            #10 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
        end

        T1: begin
            Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
            Mdatain <= 32'h2A2B8000; // opcode for AND R4, R3, R7
            #10 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
        end

        T2: begin
            MDRout <= 1; IRin <= 1;
            #10 MDRout <= 0; IRin <= 0;
        end

        T3: begin
            R3out <= 1; Yin <= 1;
            #10 R3out <= 0; Yin <= 0;
        end

        T4: begin
            R7out <= 1; AND <= 1; Zin <= 1;
            #10 R7out <= 0; AND <= 0; Zin <= 0;
        end

        T5: begin
            Zlowout <= 1; R4in <= 1;
            #10 Zlowout <= 0; R4in <= 0;
        end
    endcase
end

endmodule
