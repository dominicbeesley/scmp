import scmp_microcode_pak::*;

module scmp_microcode (

input	logic		rst_n,
input	logic		clk,
input	logic[7:0]	op,
input	logic		op2,		//set by D_i[7] during opcode read
input	logic		zer,		//set when read bus lo == 0
input	logic		neg,		//set when read bus lo is -ve
input	logic		minus80,	//set when read bus lo == 0x80 
//TODO: carries might all be collapsed into one flag with 4 bit alu
input	logic		cy,		//cy from status
input	logic		hcy,		//half carry from hidden status
input	logic		alu_cy,		//immediate value of alu_cy 

output	LD_L_t		ld_l,
output	LD_H_t		ld_h,
output	RD_L_t		rd_l,
output	RD_H_t		rd_h,
output	WR_L_t		wr_l,
output	WR_H_t		wr_h,
output	ALU_OP_t	alu_op,
output  logic		alu_hcy_suppress,	//bodge for decimal adds TODO: get rid and do 4-bit adder

output  logic		bus_ADS_n,
output  logic		bus_RD_n,
output  logic		bus_WR_n,

output  logic		bus_F_R,
output  logic		bus_F_I,
output  logic		bus_F_D,
output  logic		bus_F_H,

output	MCODE_t		mcode


);

	MCODE_PC_t		mc_pc;
	MCODE_PC_t		mc_ret;

	MCODE_t			i_mcode;
	wire			cond;	// when this is set the NEXT field is ignored and the next uI is invoked
	COND_MASK_t		cond_in;
	NEXTPC_t		op_pc;
	logic			c_jmp;
	logic			c_ea_postinc;	//when set is a post-inc autoindexed
	logic			op_dly;	// used to get FLG_D in 2nd opcode byte
	logic			uc_bus_F_D;

	//jump logic gives a 1 to not return to fetch on jmp, jz, jnz, jp

	assign	c_jmp = 
		(op[3:2] == 2'b01)?~neg:		//jp i.e. !neg
		(op[3:2] == 2'b10)?zer:		//jz
		(op[3:2] == 2'b11)?~zer:
		1'b1;				//always jmp
				
	assign	c_ea_postinc = op[2] & ~neg;

	assign cond_in = { op2, op[2:0], c_jmp, c_ea_postinc, minus80, cy, hcy, alu_cy};
	assign cond =| ((cond_in ^ i_mcode.cond_xor) & i_mcode.cond_mask);


	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) 
		begin
			mc_pc <= 'd0;
			mc_ret <= 'd0;
		end
		else
		begin			
			if (i_mcode.ctl[CTL_IX_DECODE]) 
				mc_pc <= op_pc;
			else if (i_mcode.ctl[CTL_IX_RET]) 
				mc_pc <= mc_ret;
			else if (cond & i_mcode.ctl[CTL_IX_COND_JMP]) 
				mc_pc <= mc_pc + 8'd1;
			else if (i_mcode.nextpc == 'd0)
				mc_pc <= 'd0;
			else
				mc_pc <= mc_pc + i_mcode.nextpc;

			if (i_mcode.ctl[CTL_IX_CALL])
				mc_ret <= mc_pc + 'd1;
		end
	end

	scmp_microcode_pla pla (
		.pc(mc_pc),
		.mcode(i_mcode)
		);

	scmp_microcode_oppc op2pc (
		.op(op),
		.op_pc(op_pc),
		.op_dly(op_dly)
		);

	assign { bus_F_H, uc_bus_F_D, bus_F_I, bus_F_R} = i_mcode.bus[6:3];
	assign bus_F_D = uc_bus_F_D & op_dly;
	assign { bus_ADS_n, bus_RD_n, bus_WR_n } = ~i_mcode.bus[2:0];
	
	assign ld_l = i_mcode.ld_l & {$bits(ld_l){cond | ~i_mcode.ctl[CTL_IX_COND_LD]}};
	assign ld_h = i_mcode.ld_h & {$bits(ld_h){cond | ~i_mcode.ctl[CTL_IX_COND_LD]}};
	assign rd_l = i_mcode.rd_l;
	assign rd_h = i_mcode.rd_h;
	assign wr_l = i_mcode.wr_l;
	assign wr_h = i_mcode.wr_h;
	assign alu_op = (i_mcode.ctl[CTL_IX_LOGICOP])?{1'b0 , op[5:3]}:i_mcode.alu_op;
	assign mcode = i_mcode;
	assign alu_hcy_suppress = i_mcode.alu_hcy_suppress;

endmodule