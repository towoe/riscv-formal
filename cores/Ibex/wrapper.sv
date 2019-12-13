`define FORMAL_KEEP (* keep *)

module rvfi_wrapper (
      input         clock,
      input         reset,
      `RVFI_OUTPUTS
);

(* keep *) wire instr_req_o;
(* keep *) `rvformal_rand_reg instr_gnt_i;
(* keep *) `rvformal_rand_reg instr_rvalid_i;
(* keep *) wire [31:0] instr_addr_o;
(* keep *) `rvformal_rand_reg [31:0] instr_rdata_i;
(* keep *) wire instr_err_i;

(* keep *) wire data_req_o;
(* keep *) `rvformal_rand_reg data_gnt_i;
(* keep *) `rvformal_rand_reg data_rvalid_i;
(* keep *) wire data_we_o;
(* keep *) wire [3:0] data_be_o;
(* keep *) wire [31:0] data_addr_o;
(* keep *) wire [31:0] data_wdata_o;
(* keep *) `rvformal_rand_reg [31:0] data_rdata_i;
(* keep *) `rvformal_rand_reg data_err_i;

(* keep *) wire sleeping;

ibex_core uut (
      .clk_i               (clock    ),
      .rst_ni              (!reset   ),

      .test_en_i           (0),

      .hart_id_i           (32'h0),
      .boot_addr_i         (32'h0),

      .instr_req_o         (instr_req_o),
      .instr_gnt_i         (instr_gnt_i),
      .instr_rvalid_i      (instr_rvalid_i),
      .instr_addr_o        (instr_addr_o),
      .instr_rdata_i       (instr_rdata_i),
      .instr_err_i         (instr_err_i),

      .data_req_o          (data_req_o),
      .data_gnt_i          (data_gnt_i),
      .data_rvalid_i       (data_rvalid_i),
      .data_we_o           (data_we_o),
      .data_be_o           (data_be_o),
      .data_addr_o         (data_addr_o),
      .data_wdata_o        (data_wdata_o),
      .data_rdata_i        (data_rdata_i),
      .data_err_i          (data_err_i),

      .irq_software_i      (1'b0),
      .irq_timer_i         (1'b0),
      .irq_external_i      (1'b0),
      .irq_fast_i          (15'b0),
      .irq_nm_i            (1'b0),

      .debug_req_i         ('b0),

      .fetch_enable_i      ('b1),
      .core_sleep_o        (),

      `RVFI_CONN
);

endmodule

