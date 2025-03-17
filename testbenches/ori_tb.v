`timescale 1ns/10ps

module ori_tb;
 reg PCout, Zlowout, MDRout;
 reg MARin, Zin, PCin, MDRin, IRin, Yin;
 reg IncPC, Read, Write, AND;
 reg Clock;
 reg [31:0] Mdatain;
 reg [4:0] operation;
 wire [31:0] bus_data;
 wire [31:0] mdr_data_out;
 wire [31:0] mar_data;
 wire [4:0] encoder_output;
 wire [31:0] encoder_input;
 wire [31:0] reg5_data, reg6_data, reg4_data, IR_data, Y_data, z_low_data, z_high_data, PC_data;
 wire [63:0] c_data;
 reg ZHighout,LOout,HIout,Cout,InPortout;
 reg GRA, GRB, GRC, Rin, Rout, BAout;
 reg [15:0] Register_enable_Signals, RoutSignals;
 wire [15:0] ir_enable_signals, ir_output_signals;
 wire [15:0] decoder_output, test_out, test_in;
 reg CON_in;
 wire CON_out;
wire [31:0] c_sign_extended;

parameter Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110;
 
reg [3:0] Present_state = Default;

 datapath DUT(PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, IncPC, Read, Write, AND, Clock,
                 ZHighout, LOout, HIout, Cout, InPortout, GRA, GRB, GRC, Rin, Rout, BAout,
                 operation, encoder_input, Register_enable_Signals, CON_in, CON_out);
					  

initial begin
    Clock = 0;
    forever #10 Clock = ~Clock;
end

always @(posedge Clock) begin
    case (Present_state)
        Default :  Present_state = T0;
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
 assign reg5_data = DUT.R5_data_out;
 assign reg6_data = DUT.R6_data_out;
 assign reg4_data = DUT.R4_data_out;
 assign IR_data = DUT.IR_data_out;
 assign Y_data = DUT.Y_data_out;
 assign c_data = DUT.c_data_out;
 assign z_low_data = DUT.ZLow_data_out;
 assign z_high_data = DUT.ZHigh_data_out;
 assign PC_data = DUT.PC_data_out;
 assign decoder_output = DUT.ir_encode.decoder.decoderOutput;
 assign test_out = DUT.ir_encode.RoutSignals;
 assign test_in = DUT.ir_encode.RinSignals;
 assign ir_enable_signals = DUT.ir_enable_signals;
 assign ir_output_signals = DUT.ir_output_signals;
 assign c_sign_extended = DUT.C_sign_extended;
 assign mar_data = DUT.MAR_data_out;

always @(Present_state) begin
    case (Present_state)
        Default: begin
				PCout <= 1; Zlowout <= 0; MDRout <= 0;
            MARin <= 1; Zin <= 0;
            PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
            IncPC <= 1; Read <= 0; Write <= 0; AND <= 0;
				Rin <= 0; Rout <= 0;
				GRA <= 0; GRB <= 0; GRC <= 0; BAout <= 0;
				Register_enable_Signals <= 16'd0; RoutSignals <= 16'd0;
				HIout <= 0; LOout <= 0; ZHighout <= 0;
				Cout<= 0;InPortout<= 0; operation <= 5'b00000;
            Mdatain <= 32'h00000000;
		  end
		  //
        T0: begin
            PCout <= 1; MARin <= 1; IncPC <= 1; MDRout <= 1;
            #10 PCout <= 0; MARin <= 0;PCin <= 1; Read <= 1;
        end
        T1: begin
            MDRin <= 1; MDRout <= 1;
            #10 PCin <= 0; Read <= 0; MDRin <= 0; IRin <= 1; IncPC <= 0;
        end
        T2: begin
            MDRout <= 1; IRin <= 1; 
            #10 MDRout <= 0; IRin <= 0; Yin <= 1; GRB <= 1; Rout <= 1;
        end
		  // ldi R4, 0x54
        T3: begin
				#10 GRB <= 0; Rout <= 0; Yin <= 0; Cout <= 1;
        end
        T4: begin
				Cout <= 1; operation <= 5'b00110; Zin <= 1;
				#10 Cout <= 0; Zin <= 0; Zlowout <= 1; GRA <= 1; Rin <= 1;
        end
        T5: begin
				Zlowout <= 0; GRA <= 0; Rin <= 0;
		  end
    endcase
   end
endmodule