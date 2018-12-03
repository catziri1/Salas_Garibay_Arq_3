module RegisterPipeline
#(
	parameter NBits=32
)
(
	input clk,
	input reset,
	input  [NBits-1:0] DataInput,
	
	
	output reg [NBits-1:0] DataOutput
);

always@(negedge reset or negedge clk) begin
	if(reset==0)begin
		DataOutput <= 0;
	end
	else begin
		DataOutput <= DataInput;
	end
end


endmodule