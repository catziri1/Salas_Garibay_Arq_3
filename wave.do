onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /MIPS_Processor_TB/clk
add wave -noupdate /MIPS_Processor_TB/reset
add wave -noupdate /MIPS_Processor_TB/PortIn
add wave -noupdate /MIPS_Processor_TB/ALUResultOut
add wave -noupdate /MIPS_Processor_TB/PortOut
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ProgramCounter/PCValue
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ROMProgramMemory/Instruction
add wave -noupdate -divider IF_ID
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/IF_ID/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/IF_ID/DataOutput
add wave -noupdate -divider ID_EX
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ID_EX/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ID_EX/DataOutput
add wave -noupdate -divider EX_MEM
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/EX_MEM/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/EX_MEM/DataOutput
add wave -noupdate -divider MEM_WB
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/MEM_WB/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/MEM_WB/DataOutput
add wave -noupdate -divider T0
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t0/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t0/DataOutput
add wave -noupdate -divider T1
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t1/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t1/DataOutput
add wave -noupdate -divider T2
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t2/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t2/DataOutput
add wave -noupdate -divider T3
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t3/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t3/DataOutput
add wave -noupdate -divider S0
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_s0/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_s0/DataOutput
add wave -noupdate -divider S1
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_s1/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_s1/DataOutput
add wave -noupdate -divider S7
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_s7/DataInput
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_s7/DataOutput
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2 ps}
