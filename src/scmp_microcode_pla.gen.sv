import scmp_microcode_pak::*;
// This file was generated with microcode.pl - DO NOT EDIT

module scmp_microcode_pla(
	input	MCODE_PC_t	pc,
	output	MCODE_t	mcode
);

always_comb begin
	case(pc)
	//				NEXTPC			COND_MASK		COND_XOR		BUS		LD_L			LD_H		RD_L		RD_H		WR_L		WR_H		ALU_OP		ALU_CY_IN		CTL			// RESET = 0
	// FETCH = 0
		7'd0:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ADDR_PC,		LD_H_ADDR_PC,	RD_L_P0,	RD_H_P0,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_INC,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd1:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSOP,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd2:	mcode =	{	UCLBL_DECODE-8'd2,	COND_MASK_OP2,		COND_XOR_OP2,		BUS_RD,		LD_L_OP,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_COND_JMP	};
		7'd3:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ADDR_PC,		LD_H_ADDR_PC,	RD_L_P0,	RD_H_P0,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_INC,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd4:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSRDOP2,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd5:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_RD,		LD_L_D,			LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// DECODE = 6
		7'd6:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_DECODE	};
	// LD = 7
		7'd7:	mcode =	{	UCLBL_LDI-8'd7,		COND_MASK_ADI,		COND_XOR_ADI,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_COND_JMP	};
		7'd8:	mcode =	{	UCLBL_EA-8'd8,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_CALL	};
		7'd9:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSRD,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd10:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_RD,		LD_L_D,			LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// LDI = 11
		7'd11:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ACC_STAT_CYOV,	LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_LOGICOP	};
	// LDE = 12
		7'd12:	mcode =	{	UCLBL_LDI-8'd12,	COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_EXT,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// DAD = 13
		7'd13:	mcode =	{	UCLBL_DAI-8'd13,	COND_MASK_ADI,		COND_XOR_ADI,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_COND_JMP	};
		7'd14:	mcode =	{	UCLBL_EA-8'd14,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_CALL	};
		7'd15:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSRD,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd16:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_RD,		LD_L_D,			LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// DAI = 17
		7'd17:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_CONST_66,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_ADD,	ALU_CY_IN_ZERO,		CTL_NUL		};
		7'd18:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D_ACC_STAT_CY,	LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_ADD,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd19:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NOTHALFCARRY,	COND_XOR_NOTHALFCARRY,	BUS_NUL,	LD_L_D_ACC,		LD_H_NUL,	RD_L_CONST_FA,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_ADD,	ALU_CY_IN_ZERO,		CTL_COND_LD	};
		7'd20:	mcode =	{	UCLBL_FETCH-8'd20,	COND_MASK_NOTCARRY,	COND_XOR_NOTCARRY,	BUS_NUL,	LD_L_ACC,		LD_H_NUL,	RD_L_CONST_A0,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_ADD,	ALU_CY_IN_ZERO,		CTL_COND_LD	};
	// DAE = 21
		7'd21:	mcode =	{	UCLBL_DAI-8'd21,	COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_EXT,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// EA = 22
		7'd22:	mcode =	{	NEXTPC_NEXT,		COND_MASK_RDL80,	COND_XOR_RDL80,		BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_EXT,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_COND_LD	};
		7'd23:	mcode =	{	UCLBL_EAPOSTINC1-8'd23,	COND_MASK_POSTINC,	COND_XOR_POSTINC,	BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_D,		RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_COND_JMP	};
	// EAR2 = 24
		7'd24:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_EAM_ADDR,		LD_H_EAM_ADDR,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	ALU_CY_IN_ZERO,		CTL_NUL		};
		7'd25:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_RET		};
	// EAPOSTINC1 = 26
		7'd26:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ADDR,		LD_H_ADDR,	RD_L_EA,	RD_H_EA,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd27:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_EA,		LD_H_EA,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	ALU_CY_IN_ZERO,		CTL_RET		};
	// ST = 28
		7'd28:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd29:	mcode =	{	UCLBL_EA-8'd29,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_CALL	};
		7'd30:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSWR,	LD_L_D,			LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd31:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_WR,		LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// DLD = 32
		7'd32:	mcode =	{	UCLBL_EA-8'd32,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_CALL	};
		7'd33:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSRD,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd34:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_RD,		LD_L_D,			LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd35:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D_ACC,		LD_H_NUL,	RD_L_D,		RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd36:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSWR,	LD_L_D,			LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_DEC,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd37:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_WR,		LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// ILD = 38
		7'd38:	mcode =	{	UCLBL_EA-8'd38,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_CALL	};
		7'd39:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSRD,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd40:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_RD,		LD_L_D,			LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd41:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D_ACC,		LD_H_NUL,	RD_L_D,		RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd42:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSWR,	LD_L_D,			LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_INC,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd43:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_WR,		LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// JMP = 44
		7'd44:	mcode =	{	NEXTPC_FETCH,		COND_MASK_JMP,		COND_XOR_JMP,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_COND_JMP	};
		7'd45:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ADDR_PC,		LD_H_ADDR_PC,	RD_L_EA,	RD_H_EA,	WR_L_ALU,	WR_H_INCR4,	ALU_OP_ADD,	ALU_CY_IN_ZERO,		CTL_NUL		};
	// XAE = 46
		7'd46:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd47:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ACC,		LD_H_NUL,	RD_L_EXT,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd48:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_EXT,		LD_H_NUL,	RD_L_D,		RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// XPAL = 49
		7'd49:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd50:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ACC,		LD_H_NUL,	RD_L_EA,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd51:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_EA,		LD_H_NUL,	RD_L_D,		RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd52:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// XPAH = 53
		7'd53:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd54:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ACC,		LD_H_NUL,	RD_L_P0,	RD_H_EA,	WR_L_RD_H,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd55:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_EA,	RD_L_D,		RD_H_P0,	WR_L_RD_L,	WR_H_RD_L,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd56:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// XPPC = 57
		7'd57:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_P0,		LD_H_NUL,	RD_L_EA,	RD_H_EA,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd58:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_EA,		LD_H_NUL,	RD_L_ADDR,	RD_H_ADDR,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd59:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// DLY = 60
		7'd60:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd61:	mcode =	{	UCLBL_DLY-8'd61,	COND_MASK_ALUCARRY,	COND_XOR_ALUCARRY,	BUS_NUL,	LD_L_ACC,		LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_DEC,	ALU_CY_IN_STATUS,	CTL_COND_JMP	};
		7'd62:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd63:	mcode =	{	UCLBL_DLY-8'd63,	COND_MASK_ALUCARRY,	COND_XOR_ALUCARRY,	BUS_NUL,	LD_L_D,			LD_H_NUL,	RD_L_D,		RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_DEC,	ALU_CY_IN_STATUS,	CTL_COND_JMP	};
		7'd64:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd65:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// _CL = 66
		7'd66:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_CYOP0	};
	// _IE = 67
		7'd67:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_IEOP0	};
		7'd68:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// CSA = 69
		7'd69:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_ACC,		LD_H_NUL,	RD_L_STATUS,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// CAS = 70
		7'd70:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_STATUS,		LD_H_NUL,	RD_L_ACC,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd71:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// NOP = 72
		7'd72:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// HALT = 73
		7'd73:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_ADSHALT,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd74:	mcode =	{	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_RD,		LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
		7'd75:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	// SIO = 76
		7'd76:	mcode =	{	NEXTPC_FETCH,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_EXT_SOUT,		LD_H_NUL,	RD_L_EXT,	RD_H_P0,	WR_L_ALU,	WR_H_RD_H,	ALU_OP_RRL,	ALU_CY_IN_SIN,		CTL_NUL		};
	// SR = 77
	// SRL = 77
	// RR = 77
	// RRL = 77
		default:mcode = {	NEXTPC_NEXT,		COND_MASK_NUL,		COND_XOR_NUL,		BUS_NUL,	LD_L_NUL,		LD_H_NUL,	RD_L_P0,	RD_H_P0,	WR_L_RD_L,	WR_H_RD_H,	ALU_OP_NUL,	ALU_CY_IN_STATUS,	CTL_NUL		};
	endcase
end
endmodule
