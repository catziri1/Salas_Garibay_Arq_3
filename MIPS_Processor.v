/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer architecture class at ITESO.
* Version:
*	1.5
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	2/09/2018
******************************************************************/
module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 256,
	parameter PC_INCREMENT = 4,
	parameter J_TYPE = 'd31
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//**********************/
//**********************/
assign  PortOut = 0;

//**********************/
//**********************/
// signals to connect modules
wire branch_ne_wire;
wire branch_eq_wire;
wire [1:0]reg_dst_wire;
wire not_zero_and_brach_ne;
wire zero_and_brach_eq;
wire or_for_branch;
wire alu_src_wire;
wire reg_write_wire;
wire mem_write_wire;
wire mem_read_wire;
wire [1:0]mem_to_reg_wire;
wire zero_wire;
wire pc_src;
wire [1:0]jump_wire;

wire [2:0] aluop_wire;
wire [3:0] alu_operation_wire;
wire [4:0] write_register_wire;
wire [31:0] mux_pc_wire;
wire [31:0] pc_wire;
wire [31:0] instruction_bus_wire;
wire [31:0] read_data_1_wire;
wire [31:0] read_data_2_wire;
wire [31:0] Inmmediate_extend_wire;
wire [31:0] read_data_2_orr_inmmediate_wire;
wire [31:0] alu_result_wire;
wire [31:0] pc_plus_4_wire;
wire [31:0] inmmediate_extended_wire;
wire [31:0] pc_to_branch_wire;
wire [31:0] o_shift_left2;
wire [31:0] pc_plus_to_mux;
wire [31:0] next_address;
wire [31:0] next_address0;
wire [31:0] read_data_ram_wire;
wire [31:0] write_data_wire;

wire [31:0] o_shift_left_jump;

wire [63:0] if_id_wire;
wire [150:0] id_ex_wire;
wire [107:0] ex_mem_wire;
wire [71:0] mem_wb_wire;

//**********************/
//**********PIPELINE*********/
//**********************/
RegisterPipeline
#(
	.NBits(64)
)
IF_ID
(
	.clk(clk),
	.reset(reset),
	.DataInput({pc_plus_4_wire,instruction_bus_wire}),
	.DataOutput(if_id_wire)
);


RegisterPipeline
#(
	.NBits(178)
)
ID_EX
(
	.clk(clk),
	.reset(reset),
	.DataInput({
	reg_write_wire,
	mem_to_reg_wire,
	branch_eq_wire,
	mem_read_wire,
	mem_write_wire,
	reg_dst_wire,
	aluop_wire,
	alu_src_wire,
	(if_id_wire[63:32]),
	read_data_1_wire,
	read_data_2_wire,
	Inmmediate_extend_wire,
	(if_id_wire[20:16]),
	(if_id_wire[15:11])}),
	.DataOutput(id_ex_wire)
);


///////Poner lo correspondiente a estas señales de la salida de id_ex_wire///////
//reg_write_wire;
//mem_to_reg_wire;
//branch_eq_wire;
//mem_read_wire;
//mem_write_wire;
///////Poner lo correspondiente a estas señales de la salida de id_ex_wire
//id_read data 2
RegisterPipeline
#(
	.NBits(108)
)
EX_MEM
(
	.clk(clk),
	.reset(reset),
	.DataInput({
	(id_ex_wire[149:144]),
	pc_plus_to_mux,
	zero_wire,
	alu_result_wire,
  (id_ex_wire[73:42]),
   write_register_wire}),
	.DataOutput(ex_mem_wire)
);

//ex_mem_wire correspondiente a:
	//RegWrite
	//MemtoReg
	//aluresult
  //write_register_wire

RegisterPipeline
#(
	.NBits(72)
)
MEM_WB
(
	.clk(clk),
	.reset(reset),
	.DataInput({(ex_mem_wire[107:105]),
	read_data_ram_wire,
	(ex_mem_wire[68:37]),(ex_mem_wire[4:0])}),
	.DataOutput(mem_wb_wire)
);


