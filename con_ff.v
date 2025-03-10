module con_ff(
    input wire clk,             
    input wire D,
	 input wire CON_in,
    output reg Q          
);

    always @(posedge clk) begin
			if(CON_in)
            Q <= D; 
    end

endmodule
