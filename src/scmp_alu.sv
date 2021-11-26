import scmp_microcode_pak::*;

module scmp_alu (
input	ALU_OP_t	op,

input	logic	[7:0]	A,
input	logic	[7:0]	B,
input	logic		Cy_i,
input	logic		Ov_i,

output	logic	[7:0]	res,
output	logic		Cy_o,
output  logic		Ov_o,
output	logic		Cy_sgn_o		// this will be 1 for 8 bit adds where the B input was negative i.e. EA calc
	);

	
	always_comb begin

		Ov_o <= Ov_i;
		Cy_o <= Cy_i;
		Cy_sgn_o <= 1'b0;
		case(op)
			ALU_OP_AND	:	
				res <= A & B;
			ALU_OP_OR	:
				res <= A | B;
			ALU_OP_XOR	:	
				res <= A ^ B;
			ALU_OP_ADD	:	
				begin
				{ Cy_o, res } <= A + B + { {7{1'b0}}, Cy_i };
				Ov_o <= res[7] ^ A [7];
				Cy_sgn_o <= B[7];
				end
			ALU_OP_ADD_NOCARRYIN:	
				begin
				{ Cy_o, res } <= A + B;
				Ov_o <= res[7] ^ A [7];
				Cy_sgn_o <= B[7];
				end
			ALU_OP_RRL	:	
				{ res, Cy_o } <= { Cy_i, A };
			ALU_OP_INC	:	
				{ Cy_o, res } <= A + 8'd1;
			ALU_OP_DEC	:	
				{ Cy_o, res } <= A - 8'd1;
			ALU_OP_NUL	:
				res <= B;

			default	:
				res <= A;
		endcase

	end

endmodule

	