package scmp_microcode_pak;
// This file was generated with microcode.pl - DO NOT EDIT

// NEXTPC
typedef logic signed[7:0] NEXTPC_t;
const	NEXTPC_t	NEXTPC_NEXT	= 8'd1;
const	NEXTPC_t	NEXTPC_FETCH	= 8'd0;
// COND_MASK
typedef logic [9:0] COND_MASK_t;

const	COND_MASK_t	COND_MASK_NUL	= 10'd0;
const	COND_MASK_t	COND_MASK_OP2	= 10'b1000000000;
const	COND_MASK_t	COND_MASK_ADI	= 10'b0111000000;
const	COND_MASK_t	COND_MASK_JMP	= 10'b0000100000;
const	COND_MASK_t	COND_MASK_POSTINC	= 10'b0000010000;
const	COND_MASK_t	COND_MASK_RDL80	= 10'b0000001000;
const	COND_MASK_t	COND_MASK_NOTCARRY	= 10'b0000000100;
const	COND_MASK_t	COND_MASK_NOTHALFCARRY	= 10'b0000000010;
const	COND_MASK_t	COND_MASK_ALUCARRY	= 10'b0000000001;
// COND_XOR
typedef logic [9:0] COND_XOR_t;

const	COND_XOR_t	COND_XOR_NUL	= 10'd0;
const	COND_XOR_t	COND_XOR_OP2	= 10'b0000000000;
const	COND_XOR_t	COND_XOR_ADI	= 10'b0100000000;
const	COND_XOR_t	COND_XOR_JMP	= 10'b0000000000;
const	COND_XOR_t	COND_XOR_POSTINC	= 10'b0000010000;
const	COND_XOR_t	COND_XOR_POSTINCNEG	= 10'b0000000000;
const	COND_XOR_t	COND_XOR_RDL80	= 10'b0000000000;
const	COND_XOR_t	COND_XOR_NOTCARRY	= 10'b0000000100;
const	COND_XOR_t	COND_XOR_NOTHALFCARRY	= 10'b0000000010;
const	COND_XOR_t	COND_XOR_ALUCARRY	= 10'b0000000000;
// BUS
typedef enum {
	BUS_IX_WR	= 'd0,
	BUS_IX_RD	= 'd1,
	BUS_IX_ADS	= 'd2,
	BUS_IX_FLG_R	= 'd3,
	BUS_IX_FLG_I	= 'd4,
	BUS_IX_FLG_D	= 'd5,
	BUS_IX_FLG_H	= 'd6
} BUS_ix_t;
typedef logic [6:0] BUS_t;
const	BUS_t	BUS_WR	= 7'b0000001;
const	BUS_t	BUS_RD	= 7'b0000010;
const	BUS_t	BUS_ADS	= 7'b0000100;
const	BUS_t	BUS_FLG_R	= 7'b0001000;
const	BUS_t	BUS_FLG_I	= 7'b0010000;
const	BUS_t	BUS_FLG_D	= 7'b0100000;
const	BUS_t	BUS_FLG_H	= 7'b1000000;

const	BUS_t	BUS_NUL	= 7'd0;
const	BUS_t	BUS_ADSOP	= BUS_ADS|BUS_FLG_R|BUS_FLG_I;
const	BUS_t	BUS_ADSRD	= BUS_ADS|BUS_FLG_R;
const	BUS_t	BUS_ADSWR	= BUS_ADS;
const	BUS_t	BUS_ADSHALT	= BUS_ADS|BUS_FLG_R|BUS_FLG_H;
const	BUS_t	BUS_ADSRDOP2	= BUS_ADS|BUS_FLG_R|BUS_FLG_D;
// LD_L
typedef enum {
	LD_L_IX_P0	= 'd0,
	LD_L_IX_P1	= 'd1,
	LD_L_IX_P2	= 'd2,
	LD_L_IX_P3	= 'd3,
	LD_L_IX_ADDR	= 'd4,
	LD_L_IX_ACC	= 'd5,
	LD_L_IX_EXT	= 'd6,
	LD_L_IX_STATUS	= 'd7,
	LD_L_IX_D	= 'd8,
	LD_L_IX_OP	= 'd9,
	LD_L_IX_ST_CY	= 'd10,
	LD_L_IX_ST_OV	= 'd11,
	LD_L_IX_EA	= 'd12,
	LD_L_IX_EAM	= 'd13,
	LD_L_IX_SOUT	= 'd14
} LD_L_ix_t;
typedef logic [14:0] LD_L_t;
const	LD_L_t	LD_L_P0	= 15'b000000000000001;
const	LD_L_t	LD_L_P1	= 15'b000000000000010;
const	LD_L_t	LD_L_P2	= 15'b000000000000100;
const	LD_L_t	LD_L_P3	= 15'b000000000001000;
const	LD_L_t	LD_L_ADDR	= 15'b000000000010000;
const	LD_L_t	LD_L_ACC	= 15'b000000000100000;
const	LD_L_t	LD_L_EXT	= 15'b000000001000000;
const	LD_L_t	LD_L_STATUS	= 15'b000000010000000;
const	LD_L_t	LD_L_D	= 15'b000000100000000;
const	LD_L_t	LD_L_OP	= 15'b000001000000000;
const	LD_L_t	LD_L_ST_CY	= 15'b000010000000000;
const	LD_L_t	LD_L_ST_OV	= 15'b000100000000000;
const	LD_L_t	LD_L_EA	= 15'b001000000000000;
const	LD_L_t	LD_L_EAM	= 15'b010000000000000;
const	LD_L_t	LD_L_SOUT	= 15'b100000000000000;

const	LD_L_t	LD_L_NUL	= 15'd0;
const	LD_L_t	LD_L_ADDR_PC	= LD_L_P0|LD_L_ADDR;
const	LD_L_t	LD_L_D_ACC	= LD_L_D|LD_L_ACC;
const	LD_L_t	LD_L_ACC_STAT_CYOV	= LD_L_ACC|LD_L_ST_CY|LD_L_ST_OV;
const	LD_L_t	LD_L_ACC_STAT_CY	= LD_L_ACC|LD_L_ST_CY;
const	LD_L_t	LD_L_D_ACC_STAT_CY	= LD_L_D|LD_L_ACC|LD_L_ST_CY;
const	LD_L_t	LD_L_D_ST_CY	= LD_L_D|LD_L_ST_CY;
const	LD_L_t	LD_L_EAM_ADDR	= LD_L_EAM|LD_L_ADDR;
const	LD_L_t	LD_L_EXT_SOUT	= LD_L_EXT|LD_L_SOUT;
// LD_H
typedef enum {
	LD_H_IX_P0	= 'd0,
	LD_H_IX_P1	= 'd1,
	LD_H_IX_P2	= 'd2,
	LD_H_IX_P3	= 'd3,
	LD_H_IX_ADDR	= 'd4,
	LD_H_IX_EA	= 'd5,
	LD_H_IX_EAM	= 'd6
} LD_H_ix_t;
typedef logic [6:0] LD_H_t;
const	LD_H_t	LD_H_P0	= 7'b0000001;
const	LD_H_t	LD_H_P1	= 7'b0000010;
const	LD_H_t	LD_H_P2	= 7'b0000100;
const	LD_H_t	LD_H_P3	= 7'b0001000;
const	LD_H_t	LD_H_ADDR	= 7'b0010000;
const	LD_H_t	LD_H_EA	= 7'b0100000;
const	LD_H_t	LD_H_EAM	= 7'b1000000;

const	LD_H_t	LD_H_NUL	= 7'd0;
const	LD_H_t	LD_H_ADDR_PC	= LD_H_P0|LD_H_ADDR;
const	LD_H_t	LD_H_EAM_ADDR	= LD_H_EAM|LD_H_ADDR;
// RD_L
typedef enum {
	RD_L_IX_P0	= 'd0,
	RD_L_IX_P1	= 'd1,
	RD_L_IX_P2	= 'd2,
	RD_L_IX_P3	= 'd3,
	RD_L_IX_ADDR	= 'd4,
	RD_L_IX_ACC	= 'd5,
	RD_L_IX_EXT	= 'd6,
	RD_L_IX_STATUS	= 'd7,
	RD_L_IX_D	= 'd8,
	RD_L_IX_EA	= 'd9,
	RD_L_IX_CONST_66	= 'd10,
	RD_L_IX_CONST_0A	= 'd11,
	RD_L_IX_CONST_A0	= 'd12,
	RD_L_IX_CONST_FF	= 'd13
} RD_L_ix_t;
typedef enum logic [13:0] {
	RD_L_P0	= 14'b00000000000001,
	RD_L_P1	= 14'b00000000000010,
	RD_L_P2	= 14'b00000000000100,
	RD_L_P3	= 14'b00000000001000,
	RD_L_ADDR	= 14'b00000000010000,
	RD_L_ACC	= 14'b00000000100000,
	RD_L_EXT	= 14'b00000001000000,
	RD_L_STATUS	= 14'b00000010000000,
	RD_L_D	= 14'b00000100000000,
	RD_L_EA	= 14'b00001000000000,
	RD_L_CONST_66	= 14'b00010000000000,
	RD_L_CONST_0A	= 14'b00100000000000,
	RD_L_CONST_A0	= 14'b01000000000000,
	RD_L_CONST_FF	= 14'b10000000000000
} RD_L_t;
// RD_H
typedef enum {
	RD_H_IX_P0	= 'd0,
	RD_H_IX_P1	= 'd1,
	RD_H_IX_P2	= 'd2,
	RD_H_IX_P3	= 'd3,
	RD_H_IX_ADDR	= 'd4,
	RD_H_IX_EA	= 'd5
} RD_H_ix_t;
typedef enum logic [5:0] {
	RD_H_P0	= 6'b000001,
	RD_H_P1	= 6'b000010,
	RD_H_P2	= 6'b000100,
	RD_H_P3	= 6'b001000,
	RD_H_ADDR	= 6'b010000,
	RD_H_EA	= 6'b100000
} RD_H_t;
// WR_L
typedef enum {
	WR_L_IX_RD_H	= 'd0,
	WR_L_IX_RD_L	= 'd1,
	WR_L_IX_ALU	= 'd2
} WR_L_ix_t;
typedef enum logic [2:0] {
	WR_L_RD_H	= 3'b001,
	WR_L_RD_L	= 3'b010,
	WR_L_ALU	= 3'b100
} WR_L_t;
// WR_H
typedef enum {
	WR_H_IX_RD_H	= 'd0,
	WR_H_IX_RD_L	= 'd1,
	WR_H_IX_INCR4	= 'd2
} WR_H_ix_t;
typedef enum logic [2:0] {
	WR_H_RD_H	= 3'b001,
	WR_H_RD_L	= 3'b010,
	WR_H_INCR4	= 3'b100
} WR_H_t;
// ALU_OP
typedef logic [3:0] ALU_OP_t;
const	ALU_OP_t	ALU_OP_NUL	= 4'b000;
const	ALU_OP_t	ALU_OP_RRL	= 4'b001;
const	ALU_OP_t	ALU_OP_AND	= 4'b010;
const	ALU_OP_t	ALU_OP_OR	= 4'b011;
const	ALU_OP_t	ALU_OP_XOR	= 4'b100;
const	ALU_OP_t	ALU_OP_INC	= 4'b101;
const	ALU_OP_t	ALU_OP_DEC	= 4'b110;
const	ALU_OP_t	ALU_OP_ADD	= 4'b111;
const	ALU_OP_t	ALU_OP_ADD_L	= 4'b1000;
const	ALU_OP_t	ALU_OP_ADD_H	= 4'b1001;
// ALU_CY_IN
typedef logic [1:0] ALU_CY_IN_t;
const	ALU_CY_IN_t	ALU_CY_IN_STATUS	= 2'b00;
const	ALU_CY_IN_t	ALU_CY_IN_ZERO	= 2'b01;
const	ALU_CY_IN_t	ALU_CY_IN_SIN	= 2'b10;
const	ALU_CY_IN_t	ALU_CY_IN_RD0	= 2'b11;
// ALU_HCY_SUPPRESS
typedef logic [0:0] ALU_HCY_SUPPRESS_t;

