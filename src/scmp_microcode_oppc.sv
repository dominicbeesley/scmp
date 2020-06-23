import scmp_microcode_pak::*;

module scmp_microcode_oppc (
input	logic	[7:0]		op,
output	NEXTPC_t		op_pc
);
	
	always_comb begin
		if (op[7:3] == 5'b11000)
			op_pc <= UCLBL_LD;
		else if (op[7:3] == 5'b11001 & op[2:0] != 3'b100)
			op_pc <= UCLBL_ST;
		else if (op[7:2] == 6'b101010)
			op_pc <= UCLBL_ILD;
		else if (op[7:2] == 6'b101110)
			op_pc <= UCLBL_DLD;
		else if (op[7:4] == 4'b1001)
			op_pc <= UCLBL_JMP;
		else
			op_pc <= UCLBL_FETCH;
	end
endmodule