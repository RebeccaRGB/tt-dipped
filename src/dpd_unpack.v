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

	wire A = (~d & g & h) | (e & g & h) | (g & h & ~i);
	wire B = (a & d & ~e & i) | (a & ~g) | (a & ~h);
	wire C = (b & d & ~e & i) | (b & ~g) | (b & ~h);
	wire D = (d & g & i) | (~e & g & i) | (g & ~h & i);
	wire E = (a & ~d & e & g & h & i) | (d & ~g) | (d & ~i);
	wire F = (b & ~d & e & h) | (e & ~g) | (e & ~i);
	wire G = (d & g & h & i) | (e & g & h & i) | (g & ~h & ~i);
	wire H = (a & ~d & ~e & h) | (a & h & ~i) | (d & g & ~h & i) | (~g & h);
	wire I = (b & ~d & ~e & h & i) | (b & g & h & ~i) | (e & ~h & i) | (~g & i);

	assign d2 = {A, B, C, c};
	assign d1 = {D, E, F, f};
	assign d0 = {G, H, I, j};

endmodule
