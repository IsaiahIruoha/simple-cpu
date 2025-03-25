module ram2 #(parameter init_RAM_data_out = 0) (
    output reg [31:0] RAM_data_out,  // output declaration
    input [31:0] RAM_data_in,        // input declaration
    input [7:0] address,             // address input
    input clk,                     // clock input
    input write_enable,              // write enable input
    input read_enable                // read enable input
);

(* ram_init_file = "phase4_david.mif" *)

reg [31:0] mem [511:0];


initial begin

	 $readmemh("phase3.mif", mem); 
	
    RAM_data_out = init_RAM_data_out;

end


always @(posedge clk) begin

    if (write_enable == 1) begin
        mem[address] <= RAM_data_in;
    end

    if(read_enable == 1) begin
        RAM_data_out <= mem[address];
    end
end

endmodule
