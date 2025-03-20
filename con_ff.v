module con_ff(
    input wire clk,             
    input wire D,
	 input wire CON_in,
    output reg Q          
);

	initial Q = 1'd0;

    always @(negedge clk) begin
			if(CON_in)
            Q <= D; 
    end

endmodule
