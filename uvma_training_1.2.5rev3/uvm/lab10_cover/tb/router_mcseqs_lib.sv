/*-----------------------------------------------------------------
File name     : router_mcseqs_lib.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab08
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

class router_simple_mcseq extends uvm_sequence;

  // Required macro for sequences automation
  `uvm_object_utils(router_simple_mcseq)
  `uvm_declare_p_sequencer(router_mcsequencer)

  // YAPP packet sequences
  yapp_012_seq y012;
  yapp_exhaustive_seq yexhaustive;
  yapp_all_four y4;

  // HBUS sequences
  hbus_small_packet_seq hbus_small_pkt;
  hbus_read_max_pkt_seq hbus_rd_maxpkt;
  hbus_set_default_regs_seq hbus_large_pkt;

  //constructor
  function new(string name="router_simple_mcseq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

  virtual task body();
    `uvm_info("router_simple_mcseq", "Executing router_simple_mcseq", UVM_LOW )
    //increasing coverage
    // Send 6 random packets
    `uvm_do_on(y012, p_sequencer.yapp_seqr)
    `uvm_do_on(y012, p_sequencer.yapp_seqr)
    `uvm_do_on(yexhaustive, p_sequencer.yapp_seqr)
    `uvm_do_on(y4, p_sequencer.yapp_seqr)
  endtask

endclass : router_simple_mcseq