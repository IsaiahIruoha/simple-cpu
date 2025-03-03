module decoder_4_to_16 (
    input wire [3:0] decoderInput,   // 4-bit input
    output reg [15:0] decoderOutput  // 16-bit output
);
    always @(*) begin
        case (decoderInput)
            4'd0: decoderOutput = 16'b0000000000000001;
            4'd1: decoderOutput = 16'b0000000000000010;
            4'd2: decoderOutput = 16'b0000000000000100;
            4'd3: decoderOutput = 16'b0000000000001000;
            4'd4: decoderOutput = 16'b0000000000010000;
            4'd5: decoderOutput = 16'b0000000000100000;
            4'd6: decoderOutput = 16'b0000000001000000;
            4'd7: decoderOutput = 16'b0000000010000000;
            4'd8: decoderOutput = 16'b0000000100000000;
            4'd9: decoderOutput = 16'b0000001000000000;
            4'd10: decoderOutput = 16'b0000010000000000;
            4'd11: decoderOutput = 16'b0000100000000000;
            4'd12: decoderOutput = 16'b0001000000000000;
            4'd13: decoderOutput = 16'b0010000000000000;
            4'd14: decoderOutput = 16'b0100000000000000;
            4'd15: decoderOutput = 16'b1000000000000000;
            default: decoderOutput = 16'b0000000000000000; // Default to zero if input is out of range
        endcase
    end
endmodule
