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

	wire a = A & E & G | A & H | B;
	wire b = A & F & G | A & I | C;
	wire c = d2[0];
	wire d = ~A & D & H | ~A & E | D & G | E & ~G;
	wire e = A & G | ~A & D & I | F;
	wire f = d1[0];
	wire g = A | D | G;
	wire h = A | D & G | ~D & H;
	wire i = A & G | ~A & I | D;
	wire j = d0[0];

	assign dpd = {a, b, c, d, e, f, g, h, i, j};

endmodule
