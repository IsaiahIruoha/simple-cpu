`timescale 1ns/10ps

module shra_tb;
 reg PCout, Zlowout, MDRout, R3out, R7out;
 reg MARin, Zin, PCin, MDRin, IRin, Yin;
 reg IncPC, Read, AND, R3in, R4in, R7in;
 reg Clock;
 reg [31:0] Mdatain;
 reg [4:0] operation;
 wire [31:0] bus_data;
 wire [31:0] mdr_data_out;
 wire [4:0] encoder_output;
 wire [31:0] encoder_input;
 wire [31:0] reg3_data, reg7_data, reg4_data, IR_data, Y_data, z_low_data, z_high_data, PC_data;
 wire [63:0] c_data;
 reg R2out,R1out,R0out,R6out,R5out,R4out,ZHighout,LOout,HIout,R15out,R14out,R13out,R12out,R11out,R10out,R9out,R8out,Cout,InPortout;

parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
 
reg [3:0] Present_state = Default;

datapath DUT(PCout, Zlowout, MDRout, R3out, R7out, MARin, Zin, PCin, MDRin, IRin, Yin, IncPC, Read, AND, R3in,
R4in, R7in, Clock, R2out,R1out,R0out,R6out,R5out,R4out,ZHighout,LOout,HIout,R15out,R14out,R13out,R12out,R11out,R10out,R9out,R8out,Cout,InPortout, Mdatain, operation, encoder_input);

initial begin
    Clock = 0;
    forever #10 Clock = ~Clock;
end

always @(posedge Clock) begin
    case (Present_state)
        Default :  Present_state = Reg_load1a;
        Reg_load1a :  Present_state = Reg_load1b;
        Reg_load1b :  Present_state = Reg_load2a;
        Reg_load2a :  Present_state = Reg_load2b;
        Reg_load2b :  Present_state = Reg_load3a;
        Reg_load3a :  Present_state = Reg_load3b;
        Reg_load3b :  Present_state = T0;
        T0 :  Present_state = T1;
        T1 :  Present_state = T2;
        T2 :  Present_state = T3;
        T3 :  Present_state = T4;
        T4 :  Present_state = T5;
    endcase
end

 assign mdr_data_out = DUT.mdr_unit.MDRout;
 assign bus_data = DUT.bus_data;
 assign encoder_output = DUT.bus_encoder.encoderOutput;
 assign encoder_input = DUT.bus_encoder.encoderInput;
 assign reg3_data = DUT.R3_data_out;
 assign reg7_data = DUT.R7_data_out;
 assign reg4_data = DUT.R4_data_out;
 assign IR_data = DUT.IR_data_out;
 assign Y_data = DUT.Y_data_out;
 assign c_data = DUT.c_data_out;
 assign z_low_data = DUT.ZLow_data_out;
 assign z_high_data = DUT.ZHigh_data_out;
 assign PC_data = DUT.PC_data_out;

always @(Present_state) begin
    case (Present_state)
        Default: begin
            PCout <= 0; Zlowout <= 0; MDRout <= 0;
            R3out <= 0; R7out <= 0; MARin <= 0; Zin <= 0;
            PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
            IncPC <= 0; Read <= 0; AND <= 0;
            R3in <= 0; R4in <= 0; R7in <= 0;
	    R2out <= 0;R1out<= 0;R0out<= 0;R6out<= 0;R5out<= 0;R4out<= 0;ZHighout<= 0;LOout<= 0;HIout<= 0;R15out<= 0;
	    R14out<= 0;R13out<= 0;R12out<= 0;R11out<= 0;R10out<= 0;R9out<= 0;R8out<= 0;Cout<= 0;InPortout<= 0;
            Mdatain <= 32'h00000000;
        end

        // Load value 0x22 into R3
        Reg_load1a: begin
                Mdatain<= 32'hFFFFFFDE;
	        MDRout <= 1;
		Read <= 1; MDRin <= 1;				
		#15 Read <= 0; MDRin <= 0; R3in <= 1;
        end
        Reg_load1b: begin
		R3in = 1; 
		#5 MDRout<= 0; R3in <= 0; 
        end
			
        // Load value 0x24 into R7
        Reg_load2a: begin
                Mdatain <= 32'h00000024;
		MDRout <= 1;
		Read <= 1; MDRin <= 1;				
		#15 Read <= 0; MDRin <= 0; R7in <= 1;
        end
        Reg_load2b: begin
		R7in = 1; 
		#5 MDRout <= 0; R7in <= 0;
        end

        // Load value 0x28 into R4
        Reg_load3a: begin
                Mdatain <= 32'h00000028;
		MDRout <= 1;
		Read <= 1; MDRin <= 1;				
		#15 Read <= 0; MDRin <= 0; R4in <= 1;
        end
        Reg_load3b: begin
                R4in = 1; 
		#5 MDRout<= 0; R4in <= 0;
		#5 IncPC <= 1;
        end

        // Start AND operation (AND R4, R3, R7)
        T0: begin
            PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1; MDRout <= 1;
            #10 PCout <= 0; MARin <= 0; Zin <= 0; PCin <= 1;
        end

        T1: begin
            Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1; MDRout <= 1;
            Mdatain <= 32'h2A2B8000; // opcode for AND R4, R3, R7
            #10 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0; IRin <= 1; IncPC <= 0;
        end

        T2: begin
            MDRout <= 1; IRin <= 1; 
            #10 MDRout <= 0; IRin <= 0; 
        end

        T3: begin
            R3out <= 1; 
	    #5 Yin <= 1;
	    #10 Yin <= 0; R3out <= 0;
        end

        T4: begin
            R7out <= 1; AND <= 1; Zin <= 1; operation <= 5'b01010;
            #10 R7out <= 0; AND <= 0; Zin <= 0;
	    #5 Zlowout <= 1; R4in <= 1;
        end

        T5: begin
            #10 Zlowout <= 0; R4in <= 0;
        end
    endcase 
   end
endmodule
