module con_ff(
    input wire clk,         
    input wire reset,      
    input wire CON_in,      
    output reg CON          
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            CON <= 0; 
        else
            CON <= CON_in; 
    end

endmodule
