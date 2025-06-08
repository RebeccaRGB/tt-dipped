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

  // binary input
  wire [9:0] bin_in = {ui_in[1:0], uio_in};
  wire       bin_in_v = (bin_in >= 10'd1000);
  wire [9:0] bin_in_m3 = bin_in_v ? (bin_in - 10'd1000) : bin_in;
  wire [9:0] bin_in_d2 = bin_in_m3 / 10'd100;
  wire [9:0] bin_in_m2 = bin_in_m3 - bin_in_d2 * 10'd100;
  wire [9:0] bin_in_d1 = bin_in_m2 / 10'd10;
  wire [9:0] bin_in_d0 = bin_in_m2 - bin_in_d1 * 10'd10;
  wire [9:0] bin_in_dpd;
  dpd_pack bin_in_dpd_pack(
    .d2(bin_in_d2[3:0]),
    .d1(bin_in_d1[3:0]),
    .d0(bin_in_d0[3:0]),
    .dpd(bin_in_dpd)
  );

  // bcd input
  wire [3:0] d2_in = ui_in[3:0];
  wire [3:0] d1_in = uio_in[7:4];
  wire [3:0] d0_in = uio_in[3:0];
  wire [3:0] bcd_in_v = {
    (d2_in >= 10) || (d1_in >= 10) || (d0_in >= 10),
    (d2_in >= 10),   (d1_in >= 10),   (d0_in >= 10)
  };
  wire [9:0] bcd_in_bin = (
    {6'd0, d2_in} * 10'd100 +
    {6'd0, d1_in} * 10'd10 +
    {6'd0, d0_in}
  );
  wire [9:0] bcd_in_dpd;
  dpd_pack bcd_in_dpd_pack(
    .d2(d2_in),
    .d1(d1_in),
    .d0(d0_in),
    .dpd(bcd_in_dpd)
  );

  // dpd input
  wire [9:0] dpd_in = {ui_in[1:0], uio_in};
  wire [3:0] dpd_in_d2;
  wire [3:0] dpd_in_d1;
  wire [3:0] dpd_in_d0;
  dpd_unpack dpd_in_unpack(
    .dpd(dpd_in),
    .d2(dpd_in_d2),
    .d1(dpd_in_d1),
    .d0(dpd_in_d0)
  );
  wire [9:0] dpd_in_bin = (
    {6'd0, dpd_in_d2} * 10'd100 +
    {6'd0, dpd_in_d1} * 10'd10 +
    {6'd0, dpd_in_d0}
  );
  wire [9:0] dpd_in_dpd;
  dpd_pack dpd_in_dpd_pack(
    .d2(dpd_in_d2),
    .d1(dpd_in_d1),
    .d0(dpd_in_d0),
    .dpd(dpd_in_dpd)
  );

  // async output
  wire as_bcd_out = ui_in[7];
  wire as_dpd_out = ui_in[6];
  wire as_out_a0 = ui_in[5];
  wire as_bcd_in = ui_in[4];
  wire as_dpd_in = ui_in[3];
  wire [3:0] as_out_v = (
    as_bcd_in ? bcd_in_v :
    as_dpd_in ? 4'b0 :
    {3'b0, bin_in_v}
  );
  wire [11:0] as_out_12 = (
    as_bcd_in ? (
      as_bcd_out ? {d2_in, d1_in, d0_in} :
      as_dpd_out ? {2'b0, bcd_in_dpd} :
      {2'b0, bcd_in_bin}
    ) : as_dpd_in ? (
      as_bcd_out ? {dpd_in_d2, dpd_in_d1, dpd_in_d0} :
      as_dpd_out ? {2'b0, dpd_in_dpd} :
      {2'b0, dpd_in_bin}
    ) : (
      as_bcd_out ? {bin_in_d2[3:0], bin_in_d1[3:0], bin_in_d0[3:0]} :
      as_dpd_out ? {2'b0, bin_in_dpd} :
      {2'b0, bin_in_m3}
    )
  );
  wire [7:0] as_out_8 = (
    as_out_a0 ? {as_out_v, as_out_12[11:8]} : as_out_12[7:0]
  );

  // latched register
  reg [3:0] d2_out;
  reg [3:0] d1_out;
  reg [3:0] d0_out;
  wire [9:0] dpd_out;
  dpd_pack dpd_out_pack(
    .d2(d2_out),
    .d1(d1_out),
    .d0(d0_out),
    .dpd(dpd_out)
  );
  wire [3:0] bcd_out_v = {
    (d2_out >= 10) || (d1_out >= 10) || (d0_out >= 10),
    (d2_out >= 10),   (d1_out >= 10),   (d0_out >= 10)
  };
  wire [9:0] bin_out = (
    {6'd0, d2_out} * 10'd100 +
    {6'd0, d1_out} * 10'd10 +
    {6'd0, d0_out}
  );

  // sync output
  wire we = ui_in[7];
  wire oe = ui_in[6];
  wire dpd_sel = ui_in[5];
  wire bcd_sel = ui_in[4];

  wire [3:0] s_out_v = bcd_out_v;
  wire [11:0] s_out_12 = (
    bcd_sel ? {d2_out, d1_out, d0_out} :
    dpd_sel ? {2'b0, dpd_out} :
    {2'b0, bin_out}
  );
  wire [7:0] s_out_hi = {s_out_v, s_out_12[11:8]};
  wire [7:0] s_out_lo = s_out_12[7:0];

  always @(posedge clk) begin
    if (~rst_n) begin
      d2_out <= 0;
      d1_out <= 0;
      d0_out <= 0;
    end else if (~we) begin
      if (bcd_sel) begin
        d2_out <= d2_in;
        d1_out <= d1_in;
        d0_out <= d0_in;
      end else if (dpd_sel) begin
        d2_out <= dpd_in_d2;
        d1_out <= dpd_in_d1;
        d0_out <= dpd_in_d0;
      end else begin
        d2_out <= bin_in_d2[3:0];
        d1_out <= bin_in_d1[3:0];
        d0_out <= bin_in_d0[3:0];
      end
    end
  end

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out = rst_n ? s_out_hi : as_out_8;
  assign uio_out = rst_n ? s_out_lo : 8'b0;
  assign uio_oe = rst_n ? {8{~oe}} : 8'b0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, bin_in_d2[9:4], bin_in_d1[9:4], bin_in_d0[9:4], 1'b0};

endmodule
