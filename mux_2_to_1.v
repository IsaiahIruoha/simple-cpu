module mux_2_to_1 (input wire [31:0] in1, input wire [31:0] in2, input wire signal, output reg [31:0] out);

  always @(*)begin 
    if (signal) begin
      out[31:0] <= in2[31:0];
    end
    else begin
      out[31:0] <= in1[31:0]; 
    end
  end
endmodule 
