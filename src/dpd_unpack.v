module dpd_unpack (
	input  wire [9:0] dpd, // dpd input
	output wire [3:0] d2,  // hundreds digit
	output wire [3:0] d1,  // tens digit
	output wire [3:0] d0   // ones digit
);

	wire a = dpd[9];
	wire b = dpd[8];
	wire c = dpd[7];
	wire d = dpd[6];
	wire e = dpd[5];
	wire f = dpd[4];
	wire g = dpd[3];
	wire h = dpd[2];
	wire i = dpd[1];
	wire j = dpd[0];

	wire bcd_A = (~d & g & h) | (e & g & h) | (g & h & ~i);
	wire bcd_B = (a & d & ~e & i) | (a & ~g) | (a & ~h);
	wire bcd_C = (b & d & ~e & i) | (b & ~g) | (b & ~h);
	wire bcd_D = (d & g & i) | (~e & g & i) | (g & ~h & i);
	wire bcd_E = (a & ~d & e & g & h & i) | (d & ~g) | (d & ~i);
	wire bcd_F = (b & ~d & e & h) | (e & ~g) | (e & ~i);
	wire bcd_G = (d & g & h & i) | (e & g & h & i) | (g & ~h & ~i);
	wire bcd_H = (a & ~d & ~e & h) | (a & h & ~i) | (d & g & ~h & i) | (~g & h);
	wire bcd_I = (b & ~d & ~e & h & i) | (b & g & h & ~i) | (e & ~h & i) | (~g & i);

	assign d2 = {bcd_A, bcd_B, bcd_C, c};
	assign d1 = {bcd_D, bcd_E, bcd_F, f};
	assign d0 = {bcd_G, bcd_H, bcd_I, j};

endmodule
