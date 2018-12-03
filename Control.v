/******************************************************************
* Description
*	This is control unit for the MIPS processor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module Control
(
	input [5:0]OP,
	input [5:0]Funct,
	
	output [1:0]RegDst,
	output BranchEQ,
	output BranchNE,
	output [1:0]Jump,
	output MemRead,
	output [1:0]MemtoReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output [2:0]ALUOp
);
localparam R_Type = 0;
localparam I_Type_ADDI = 6'h8;
localparam I_Type_ORI = 6'h0d;
localparam I_Type_LUI = 6'h0f;
localparam I_Type_BEQ = 6'h04;
localparam I_Type_BNE = 6'h05;
localparam I_Type_SW  = 6'h2b;
localparam I_Type_LW  = 6'h23;
localparam J_Type_JMP = 6'h02;
localparam J_Type_JAL = 6'h03;
localparam R_Type_JR	 = 6'h08;
 

reg [14:0] ControlValues;

always@(OP,Funct) begin
	case(OP)
		R_Type:  
			begin
				if (Funct == R_Type_JR)    
				ControlValues= 15'b10_00_0000_00_00_111;
				else
				ControlValues= 15'b00_01_0001_00_00_111;
			end

		I_Type_ADDI:  ControlValues= 15'b00_00_1_00_1_00_00_100;
		I_Type_ORI:   ControlValues= 15'b00_00_1_00_1_00_00_101;
		I_Type_LUI:	  ControlValues= 15'b00_00_1_00_1_00_00_110;
		
		I_Type_BEQ:	  ControlValues= 15'b00_00_0_00_0_00_01_000;
		I_Type_BNE:	  ControlValues= 15'b00_00_0_00_0_00_01_001;
		
		I_Type_LW:	  ControlValues= 15'b00_00_1_01_1_10_00_011;
		I_Type_SW:	  ControlValues= 15'b00_00_1_00_0_01_00_011;
		J_Type_JMP:	  ControlValues= 15'b01_00_0_00_0_00_00_111;
		J_Type_JAL:	  ControlValues= 15'b01_10_0_10_1_00_00_111;

		
		default:
			ControlValues= 15'b00000000000000;
		endcase
end	
	
assign Jump = ControlValues[14:13];
assign RegDst = ControlValues[12:11];
assign ALUSrc = ControlValues[10];
assign MemtoReg = ControlValues[9:8];
assign RegWrite = ControlValues[7];
assign MemRead = ControlValues[6];
assign MemWrite = ControlValues[5];
assign BranchNE = ControlValues[4];
assign BranchEQ = ControlValues[3];
assign ALUOp = ControlValues[2:0];	//se define en ALUControl

endmodule


