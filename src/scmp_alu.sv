import scmp_microcode_pak::*;

module scmp_alu (
input	ALU_OP_t	op,

input	logic	[7:0]	A,
input	logic	[7:0]	B,
input	logic		HCy_i,
input	logic		HCy_suppress_i,
input	logic		Cy_i,
input	logic		Ov_i,

output	logic	[7:0]	res,
output	logic		Cy_o,
output  logic		HCy_o,			// half carry
output  logic		Ov_o,
output	logic		Cy_sgn_o		// this will be 1 for 8 bit adds where the B input was negative i.e. EA calc
	);


	logic	i_HCy;


	always_comb begin

		Ov_o = Ov_i;
		Cy_o = Cy_i;
		i_HCy = HCy_i;

		Cy_sgn_o = 1'b0;
		case(op)
			ALU_OP_AND	:
				res = A & B;
			ALU_OP_OR	:
				res = A | B;
			ALU_OP_XOR	:
				res = A ^ B;
			ALU_OP_ADD	:
				begin
				{ i_HCy, res[3:0] } = A[3:0] + B[3:0] + { {3{1'b0}}, Cy_i };

				if (HCy_suppress_i) i_HCy = 'b0;

				{ Cy_o, res[7:4] } = A[7:4] + B[7:4] + { {3{1'b0}}, i_HCy };
				Ov_o = (B[7] ^~ A[7]) & (res[7] ^ A [7]);
				Cy_sgn_o = B[7];
				end
			ALU_OP_RRL	:
				{ res, Cy_o } = { Cy_i, A };
			ALU_OP_INC	:
				{ Cy_o, res } = A + 8'd1;
			ALU_OP_DEC	:
				{ Cy_o, res } = A - 8'd1;
			ALU_OP_NUL	:
				res = B;

			ALU_OP_ADD_L :
			begin
				{ i_HCy, res[3:0] } = A[3:0] + B[3:0] + { {3{1'b0}}, Cy_i };
				res[7:4] = B[7:4];
			end
			ALU_OP_ADD_H :
			begin
				if (HCy_suppress_i) i_HCy = 'b0;
				res[3:0] = B[3:0];
				{ Cy_o, res[7:4] } = A[7:4] + B[7:4] + { {3{1'b0}}, i_HCy };
				Ov_o = (B[7] ^~ A[7]) & (res[7] ^ A [7]);
				Cy_sgn_o = B[7];
			end
			default	:
				res = A;
		endcase


	end

	assign HCy_o = i_HCy;


endmodule
