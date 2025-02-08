`timescale 1ns/10ps

module div_tb;
 reg PCout, Zlowout, Zhighout, MDRout, R2out, R6out;
 reg MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
 reg IncPC, Read, AND, R2in, R6in, LOin, HIin;
 reg Clock;
 reg [31:0] Mdatain;
 reg [4:0] operation;
 wire [31:0] bus_data;
 wire [31:0] mdr_data_out;
 wire [4:0] encoder_output;
 wire [31:0] encoder_input;
 wire [31:0] reg2_data, reg6_data, lo_data, hi_data, IR_data, Y_data, z_low_data, z_high_data, PC_data;
 wire [63:0] c_data;
 reg R1out,R0out,R3out,R7out,R5out,R4out,ZHighout,LOout,HIout,R15out,R14out,R13out,R12out,R11out,R10out,R9out,R8out,Cout,InPortout;

parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101;
 
reg [3:0] Present_state = Default;

datapath_2reg DUT(PCout, Zlowout, Zhighout, MDRout, R2out, R6out, MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin, IncPC, Read, AND, R2in,
R6in, LOin, HIin, Clock, R0out,R1out,R3out,R4out,R5out,R7out,R8out,R9out,R10out,R11out,R12out,R13out,R14out,R15out,LOout,HIout,Cout,InPortout, Mdatain, operation, encoder_input);

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
        Reg_load2b :  Present_state = T0;
        T0 :  Present_state = T1;
        T1 :  Present_state = T2;
        T2 :  Present_state = T3;
        T3 :  Present_state = T4;
        T4 :  Present_state = T5;
		  T5 :  Present_state = T6;
    endcase
end

 assign mdr_data_out = DUT.mdr_unit.MDRout;
 assign bus_data = DUT.bus_data;
 assign encoder_output = DUT.bus_encoder.encoderOutput;
 assign encoder_input = DUT.bus_encoder.encoderInput;
 assign reg2_data = DUT.R2_data_out;
 assign reg6_data = DUT.R6_data_out;
 assign lo_data = DUT.LO_data_out;
 assign hi_data = DUT.HI_data_out;
 assign IR_data = DUT.IR_data_out;
 assign Y_data = DUT.Y_data_out;
 assign c_data = DUT.c_data_out;
 assign z_low_data = DUT.ZLow_data_out;
 assign z_high_data = DUT.ZHigh_data_out;
 assign PC_data = DUT.PC_data_out;

always @(Present_state) begin
    case (Present_state)
        Default: begin
            PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
            R3out <= 0; R7out <= 0; MARin <= 0; Zlowin <= 0; Zhighin <= 0;
            PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
            IncPC <= 0; Read <= 0; AND <= 0;
            R2in <= 0; R6in <= 0;
				LOin <= 0; HIin <=0;
				R2out <= 0;R1out<= 0;R0out<= 0;R6out<= 0;R5out<= 0;R4out<= 0;ZHighout<= 0;LOout<= 0;HIout<= 0;R15out<= 0;
				R14out<= 0;R13out<= 0;R12out<= 0;R11out<= 0;R10out<= 0;R9out<= 0;R8out<= 0;Cout<= 0;InPortout<= 0;
            Mdatain <= 32'h00000000;
        end

        // Load value 0x22 into R2
        Reg_load1a: begin
            Mdatain<= 32'h00000024;
				MDRout <= 1;
			   Read <= 1; MDRin <= 1;				
				#15 Read <= 0; MDRin <= 0; R2in <= 1;
        end
        Reg_load1b: begin
				R2in = 1; 
				#5 MDRout<= 0; R2in <= 0; 
        end
			
        // Load value 0x24 into R6
        Reg_load2a: begin
            Mdatain <= 32'h00000022;
				MDRout <= 1;
				Read <= 1; MDRin <= 1;				
				#15 Read <= 0; MDRin <= 0; R6in <= 1;
        end
        Reg_load2b: begin
				R6in = 1; 
				#5 MDRout <= 0; R6in <= 0;
				#5 IncPC <= 1;
        end

        // Start DIV operation (DIV R2, R6)
        T0: begin
            PCout <= 1; MARin <= 1; IncPC <= 1; MDRout <= 1;
            #10 PCout <= 0; MARin <= 0; PCin <= 1;
        end

        T1: begin
            PCin <= 1; Read <= 1; MDRin <= 1; MDRout <= 1;
            Mdatain <= 32'h2A2B8000;
            #10 PCin <= 0; Read <= 0; MDRin <= 0; IRin <= 1; IncPC <= 0;
        end

        T2: begin
            MDRout <= 1; IRin <= 1; 
            #10 MDRout <= 0; IRin <= 0; 
        end

        T3: begin
            R2out <= 1; 
				#5 Yin <= 1;
				#10 Yin <= 0; R2out <= 0;
        end

        T4: begin
            R6out <= 1; AND <= 1; Zlowin <= 1; Zhighin <= 1; operation <= 5'b01111;
            #10 R6out <= 0; AND <= 0; Zlowin <= 0; Zhighin <= 0;
				#5 Zlowout <= 1; LOin <= 1;
        end

        T5: begin
            #10 Zlowout <= 0; LOin <= 0;
				#5 Zhighout <= 1; HIin <= 1;
        end
		  
		  T6: begin
				#15 Zhighout <= 0; HIin <= 0;
		  end
    endcase 
   end
endmodule
