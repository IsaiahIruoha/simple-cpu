`timescale 1ns/10ps
module control_unit (
	output reg Gra, Grb, Grc, Rin, Rout, LOout, HIout, ZLowout, ZHighout, MDRout, PCout // define the inputs and outputs to your Control Unit here
				  BAout, Cout, OutPortin, MDRin, MARin, Yin, Zin, IRin, PCin, CONin, LOin, HIin, IncPC,
				  Read, Write, Clear, Run
				  ADD, AND, OR, SHR,
	input [31:0] IR,
	input Clock, Reset, Stop, Con_FF);
	
parameter Reset_state= 8'b00000000, fetch0 = 8'b00000001, fetch1 = 8'b00000010, fetch2= 8'b00000011,
			 add3 = 8'b00000100, add4= 8'b00000101, add5= 8'b00000110, sub3 = 8'b00000111, sub4 = 8'b00001000, sub5 = 8'b00001001,
			 mul3 = 8'b00001010, mul4 = 8'b00001011, mul5 = 8'b00001100, mul6 = 8'b00001101, div3 = 8'b00001110, div4 = 8'b00001111,
			 div5 = 8'b00010000, div6 = 8'b00010001, or3 = 8'b00010010, or4 = 8'b00010011, or5 = 8'b00010100, and3 = 8'b00010101, 
			 and4 = 8'b00010110, and5 = 8'b00010111, shl3 = 8'b00011000, shl4 = 8'b00011001, shl5 = 8'b00011010, shr3 = 8'b00011011,
			 shr4 = 8'b00011100, shr5 = 8'b00011101, rol3 = 8'b00011110, rol4 = 8'b00011111, rol5 = 8'b00100000, ror3 = 8'b00100001,
			 ror4 = 8'b00100010, ror5 = 8'b00100011, neg3 = 8'b00100100, neg4 = 8'b00100101, neg5 = 8'b00100110, not3 = 8'b00100111,
			 not4 = 8'b00101000, not5 = 8'b00101001, ld3 = 8'b00101010, ld4 = 8'b00101011, ld5 = 8'b00101100, ld6 = 8'b00101101, 
			 ld7 = 8'b00101110, ldi3 = 8'b00101111, ldi4 = 8'b00110000, ldi5 = 8'b00110001, st3 = 8'b00110010, st4 = 8'b00110011,
			 st5 = 8'b00110100, st6 = 8'b00110101, st7 = 8'b00110110, addi3 = 8'b00110111, addi4 = 8'b00111000, addi5 = 8'b00111001,
			 andi3 = 8'b00111010, andi4 = 8'b00111011, andi5 = 8'b00111100, ori3 = 8'b00111101, ori4 = 8'b00111110, ori5 = 8'b00111111,
			 br3 = 8'b01000000, br4 = 8'b01000001, br5 = 8'b01000010, br6 = 8'b01000011, br7 = 8'b11111111, jr3 = 8'b01000100, jal3 = 8'b01000101, 
			 jal4 = 8'b01000110, mfhi3 = 8'b01000111, mflo3 = 8'b01001000, in3 = 8'b01001001, out3 = 8'b01001010, nop3 = 8'b01001011, 
			 halt3 = 8'b01001100;

reg [3:0] present_state = reset_state; // adjust the bit pattern based on the number of states

always @(posedge Clock, posedge Reset) // finite state machine; if clock or reset rising-edge
	begin
		if (Reset == 1'b1) present_state = reset_state;
		if (Stop == 1'b1) present_state = halt3;
		else case (present_state)
			reset_state : present_state = fetch0;
			fetch0 : present_state = fetch1;
			fetch1 : present_state = fetch2;
			fetch2 : begin

				case (IR[31:27]) // inst. decoding based on the opcode to set the next state
					5'b00011 : present_state = add3;
					5'b00100	: present_state = sub3;
					5'b01110	: present_state = mul3;
					5'b01111	: present_state = div3;
					5'b00101	: present_state = shr3;
					5'b00110	: present_state = shl3;
					5'b00111	: present_state = ror3;
					5'b01000	: present_state = rol3;
					5'b01001	: present_state = and3;
					5'b01010	: present_state = or3;
					5'b10000	: present_state = neg3;
					5'b10001	: present_state = not3;
					5'b00000	: present_state = ld3;
					5'b00001	: present_state = ldi3;
					5'b00010	: present_state = st3;
					5'b01011	: present_state = addi3;
					5'b01100	: present_state = andi3;
					5'b01101	: present_state = ori3;
					5'b10010	: present_state = br3;
					5'b10011	: present_state = jr3;
					5'b10100	: present_state = jal3;
					5'b10111	: present_state = mfhi3;
					5'b11000	: present_state = mflo3;
					5'b10101	: present_state = in3;
					5'b10110	: present_state = out3;
					5'b11001	: present_state = nop3;
					5'b11010	: present_state = halt3;

				endcase
			end
			
		add3 : present_state = add4;
		add4 : present_state = add5;
		add5 : present_state = fetch0;
			
		addi3 : present_state = addi4;
		addi4	: present_state = addi5;
		addi5 : present_state = fetch0;
		
		sub3 : present_state = sub4;
		sub4 : present_state = sub5;
		sub5 : present_state = fetch0;
		
		mul3 : present_state = mul4;
		mul4 : present_state = mul5;
		mul5 : present_state = mul6;
		mul6 : present_state = fetch0; 
		
		div3 : present_state = div4;
		div4 : present_state = div5;
		div5 : present_state = div6;
		div6 : present_state = fetch0;
		
		or3 : present_state = or4;
		or4 : present_state = or5;
		or5 :	present_state = fetch0;
		
		and3 : present_state = and4;
		and4 : present_state = and5;
		and5 : present_state = fetch0;
		
		shl3 : present_state = shl4;
		shl4 : present_state = shl5;
		shl5 : present_state = fetch0;
		
		shr3 : present_state = shr4;
		shr4 : present_state = shr5;
		shr5 : present_state = fetch0;
		
		rol3 : present_state = rol4;
		rol4 : present_state = rol5;
		rol5 : present_state = fetch0;
		
		ror3 : present_state = ror4;
		ror4 : present_state = ror5;
		ror5 : present_state = fetch0;
		
		neg3 : present_state = neg4;
		neg4 : present_state = fetch0;
		
		not3 : present_state = not4;
		not4 : present_state = fetch0;
		
		ld3 : present_state = ld4;
		ld4 : present_state = ld5;
		ld5 : present_state = ld6;
		ld6 : present_state = ld7;
		ld7 : present_state = fetch0;
		
		ldi3 : present_state = ldi4;
		ldi4 : present_state = ldi5;
		ldi5 : present_state = fetch0;
		
		st3 : present_state = st4;
		st4 : present_state = st5;
		st5 : present_state = st6;
		st6 : present_state = st7;
		st7 : present_state = fetch0;
		
		andi3	: present_state = andi4;
		andi4 : present_state = andi5;
		andi5 : present_state = fetch0;
		
		ori3 : present_state = ori4;
		ori4 : present_state = ori5;
		ori5 : present_state = fetch0;
		
		jal3 : present_state = jal4;
		jal4 : present_state = fetch0;
		
		jr3 : present_state = fetch0;
		
		br3 : present_state = br4;
		br4 : present_state = br5;
		br5 : present_state = br6;
		br6 :	present_state = br7;
		br7 :	present_state = fetch0;
		
		out3 : present_state = fetch0;
		
		in3 :	present_state = fetch0;
		
		mflo3 : present_state = fetch0;
		
		mfhi3 : present_state = fetch0;
		
		nop3 : present_state = fetch0;

		endcase
	end
	
always @(present_state) // do the job for each state
	begin
		case (present_state) // assert the required signals in each state
			reset_state: begin
					ra <= 0; Grb <= 0; Grc <= 0; Yin <= 0; // initialize the signals

			end
				
			fetch0: begin
					PCout <= 1; MARin <= 1; IncPC <= 1; MDRout <= 1;
					#10 PCout <= 0; MARin <= 0;PCin <= 1; Read <= 1;
			end
			
			fetch1: begin
					MDRin <= 1; MDRout <= 1;
					#10 PCin <= 0; Read <= 0; MDRin <= 0; IRin <= 1; IncPC <= 0;
			end
			
			fetch2: begin
					MDRout <= 1; IRin <= 1; 
					#10 MDRout <= 0; IRin <= 0;
			end
			
			// add and subtract
			add3, sub3: begin
					Grb <= 1; Rout <= 1; Yin <= 1;
			end
			
			add4, sub4: begin
					Grb <= 0; Rout <= 0; Yin <= 0;
					Grc <= 1; Rout <= 1; Zin <= 1; 
			end
			
			add5, sub5: begin
					Grc <=0; Rout <= 0; Zin <= 0;
					ZLowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			// and, or, shl, shr, rol, ror
			or3, and3, shl3, shr3, rol3, ror3: begin	
					Grb <= 1; Rout <= 1; Yin <= 1;
			end
			
			or4, and4, shl4, shr4, rol4, ror4: begin
					Grb <=0; Rout <= 0; Yin <= 0;
					Grc <=1; Rout <= 1; ZHighIn <= 1; ZLowIn <= 1;
			end
			
			or5, and5, shl5, shr5, rol5, ror5: begin
					Grc <= 0; Rout <= 0; ZHighIn <= 0; ZLowIn <= 0;
					ZLowout <= 1; Gra <= 1; Rin <= 1;
					#10 ZLowout <= 0; Gra <= 1; Rout <= 1; Rin <= 0;
			end
			
			// mul and div
			mul3, div3: begin	
					Grb <= 1; Rout <= 1; Yin <= 1;  
			
			end
			
			mul4, div4: begin
					Grb <= 0; Rout <= 0; Yin <= 0;
					Grc <= 1; Rout <= 1; ZHighIn <= 1; ZLowIn <= 1;
			end
			
			mul5, div5: begin
					Grb <= 0; Rout <= 0; ZHighIn <= 0; ZLowIn <= 0;
					ZLowout <= 1; LOin <= 1;		
			end
			
			mul6, div6: begin
					ZLowout<= 0; LOin <= 0;
					ZHighout<= 1; HIin <= 1; 
			end
			
			// not and neg
			not3, neg3: begin	
					Grb<=1; Rout <= 1; ZHighIn <= 1; ZLowIn <= 1;
			end
			
			not4, neg4: begin
					Grb <= 0; Rout <= 0; ZHighIn <= 0; ZLowIn <= 0;
					ZLowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			// load
			ld3: begin
					Yin <= 1; GRB <= 1; BAout <= 1;
					#15 GRB <= 0; BAout <= 0; Yin <= 0; Cout <= 1;
			end
			
			ld4: begin
					Cout <= 1; operation <= 5'b00011; Zin <= 1;
					#10 Cout <= 0; Zin <= 0; Zlowout = 1; MARin = 1;
			end

			ld5: begin
					#10 Zlowout = 0; MARin = 0; Read = 1;
			end
			
			ld6: begin
					MDRin = 1;
					#10 Read = 0; 
					#5 MDRin = 0; MDRout = 1; GRA = 1; Rin = 1;
			end
			
			ld7: begin
					#10 MDRout = 0; GRA = 0; Rin = 0;
			end
			
			// ldi
			ldi3: begin
					Yin <= 1; GRB <= 1; BAout <= 1;
					#15 GRB <= 0; BAout <= 0; Yin <= 0; Cout <= 1;
			end
			
			ldi4: begin
					Cout <= 1; operation <= 5'b00011; Zin <= 1;
					#10 Cout <= 0; Zin <= 0; Zlowout <= 1; GRA <= 1; Rin <= 1;
			end
			
			ldi5: begin
					Zlowout <= 0; GRA <= 0; Rin <= 0;
			end
			
			//st
			st3: begin
					Yin <= 1; GRB <= 1; BAout <= 1;
					#15 GRB <= 0; BAout <= 0; Yin <= 0; Cout <= 1;
			end
			
			st4: begin
					Cout <= 1; operation <= 5'b00011; Zin <= 1;
					#10 Cout <= 0; Zin <= 0; Zlowout = 1; MARin = 1;
			end

			st5: begin
					#10 Zlowout = 0; MARin = 0;
					#5 GRA = 1; Rout = 1; MDRin = 1;
			end
			
			st6: begin
					#10 GRA <= 0; Rout<= 0; MDRin <= 0; 
					#5  MDRout = 1; Write <= 1;
			end
			
			st7: begin
					#10 MDRout = 0; Write <= 0;
			end
			
			// addi, ori, andi
			addi3, ori3, andi3: begin
					Yin <= 1; GRB <= 1; Rout <= 1;
					#10 GRB <= 0; Rout <= 0; Yin <= 0; Cout <= 1;
			end
			
			addi4, ori4, andi4: begin
					Cout <= 1; operation <= 5'b00101; Zin <= 1;
					#10 Cout <= 0; Zin <= 0; Zlowout <= 1; GRA <= 1; Rin <= 1;
			end
			
			addi5, ori5, andi5: begin
					Zlowout <= 0; GRA <= 0; Rin <= 0;
			end
			
			// branch
			br3: begin
					Rout <= 1; GRA <= 1; CON_in <= 1;
					#15 Rout <= 0; GRA <= 0; CONin <= 0; PCout <= 1; Yin <= 1;
			end
			
			br4: begin
					#10 PCout <= 0; Yin <= 0;
			end
			
			br5: begin
					Cout <= 1; operation <= 5'b00011; Zin <= 1;
					if (CON_out) begin
						#10 Zlowout <= 1; PCin <= 1; Cout <= 0; Zin <= 0;
					end
			end
			
			br6: begin
					#10 Zlowout <= 0; PCin <= 0;
			end
			
			// jumps
			jr3: begin
					 GRA <= 1; Rout <= 1; PCin <= 1;
					#15 GRA <= 0; Rout <= 0; PCin <= 0;
			end
			
			jal3: begin
					GRA <= 1; Rout <= 1; PCin <= 1;
					#10 PCout <= 0; RegisteRin_Signals[8] <= 0; GRA <= 1; Rout <= 1; PCin <= 1;
			end
			
			jal4: begin
					#10 GRA <= 0; Rout <= 0; PCin <= 0;
			end
			
			// mfhi mflo
			mfhi3: begin
					GRA = 1; Rin = 1; HIout = 1;
					#10 GRA <= 0; Rin <= 0; HIout <= 0;
			end
			
			mflo3: begin
					GRA <= 1; Rin <= 1; LOout <= 1;
					#10 GRA <= 0; Rin <= 0; LOout <= 0;
			end
			
			//in out
			in3: begin
					GRA <= 1; Rin <= 1; InPortout<= 1;
					#10 GRA <= 0; Rin <= 0; InPortout <= 0;
			end
			
			out3: begin
					GRA <= 1; Rout <= 1; out_in <= 1;
					#10 GRA <= 0; Rout <= 0; out_in <= 0;
			end
			
		endcase
	end
endmodule