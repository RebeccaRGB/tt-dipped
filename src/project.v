/*
 * Copyright (c) 2025 Rebecca G. Bettencourt
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_rebeccargb_dipped (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire [9:0] bin_in = {ui_in[1:0], uio_in};
  wire [9:0] bin_in_m3 = (bin_in < 10'd1000) ? bin_in : (bin_in - 10'd1000);
  wire [9:0] bin_in_d2 = bin_in_m3 / 10'd100;
  wire [9:0] bin_in_m2 = bin_in_m3 - bin_in_d2 * 10'd100;
  wire [9:0] bin_in_d1 = bin_in_m2 / 10'd10;
  wire [9:0] bin_in_d0 = bin_in_m2 - bin_in_d1 * 10'd10;

  wire [3:0] d2_in = ui_in[3:0];
  wire [3:0] d1_in = uio_in[7:4];
  wire [3:0] d0_in = uio_in[3:0];

  wire [9:0] dpd_in = {ui_in[1:0], uio_in};
  wire [3:0] dpd_in_d2;
  wire [3:0] dpd_in_d1;
  wire [3:0] dpd_in_d0;
  dpd_unpack du(.dpd(dpd_in), .d2(dpd_in_d2), .d1(dpd_in_d1), .d0(dpd_in_d0));

  reg [3:0] d2_out;
  reg [3:0] d1_out;
  reg [3:0] d0_out;
  wire [9:0] dpd_out; dpd_pack dp(.d2(d2_out), .d1(d1_out), .d0(d0_out), .dpd(dpd_out));
  wire [9:0] bin_out = {6'd0, d2_out} * 10'd100 + {6'd0, d1_out} * 10'd10 + {6'd0, d0_out};

  wire we = ui_in[7];
  wire oe = ui_in[6];
  wire dpd_sel = ui_in[5];
  wire bcd_sel = ui_in[4];

  always @(posedge clk) begin
    if (~rst_n) begin
      d2_out <= 0;
      d1_out <= 0;
      d0_out <= 0;
    end else if (~we) begin
      if (dpd_sel) begin
        d2_out <= dpd_in_d2;
        d1_out <= dpd_in_d1;
        d0_out <= dpd_in_d0;
      end else if (bcd_sel) begin
        d2_out <= d2_in;
        d1_out <= d1_in;
        d0_out <= d0_in;
      end else begin
        d2_out <= bin_in_d2;
        d1_out <= bin_in_d1;
        d0_out <= bin_in_d0;
      end
    end
  end

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7] = (d2_out >= 10) || (d1_out >= 10) || (d0_out >= 10);
  assign uo_out[6] = (d2_out >= 10);
  assign uo_out[5] = (d1_out >= 10);
  assign uo_out[4] = (d0_out >= 10);
  assign uo_out[3:0] = dpd_sel ? {2'b0, dpd_out[9:8]} : bcd_sel ? d2_out : {2'b0, bin_out[9:8]};
  assign uio_out = dpd_sel ? dpd_out[7:0] : bcd_sel ? {d1_out, d0_out} : bin_out[7:0];
  assign uio_oe = {8{~oe}};

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
