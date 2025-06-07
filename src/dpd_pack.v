module dpd_pack (
	input  wire [3:0] d2,  // hundreds digit
	input  wire [3:0] d1,  // tens digit
	input  wire [3:0] d0,  // ones digit
	output wire [9:0] dpd  // dpd output
);

	wire A = d2[3];
	wire B = d2[2];
	wire C = d2[1];
	wire D = d1[3];
	wire E = d1[2];
	wire F = d1[1];
	wire G = d0[3];
	wire H = d0[2];
	wire I = d0[1];

	wire dpd_a = A & E & G | A & H | B;
	wire dpd_b = A & F & G | A & I | C;
	wire dpd_c = d2[0];
	wire dpd_d = ~A & D & H | ~A & E | D & G | E & ~G;
	wire dpd_e = A & G | ~A & D & I | F;
	wire dpd_f = d1[0];
	wire dpd_g = A | D | G;
	wire dpd_h = A | D & G | ~D & H;
	wire dpd_i = A & G | ~A & I | D;
	wire dpd_j = d0[0];

	assign dpd = {
		dpd_a, dpd_b, dpd_c, dpd_d, dpd_e,
		dpd_f, dpd_g, dpd_h, dpd_i, dpd_j
	};

endmodule
