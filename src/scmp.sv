import scmp_microcode_pak::*;


module scmp
(
input	logic		clk,
input	logic		rst_n,
input	logic	[7:0]	D_i,
input	logic		sb,
input	logic		sa,
input	logic		sin,

output  logic	[11:0]	addr,
output	logic	[7:0]	D_o,
output  logic		f0,
output  logic		f1,
output  logic		f2,
output	logic		sout,

output	logic		ADS_n,
output	logic		RD_n,
output	logic		WR_n

);

	//register load from microcode
	LD_L_t					ld_l;
	LD_H_t					ld_h;

	//register low output logics
	logic	[7:0]				reg8_p_l_q[3:0];
	logic	[7:0]				reg8_addr_l_q;
	logic	[7:0]				reg8_acc_q;
	logic	[7:0]				reg8_ext_q;
	logic	[7:0]				reg8_status_q;
	logic	[7:0]				reg8_D_Q;
	logic	[7:0]				reg8_op_q;
	//status register (registers)
	logic					status_hcy;
	logic					status_cy;
	logic					status_ov;
	logic					status_ie;
	logic					status_f2;
	logic					status_f1;
	logic					status_f0;
	assign	reg8_status_q = {
			status_cy,
			status_ov,
			sb,
			sa,
			status_ie,
			status_f2,
			status_f1,
			status_f0
			};

	//register hi logics
	logic	[7:0]				reg8_p_h_q[3:0];
	logic	[7:0]				reg8_addr_h_q;

	//low bus read control
	logic	[7:0]				read_bus_lo;
	RD_L_t					read_bus_lo_src_oh;

	//read bus hi control
	logic	[7:0]				read_bus_hi;
	RD_H_t					read_bus_hi_src_oh;	//load pointer /address / addr hi

	//write bus lo control
	logic	[7:0]				write_bus_lo;
	WR_L_t					write_bus_lo_src_oh;


	logic	[7:0]				write_bus_hi;
	WR_H_t					write_bus_hi_src_oh;


	logic	[7:0]				incr4_out;

	ALU_OP_t				alu_op;
	logic					alu_hcy_suppress;
	logic	[7:0]				alu_Q;
	logic					alu_cy;
	logic					alu_hcy;		// half carry - TODO:get rid, move to 4 bit adder
	logic					alu_ov;
	logic					alu_cy_sgn;		// sign of "B" operand in last add, TODO: replace with D sign?
	logic					alu_cy_in;

	logic	bus_F_R;
	logic	bus_F_I;
	logic	bus_F_D;
	logic	bus_F_H;

	logic	[7:0]				rd_ea_l;
	logic	[7:0]				rd_ea_h;

	reg					r_sout;

	MCODE_t					mcode;


	scmp_microcode microcode (
		.rst_n(rst_n),
		.clk(clk),
		.op(reg8_op_q),
		.op2(D_i[7]),			//TODO: this is a bodge, use bus_rd_lo/hi to write into D in reads?
		.zer(read_bus_lo == 8'd0),
        .neg(read_bus_lo[7]),
        .minus80(reg8_D_Q == 8'h80),
        .cy(status_cy),
        .hcy(status_hcy),
        .alu_cy(alu_cy),

		.ld_l(ld_l),
		.ld_h(ld_h),
		.rd_l(read_bus_lo_src_oh),
		.rd_h(read_bus_hi_src_oh),
		.wr_l(write_bus_lo_src_oh),
		.wr_h(write_bus_hi_src_oh),
		.alu_op(alu_op),
		.alu_hcy_suppress(alu_hcy_suppress),

		.bus_ADS_n(ADS_n),
		.bus_RD_n(RD_n),
		.bus_WR_n(WR_n),
		.bus_F_R(bus_F_R),
		.bus_F_I(bus_F_I),
		.bus_F_D(bus_F_D),
		.bus_F_H(bus_F_H),
		.mcode(mcode)
	);


	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			status_hcy <= 1'b0;
			status_cy <= 1'b0;
			status_ov <= 1'b0;
			status_ie <= 1'b0;
			status_f2 <= 1'b0;
			status_f1 <= 1'b0;
			status_f0 <= 1'b0;
		end
		else begin
			if (mcode.ctl[CTL_IX_IEOP0])
				status_ie <= reg8_op_q[0];
			else if (mcode.ctl[CTL_IX_CYOP0])
				status_cy <= reg8_op_q[0];
			else if (ld_l[LD_L_IX_STATUS]) begin
				status_cy <= read_bus_lo[7];
				status_ov <= read_bus_lo[6];
				status_ie <= read_bus_lo[3];
				status_f2 <= read_bus_lo[2];
				status_f1 <= read_bus_lo[1];
				status_f0 <= read_bus_lo[0];
			end else begin
				if (ld_l[LD_L_IX_ST_CY]) begin
					status_cy <= alu_cy;
					status_hcy <= alu_hcy;
				end
				if (ld_l[LD_L_IX_ST_OV]) begin
					status_ov <= alu_ov;
				end
			end
		end
	end



	reg8 reg8_D (
				.clk(clk),
				.rst_n(rst_n),
				.D((RD_n==1'b0)?D_i:write_bus_lo),
				.ctl_ld(ld_l[LD_L_IX_D]),
				.Q(reg8_D_Q)
	);

	reg8 reg8_ACC (
				.clk(clk),
				.rst_n(rst_n),
				.D(write_bus_lo),
				.ctl_ld(ld_l[LD_L_IX_ACC]),
				.Q(reg8_acc_q)
	);

	reg8 reg8_EXT (
				.clk(clk),
				.rst_n(rst_n),
				.D(write_bus_lo),
				.ctl_ld(ld_l[LD_L_IX_EXT]),
				.Q(reg8_ext_q)
	);


	reg8 reg8_OP (
				.clk(clk),
				.rst_n(rst_n),
				.D(D_i),
				.ctl_ld(ld_l[LD_L_IX_OP]),
				.Q(reg8_op_q)
	);



	generate
		genvar gi;
		//instantiate pointer registers in a loop
		for (gi=0; gi < 4; gi = gi + 1) begin : gen_pregs
			reg8 reg_p_h (
				.clk(clk),
				.rst_n(rst_n),
				.D(write_bus_hi),
				.ctl_ld(
					ld_h[LD_H_IX_P0 + gi]
					| (
						(	ld_h[LD_H_IX_EA] // effective address
						|	(ld_h[LD_H_IX_EAM] & reg8_op_q[2])
						)
						&& 	reg8_op_q[1:0] == gi // this register
					)
				),
				.Q(reg8_p_h_q[gi])
				);
			reg8 reg_p_l (
				.clk(clk),
				.rst_n(rst_n),
				.D(write_bus_lo),
				.ctl_ld(
					ld_l[LD_L_IX_P0 + gi]
					| (
						(	ld_l[LD_L_IX_EA] // effective address
						|	(ld_l[LD_L_IX_EAM] & reg8_op_q[2])
						)
						&& 	reg8_op_q[1:0] == gi // this register
					)
				),
				.Q(reg8_p_l_q[gi])
				);
		end
	endgenerate

	//address register
	reg8 reg_addr_h (
			.clk(clk),
			.rst_n(rst_n),
			.D(write_bus_hi),
			.ctl_ld(ld_h[LD_H_IX_ADDR]),
			.Q(reg8_addr_h_q)
		);
	reg8 reg_addr_l (
			.clk(clk),
			.rst_n(rst_n),
			.D(write_bus_lo),
			.ctl_ld(ld_l[LD_L_IX_ADDR]),
			.Q(reg8_addr_l_q)
		);




	//incrementer
	logic [3:0]	incr4_lo;
	assign incr4_lo = (alu_cy_sgn)
		?(read_bus_hi[3:0] - { {3{1'b0}}, ~alu_cy })
		:(read_bus_hi[3:0] + { {3{1'b0}}, alu_cy });
	assign incr4_out = { read_bus_hi[7:4], incr4_lo };


	scmp_alu alu (
		.op(alu_op),
		.A(read_bus_lo),
		.B(reg8_D_Q),
		.HCy_i(status_hcy),
		.HCy_suppress_i(alu_hcy_suppress),
		.Cy_i(alu_cy_in),
		.Ov_i(status_ov),
		.res(alu_Q),
		.HCy_o(alu_hcy),
		.Cy_o(alu_cy),
		.Ov_o(alu_ov),
		.Cy_sgn_o(alu_cy_sgn)
	);


	always_comb begin

		case (mcode.alu_cy_in)
			ALU_CY_IN_ZERO:
				alu_cy_in <= 1'b0;
			ALU_CY_IN_SIN:
				alu_cy_in <= sin;
			ALU_CY_IN_RD0:
				alu_cy_in <= read_bus_lo[0];
			default:
				alu_cy_in <= status_cy;
		endcase
	end



	// bus muxes

	assign rd_ea_l = 	(reg8_op_q[1:0] == 0)?reg8_p_l_q[0]:
				(reg8_op_q[1:0] == 1)?reg8_p_l_q[1]:
				(reg8_op_q[1:0] == 2)?reg8_p_l_q[2]:
				reg8_p_l_q[3];

	mux_oh mux_read_bus_lo (
			.sel_oh(read_bus_lo_src_oh),
			.D('{
				8'hFF,
				8'hA0,
				8'h0A,
				8'h66,
				rd_ea_l,
				reg8_D_Q,
				reg8_status_q,
				reg8_ext_q,
				reg8_acc_q,
				reg8_addr_l_q,
				reg8_p_l_q[3],
				reg8_p_l_q[2],
				reg8_p_l_q[1],
				reg8_p_l_q[0]
				}),
			.Q(read_bus_lo)
		);
	defparam mux_read_bus_lo.SIZE = $bits(RD_L_t);


	assign rd_ea_h = 	(reg8_op_q[1:0] == 0)?reg8_p_h_q[0]:
				(reg8_op_q[1:0] == 1)?reg8_p_h_q[1]:
				(reg8_op_q[1:0] == 2)?reg8_p_h_q[2]:
				reg8_p_h_q[3];

	mux_oh mux_read_bus_hi (
			.sel_oh(read_bus_hi_src_oh),
			.D('{
				rd_ea_h,
				reg8_addr_h_q,
				reg8_p_h_q[3],
				reg8_p_h_q[2],
				reg8_p_h_q[1],
				reg8_p_h_q[0]
				}),
			.Q(read_bus_hi)
		);
	defparam mux_read_bus_hi.SIZE = $bits(read_bus_hi_src_oh);


	mux_oh mux_write_bus_lo (
			.sel_oh(write_bus_lo_src_oh),
			.D('{
				alu_Q,
				read_bus_lo,
				read_bus_hi
				}),
			.Q(write_bus_lo)
		);
	defparam mux_write_bus_lo.SIZE = $bits(write_bus_lo_src_oh);

	mux_oh mux_write_bus_hi (
			.sel_oh(write_bus_hi_src_oh),
			.D('{	incr4_out,
				read_bus_lo,
				read_bus_hi
				}),
			.Q(write_bus_hi)
		);
	defparam mux_write_bus_hi.SIZE = $bits(write_bus_hi_src_oh);



	assign	f0 = status_f0;
	assign	f1 = status_f1;
	assign	f2 = status_f2;
	assign  addr = { reg8_addr_h_q[3:0], reg8_addr_l_q };


	assign	D_o = 	!WR_n 	? reg8_D_Q :
			!ADS_n	? { bus_F_H, bus_F_D, bus_F_I, bus_F_R, reg8_addr_h_q[7:4] } :
			{8{1'bz}};

	assign	sout = r_sout;

	always_ff @(posedge clk) begin
		if (ld_l[LD_L_IX_SOUT])
			r_sout <= alu_cy;
	end


endmodule
