

module DataMemory 
#(	parameter DATA_WIDTH=32,

	parameter MEMORY_DEPTH = 2048

)
(
	input [DATA_WIDTH-1:0] WriteData,
	input [DATA_WIDTH-1:0]  Address,
	input MemWrite,MemRead, clk,
	output  [DATA_WIDTH-1:0]  ReadData
);

	//shift right
	wire [(DATA_WIDTH-1):0] RealAddress;
	wire [(DATA_WIDTH-1):0] AuxAddress;
	
	assign AuxAddress = Address - 'h10010000;
	assign RealAddress = {2'b0,AuxAddress[(DATA_WIDTH-1):2]};

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
	wire [DATA_WIDTH-1:0] ReadDataAux;

	always @ (posedge clk)
	begin
		// Write
		if (MemWrite)
			ram[RealAddress] <= WriteData;
	end
	assign ReadDataAux = ram[RealAddress];
  	assign ReadData = {DATA_WIDTH{MemRead}}& ReadDataAux;

endmodule
