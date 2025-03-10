module select_encode_ir(
	input wire [31:0] IR,
	input wire GRA, GRB, GRC, Rin, Rout, BAout,
	output [15:0] RinSignals,
	output [15:0] RoutSignals,
	output wire [31:0] C_sign_extended
);

	wire [3:0] decoderInput;
	wire [15:0] decoderOutput;

	assign decoderInput = (IR[26:23] & {4{GRA}}) | (IR[22:19] & {4{GRB}}) | (IR[18:15] & {4{GRC}});

	decoder_4_to_16 decoder(decoderInput, decoderOutput);

	assign C_sign_extended = {{13{IR[18]}},IR[18:0]};
	
	assign RoutSignals = ({16{Rout}} | {16{BAout}}) & decoderOutput;

	assign RinSignals = {16{Rin}} & decoderOutput;


endmodule