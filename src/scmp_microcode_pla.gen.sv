import scmp_microcode_pak::*;
// This file was generated with microcode.pl - DO NOT EDIT

module scmp_microcode_pla(
	input	MCODE_PC_t	pc,
	output	MCODE_t	mcode
);

always_comb begin
	case(pc)
		8'd0:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_ADDR_PC,	LD_H_ADDR_PC,	RD_L_P0,	RD_H_P0,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_INC,	CTL_NUL};
		8'd1:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSOP,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd2:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_RD,	LD_L_OP,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd3:	mcode =	{	UCLBL_DECODE-8'd3,	COND_MASK_OP2,	COND_XOR_OP2,	BUS_NUL,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd4:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_ADDR_PC,	LD_H_ADDR_PC,	RD_L_P0,	RD_H_P0,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_INC,	CTL_NUL};
		8'd5:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSRD,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd6:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_RD,	LD_L_D,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd7:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_DECODE};
		8'd8:	mcode =	{	UCLBL_LDI-8'd8,	COND_MASK_ADI,	COND_XOR_ADI,	BUS_NUL,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd9:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_EA,	LD_H_EA,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	CTL_NUL};
		8'd10:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSRD,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd11:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_RD,	LD_L_D,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd12:	mcode =	{	UCLBL_FETCH,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_ACC,	LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_NUL,	CTL_LOGICOP};
		8'd13:	mcode =	{	UCLBL_LDI-8'd13,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_D,	LD_H_NUL,	RD_L_EXT,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd14:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_EA,	LD_H_EA,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	CTL_NUL};
		8'd15:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSWR,	LD_L_D,	LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd16:	mcode =	{	UCLBL_FETCH,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_WR,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd17:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_ADDR,	LD_H_ADDR,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	CTL_NUL};
		8'd18:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSRD,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd19:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_RD,	LD_L_D,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd20:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_D_ACC,	LD_H_NUL,	RD_L_D,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_DEC,	CTL_NUL};
		8'd21:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSWR,	LD_L_D,	LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd22:	mcode =	{	UCLBL_FETCH,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_WR,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd23:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_ADDR,	LD_H_ADDR,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	CTL_NUL};
		8'd24:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSRD,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd25:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_RD,	LD_L_D,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd26:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_D_ACC,	LD_H_NUL,	RD_L_D,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_INC,	CTL_NUL};
		8'd27:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_ADSWR,	LD_L_D,	LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd28:	mcode =	{	UCLBL_FETCH,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_WR,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd29:	mcode =	{	UCLBL_FETCH,	COND_MASK_JMP,	COND_XOR_JMP,	BUS_NUL,	LD_L_NUL,	LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd30:	mcode =	{	UCLBL_FETCH,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_ADDR_PC,	LD_H_ADDR_PC,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	CTL_NUL};
		8'd31:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_D,	LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd32:	mcode =	{	NEXTPC_NEXT,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_ACC,	LD_H_NUL,	RD_L_EXT,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		8'd33:	mcode =	{	UCLBL_FETCH,	COND_MASK_NUL,	COND_XOR_NUL,	BUS_NUL,	LD_L_EXT,	LD_H_NUL,	RD_L_D,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	CTL_NUL};
		default: mcode = 0;	endcase
end
endmodule
