module reg8 (
input	wire		rst_n,
input	wire		clk,
input   wire		clken,
input	wire	[7:0]	D,
input	wire		ctl_ld,
output	reg	[7:0]	Q
	);

	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			Q <= 8'b0;		
		end
		else if (clken) begin
			if (ctl_ld) begin
				Q <= D;
			end	
		end
	end


endmodule