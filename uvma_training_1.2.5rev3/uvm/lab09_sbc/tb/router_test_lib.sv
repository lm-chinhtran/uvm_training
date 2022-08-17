/*-----------------------------------------------------------------
File name     : base_test.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab02_test base_test module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class base_test extends uvm_test;

  router_tb tb;

  // component macro
  `uvm_component_utils(base_test)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build() phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "*", "recording_detail", 1);
    tb = router_tb::type_id::create("tb", this);
    `uvm_info("MSG", "Test build phase executed", UVM_HIGH)
  endfunction

  // UVM end_of_elaboration_phase()
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  // UVM check_phase()
  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

  // UVM run_phase()
  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask

endclass

class test2 extends base_test;

  // component macro
  `uvm_component_utils(test2)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class short_packet_test extends base_test;

  //component macro
  `uvm_component_utils(short_packet_test)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yp_tx_uvc.yp_tx_agt.yp_tx_seq.run_phase",
                                  "default_sequence",
                                  yapp_5_packets::get_type());
  endfunction
endclass

class set_config_test extends base_test;

  //component macro
  `uvm_component_utils(set_config_test)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    uvm_config_int::set(this, "tb.yp_tx_uvc.yp_tx_agt", "is_active", UVM_PASSIVE);
    super.build_phase(phase);
  endfunction
endclass

class incr_payload_test extends base_test;

  //component macro
  `uvm_component_utils(incr_payload_test)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yp_tx_uvc.yp_tx_agt.yp_tx_seq.run_phase",
                                  "default_sequence",
                                  yapp_incr_payload_seq::get_type());
  endfunction
endclass

class exhaustive_test extends base_test;

  //component macro
  `uvm_component_utils(exhaustive_test)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yp_tx_uvc.yp_tx_agt.yp_tx_seq.run_phase",
                                  "default_sequence",
                                  yapp_exhaustive_seq::get_type());
  endfunction
endclass

class send_to_dut_test extends base_test;

  //component macro
  `uvm_component_utils(send_to_dut_test)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yp_tx_uvc.yp_tx_agt.yp_tx_seq.run_phase",
                                  "default_sequence",
                                  yapp_012_seq::get_type());
  endfunction
endclass

class simple_test extends base_test;

  //component macro
  `uvm_component_utils(simple_test)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yp_tx_uvc.yp_tx_agt.yp_tx_seq.run_phase",
                                  "default_sequence",
                                  yapp_012_seq::get_type());
    uvm_config_wrapper::set(this, "tb.rx_uvc?.rx_agent.sequencer.run_phase",
                                  "default_sequence",
                                  channel_rx_resp_seq::get_type());
    uvm_config_wrapper::set(this, "tb.clk_rst_uvc.agent.sequencer.run_phase",
                                  "default_sequence",
                                  clk10_rst5_seq::get_type());
  endfunction
endclass

class test_uvc_integration extends base_test;

  //component macro
  `uvm_component_utils(test_uvc_integration)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "tb.yp_tx_uvc.yp_tx_agt.yp_tx_seq.run_phase",
                                  "default_sequence",
                                  yapp_all_four::get_type());
    uvm_config_wrapper::set(this, "tb.rx_uvc?.rx_agent.sequencer.run_phase",
                                  "default_sequence",
                                  channel_rx_resp_seq::get_type());
    uvm_config_wrapper::set(this, "tb.clk_rst_uvc.agent.sequencer.run_phase",
                                  "default_sequence",
                                  clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.hbus_uvc.masters[0].sequencer.run_phase",
                                  "default_sequence",
                                  hbus_small_packet_seq::get_type());
  endfunction
endclass

class test_mcsequencer extends base_test;

  //component macro
  `uvm_component_utils(test_mcsequencer)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.clk_rst_uvc.agent.sequencer.run_phase",
                                  "default_sequence",
                                  clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.mcsequencer.run_phase",
                                  "default_sequence",
                                  router_simple_mcseq::get_type());
    uvm_config_wrapper::set(this, "tb.rx_uvc?.rx_agent.sequencer.run_phase",
                                  "default_sequence",
                                  channel_rx_resp_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass
