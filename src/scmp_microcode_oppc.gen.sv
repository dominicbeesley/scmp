import scmp_microcode_pak::*;

module scmp_microcode_oppc (
input	logic	[7:0]	op,
output	NEXTPC_t		op_pc,
output	logic			op_dly
);

	always_comb begin
		op_dly <= 1'b0;
		if (((op ^ 8'b11001100) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_ILLEGAL;
		else if (((op ^ 8'b01001000) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_ILLEGAL;
		else if (((op ^ 8'b00000000) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_HALT;
		else if (((op ^ 8'b10001111) & 8'b11111111) == 8'b00000000)
		begin
			op_pc <= UCLBL_DLY;
			op_dly <= 1'b1;
		end
		else if (((op ^ 8'b00000001) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_XAE;
		else if (((op ^ 8'b11001000) & 8'b11111000) == 8'b00000000)
			op_pc <= UCLBL_ST;
		else if (((op ^ 8'b11101000) & 8'b11111000) == 8'b00000000)
			op_pc <= UCLBL_DAD;
		else if (((op ^ 8'b11110000) & 8'b11111000) == 8'b00000000)
			op_pc <= UCLBL_ADD;
		else if (((op ^ 8'b11111000) & 8'b11111000) == 8'b00000000)
			op_pc <= UCLBL_CAD;
		else if (((op ^ 8'b11000000) & 8'b11000000) == 8'b00000000)
			op_pc <= UCLBL_LD;
		else if (((op ^ 8'b01101000) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_DAE;
		else if (((op ^ 8'b01110000) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_ADE;
		else if (((op ^ 8'b01111000) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_CAE;
		else if (((op ^ 8'b01000000) & 8'b11000111) == 8'b00000000)
			op_pc <= UCLBL_LDE;
		else if (((op ^ 8'b10101000) & 8'b11111100) == 8'b00000000)
			op_pc <= UCLBL_ILD;
		else if (((op ^ 8'b10111000) & 8'b11111100) == 8'b00000000)
			op_pc <= UCLBL_DLD;
		else if (((op ^ 8'b10010000) & 8'b11110000) == 8'b00000000)
			op_pc <= UCLBL_JMP;
		else if (((op ^ 8'b00110000) & 8'b11111100) == 8'b00000000)
			op_pc <= UCLBL_XPAL;
		else if (((op ^ 8'b00110100) & 8'b11111100) == 8'b00000000)
			op_pc <= UCLBL_XPAH;
		else if (((op ^ 8'b00111100) & 8'b11111100) == 8'b00000000)
			op_pc <= UCLBL_XPPC;
		else if (((op ^ 8'b00000010) & 8'b11111110) == 8'b00000000)
			op_pc <= UCLBL__CL;
		else if (((op ^ 8'b00000100) & 8'b11111110) == 8'b00000000)
			op_pc <= UCLBL__IE;
		else if (((op ^ 8'b00000110) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_CSA;
		else if (((op ^ 8'b00000111) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_CAS;
		else if (((op ^ 8'b00001000) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_NOP;
		else if (((op ^ 8'b00011001) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_SIO;
		else if (((op ^ 8'b00011100) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_SR;
		else if (((op ^ 8'b00011101) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_SRL;
		else if (((op ^ 8'b00011110) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_RR;
		else if (((op ^ 8'b00011111) & 8'b11111111) == 8'b00000000)
			op_pc <= UCLBL_RRL;
		else
			op_pc <= UCLBL_ILLEGAL;
	end
endmodule