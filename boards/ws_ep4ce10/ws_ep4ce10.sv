`timescale 1 ns / 1 ns
`define MEM_SIZE 128

module ws_ep4ce10
#(	parameter C_SIZE = 12,
	SIM = 0
)
(
input			clk_50m,
			rst_n,
			sin,
output  	[3:0]	led_n,
output		[3:0]	disp0_sel,
output  	[7:0]	disp0_seg,
output			sout
);

	logic	[7:0]	memory[`MEM_SIZE-1:0];

	logic		clk_1m;
	logic		cpu_clk;
	logic		pll_lock;
	logic		clk_disp;

	logic	[C_SIZE-1:0]	counter		= 'd0;

	logic	[7:0]	cpu_D_i;
	logic		cpu_sb;
	logic		cpu_sa;

	logic	[11:0]	cpu_addr;
	logic	[7:0]	cpu_D_o;
	logic		cpu_f0;
	logic		cpu_f1;
	logic		cpu_f2;

	logic		cpu_ADS_n;
	logic		cpu_RD_n;
	logic		cpu_WR_n;

	logic		cpu_rst_n;

	always@(posedge clk_1m) 
	begin
		counter <= counter - { {C_SIZE-1{1'b0}}, 1'b1 };
	end

	assign clk_disp = counter[C_SIZE-1];


	assign	cpu_rst_n = rst_n & pll_lock;


	scmp cpu
	(
		.rst_n(cpu_rst_n),
		.clk(cpu_clk),
		.D_i(cpu_D_i),
		.sb(cpu_sb_i),
		.sa(cpu_sa_i),
		.addr(cpu_addr),
		.D_o(cpu_D_o),
		.f0(cpu_f0),
		.f1(cpu_f1),
		.f2(cpu_f2),
		.sin(sin),
		.sout(sout),

		.ADS_n(cpu_ADS_n),
		.RD_n(cpu_RD_n),
		.WR_n(cpu_WR_n)
	);


	//load memory
	initial begin
		if (SIM)
			$readmemh("../../../../asm/ws_ep4ce10/test.vhx", memory);
		else
			$readmemh("../../../asm/ws_ep4ce10/test.vhx", memory);

	end

	always@(negedge cpu_WR_n) begin
		memory[cpu_addr & (`MEM_SIZE-1)] = cpu_D_o;
	end


	always@(cpu_RD_n, cpu_addr) begin
		if (!cpu_RD_n)
			cpu_D_i <= memory[cpu_addr & (`MEM_SIZE-1)];
		else
			cpu_D_i <= 8'b11111111;
	end

	logic	flag_h;
	logic	flag_d;
	logic	flag_i;
	logic	flag_r;

	always@(posedge cpu_clk, negedge rst_n) begin
		if (!rst_n)
			{ flag_h, flag_d, flag_i, flag_r } <= 4'b0000;
		else if (!cpu_ADS_n)
			{ flag_h, flag_d, flag_i, flag_r } <= cpu_D_o[7:4];
	end


	//debug interface
	assign led_n	= ~ { flag_h, flag_d, flag_i, flag_r };

	seg8_4 disp0(
		.clk(clk_disp),
		.nrst(rst_n),
		.number({cpu_addr[7:0], (cpu_WR_n)?cpu_D_i:cpu_D_o}),
		.dot({ flag_h, flag_d, flag_i, flag_r }),
		.sel(disp0_sel),
		.seg(disp0_seg)
	);

	generate
		if (SIM) begin
			//4m clock
			initial begin
				forever begin
					#125 cpu_clk <= 1'b1;
					#125 cpu_clk <= 1'b0;
				end
			end

			//1m clock
			initial begin
				forever begin
					#500 clk_1m <= 1'b1;
					#500 clk_1m <= 1'b0;
				end
			end

			//lock
			initial begin
				pll_lock <= 1'b0;
				#1000;
				pll_lock <= 1'b1;
			end
		end else
			pll_main pll(
				.inclk0(clk_50m),
				.c0(cpu_clk),
				.c1(clk_1m),
				.locked(pll_lock)
			);
	endgenerate


endmodule