const	ALU_HCY_SUPPRESS_t	ALU_HCY_SUPPRESS_NOSUPPRES	= 1'b0;
const	ALU_HCY_SUPPRESS_t	ALU_HCY_SUPPRESS_SUPPRESS	= 1'b1;
// CTL
typedef enum {
	CTL_IX_DECODE	= 'd0,
	CTL_IX_LOGICOP	= 'd1,
	CTL_IX_RET	= 'd2,
	CTL_IX_CALL	= 'd3,
	CTL_IX_COND_JMP	= 'd4,
	CTL_IX_COND_LD	= 'd5,
	CTL_IX_CYOP0	= 'd6,
	CTL_IX_IEOP0	= 'd7
} CTL_ix_t;
typedef logic [7:0] CTL_t;
const	CTL_t	CTL_DECODE	= 8'b00000001;
const	CTL_t	CTL_LOGICOP	= 8'b00000010;
const	CTL_t	CTL_RET	= 8'b00000100;
const	CTL_t	CTL_CALL	= 8'b00001000;
const	CTL_t	CTL_COND_JMP	= 8'b00010000;
const	CTL_t	CTL_COND_LD	= 8'b00100000;
const	CTL_t	CTL_CYOP0	= 8'b01000000;
const	CTL_t	CTL_IEOP0	= 8'b10000000;

const	CTL_t	CTL_NUL	= 8'd0;

typedef struct packed {
	NEXTPC_t	nextpc;
	COND_MASK_t	cond_mask;
	COND_XOR_t	cond_xor;
	BUS_t	bus;
	LD_L_t	ld_l;
	LD_H_t	ld_h;
	RD_L_t	rd_l;
	RD_H_t	rd_h;
	WR_L_t	wr_l;
	WR_H_t	wr_h;
	ALU_OP_t	alu_op;
	ALU_CY_IN_t	alu_cy_in;
	ALU_HCY_SUPPRESS_t	alu_hcy_suppress;
	CTL_t	ctl;
} MCODE_t;

typedef logic [7:0] MCODE_IX_t;
const MCODE_IX_t UCLBL_ADD = 7'd15;
const MCODE_IX_t UCLBL_ADE = 7'd21;
const MCODE_IX_t UCLBL_ADI = 7'd19;
const MCODE_IX_t UCLBL_CAD = 7'd22;
const MCODE_IX_t UCLBL_CAE = 7'd29;
const MCODE_IX_t UCLBL_CAI = 7'd26;
const MCODE_IX_t UCLBL_CAS = 7'd97;
const MCODE_IX_t UCLBL_CSA = 7'd96;
const MCODE_IX_t UCLBL_DAD = 7'd30;
const MCODE_IX_t UCLBL_DAE = 7'd40;
const MCODE_IX_t UCLBL_DAI = 7'd34;
const MCODE_IX_t UCLBL_DECODE = 7'd7;
const MCODE_IX_t UCLBL_DLD = 7'd53;
const MCODE_IX_t UCLBL_DLY = 7'd88;
const MCODE_IX_t UCLBL_EA = 7'd41;
const MCODE_IX_t UCLBL_EAPOSTINC1 = 7'd46;
const MCODE_IX_t UCLBL_EAR2 = 7'd44;
const MCODE_IX_t UCLBL_FETCH = 7'd0;
const MCODE_IX_t UCLBL_HALT = 7'd100;
const MCODE_IX_t UCLBL_ILD = 7'd62;
const MCODE_IX_t UCLBL_ILLEGAL = 7'd8;
const MCODE_IX_t UCLBL_JMP = 7'd71;
const MCODE_IX_t UCLBL_LD = 7'd9;
const MCODE_IX_t UCLBL_LDE = 7'd14;
const MCODE_IX_t UCLBL_LDI = 7'd13;
const MCODE_IX_t UCLBL_NOP = 7'd99;
const MCODE_IX_t UCLBL_RESET = 7'd0;
const MCODE_IX_t UCLBL_RR = 7'd107;
const MCODE_IX_t UCLBL_RRL = 7'd108;
const MCODE_IX_t UCLBL_SIO = 7'd104;
const MCODE_IX_t UCLBL_SR = 7'd105;
const MCODE_IX_t UCLBL_SRL = 7'd106;
const MCODE_IX_t UCLBL_ST = 7'd48;
const MCODE_IX_t UCLBL_XAE = 7'd74;
const MCODE_IX_t UCLBL_XPAH = 7'd81;
const MCODE_IX_t UCLBL_XPAL = 7'd77;
const MCODE_IX_t UCLBL_XPPC = 7'd85;
const MCODE_IX_t UCLBL__CL = 7'd93;
const MCODE_IX_t UCLBL__IE = 7'd94;
typedef logic [6:0] MCODE_PC_t;
endpackage