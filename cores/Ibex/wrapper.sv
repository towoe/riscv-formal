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
(* keep *) `rvformal_rand_reg instr_err_i;

(* keep *) wire data_req_o;
(* keep *) `rvformal_rand_reg data_gnt_i;
(* keep *) `rvformal_rand_reg data_rvalid_i;
(* keep *) wire data_we_o;
(* keep *) wire [3:0] data_be_o;
(* keep *) wire [31:0] data_addr_o;
(* keep *) wire [31:0] data_wdata_o;
(* keep *) `rvformal_rand_reg [31:0] data_rdata_i;
(* keep *) `rvformal_rand_reg data_err_i;

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

// Provide a valid response on the data memory interface.
// This is required so that load instructions are retired in a finite time.
reg [2:0] data_gnt_cnt;
reg [2:0] data_valid_cnt;
reg [1:0] data_err_cnt;

always_ff @(posedge clock) begin
      // Enforce a data grant signal to be asserted in the last three cycles.
      data_gnt_cnt <= {data_gnt_cnt, data_gnt_i};
      assume(|data_gnt_cnt);

      // Enforce a valid response while the grant signal is not asserted.
      data_valid_cnt <= {data_valid_cnt, !data_gnt_i && data_rvalid_i};
      assume(|data_valid_cnt);

      // Enforce a response without an error.
      data_err_cnt <= {data_err_cnt, data_err_i && data_rvalid_i};
      assume(~|data_err_cnt);
end



`ifdef IBEX_FAIRNESS
// Provide a valid response on the instruction memory interface.
// For the liveness check it is required that after one valid instruction another instruction will
// be retired. This depends on the external memory interface replying with a valid response.
// It is also not possible to wait for an interrupt if no interrupts are configured.
reg [2:0] instr_gnt_cnt;
reg [2:0] instr_valid_cnt;
reg [1:0] instr_err_cnt;

// Instruction memory response restrictions analog to data memory interface.
always_ff @(posedge clock) begin
      instr_gnt_cnt <= {instr_gnt_cnt, instr_gnt_i};
      assume(|instr_gnt_cnt);

      instr_valid_cnt <= {instr_valid_cnt, !instr_gnt_i && instr_rvalid_i};
      assume(|instr_valid_cnt);

      instr_err_cnt <= {instr_err_cnt, instr_err_i && instr_rvalid_i};
      assume(~|instr_err_cnt);
end

// Restrict the active instruction in the check cycle to be not a wait for interrupt.
always @(posedge clock) begin
      if (rvfi_valid) begin
	    assume(rvfi_insn != 32'b 0001000_00101_00000_000_00000_1110011); // WFI
      end
end
`endif

endmodule