//**********************/
//**********************/
//**********************/
Control
ControlUnit
(
	.OP(if_id_wire[31:26]),
	.Funct(if_id_wire[5:0]),
	.RegDst(reg_dst_wire),
	.BranchNE(branch_ne_wire),
	.BranchEQ(branch_eq_wire),
	.ALUOp(aluop_wire),
	.ALUSrc(alu_src_wire),
	.RegWrite(reg_write_wire),
	.MemRead(mem_read_wire),
	.MemtoReg(mem_to_reg_wire),
	.MemWrite(mem_write_wire),
	.Jump(jump_wire)
);



PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.NewPC(next_address),
	.PCValue(pc_wire)
);



ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(pc_wire - 'h400000),
	.Instruction(instruction_bus_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(pc_wire),
	.Data1(PC_INCREMENT),
	
	.Result(pc_plus_4_wire)
);





//**********************/
//BEQ AND BNE
//**********************/
Adder32bits
PC_Plus_To_Mux
(
	.Data0(id_ex_wire[137:106]),
	.Data1(o_shift_left2),
	
	.Result(pc_plus_to_mux)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ToBranch
(
	.Selector(pc_src),
	.MUX_Data0(pc_plus_4_wire),
	.MUX_Data1(ex_mem_wire[101:70]),
	
	.MUX_Output(next_address0)
);


ANDGate
SelectorBranch
(
	.A(ex_mem_wire[104]),
	.B(ex_mem_wire[69]),
	.C(pc_src)
);



ShiftLeft2
ShiftLeftInm
(
	.DataInput(id_ex_wire[41:10]),
	.DataOutput(o_shift_left2)
);


//**********************/
//JUMP
//**********************/

MultiplexerExtended
#(
	.NBits(32)
)
MUX_ToJump
(
	.Selector(jump_wire),
	.MUX_Data0(next_address0),
	.MUX_Data1(o_shift_left_jump),
	.MUX_Data2(read_data_1_wire),
	
	.MUX_Output(next_address)
);

ShiftLeft2
ShiftLeftJump
(
	.DataInput({4'b0000,if_id_wire[25:0]}),
	.DataOutput(o_shift_left_jump)
);

//**********************/
//LW AND SW
//**********************/
DataMemory
RAM
(
	.WriteData(ex_mem_wire[36:5]),
	.Address(ex_mem_wire[68:37]),
	.MemWrite(ex_mem_wire[102]),
	.MemRead(ex_mem_wire[103]),
	.clk(clk),
	
	.ReadData(read_data_ram_wire)
);

MultiplexerExtended
#(
	.NBits(32)
)
MUX_RAM
(
	.Selector(mem_wb_wire[70:69]),
	.MUX_Data0(mem_wb_wire[36:5]),
	.MUX_Data1(mem_wb_wire[68:37]),
	.MUX_Data2(id_ex_wire[137:106]),
	
	.MUX_Output(write_data_wire)
);


//**********************/
//**********************/
//**********************/
//**********************/
//**********************/
MultiplexerExtended
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(id_ex_wire[143 :142]),
	.MUX_Data0(id_ex_wire[9:5]),
	.MUX_Data1(id_ex_wire[4:0]),
	.MUX_Data2(J_TYPE),
	
	.MUX_Output(write_register_wire)

);


RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(mem_wb_wire[71]),
	.WriteRegister(mem_wb_wire[4:0]),
	.ReadRegister1(if_id_wire[25:21]),
	.ReadRegister2(if_id_wire[20:16]),
	.WriteData(write_data_wire),
	.ReadData1(read_data_1_wire),
	.ReadData2(read_data_2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(if_id_wire[15:0]),
   .SignExtendOutput(Inmmediate_extend_wire)
);




Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(id_ex_wire[138]),
	.MUX_Data0(id_ex_wire[73:42]),
	.MUX_Data1(id_ex_wire[41:10]),
	
	.MUX_Output(read_data_2_orr_inmmediate_wire)

);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(id_ex_wire[141:139]),
	.ALUFunction(id_ex_wire[15:10]), 
	.ALUOperation(alu_operation_wire)

);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(alu_operation_wire),
	.A(id_ex_wire[105:74]),
	.B(read_data_2_orr_inmmediate_wire),
	.shamt(id_ex_wire[20:16]),
	.Zero(zero_wire),
	.ALUResult(alu_result_wire)
);

assign ALUResultOut = alu_result_wire;


endmodule