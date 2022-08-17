/*-----------------------------------------------------------------
File name     : router_tb.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab02_test router_tb module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class router_tb extends uvm_env;

  yapp_tx_env yp_tx_uvc;
  channel_env rx_uvc0;
  channel_env rx_uvc1;
  channel_env rx_uvc2;
  hbus_env hbus_uvc;
  clock_and_reset_env clk_rst_uvc;

  // Scoreboard
  router_scoreboard sb;

  // Virtual Sequencer
  router_mcsequencer mcsequencer;

  // component macro
  `uvm_component_utils(router_tb)


  // constructor
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // UVM build() phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    yp_tx_uvc = yapp_tx_env::type_id::create("yp_tx_uvc", this);
    //assign channel ids and create
    uvm_config_int::set(this, "rx_uvc0", "channel_id", 0);
    uvm_config_int::set(this, "rx_uvc1", "channel_id", 1);
    uvm_config_int::set(this, "rx_uvc2", "channel_id", 2);
    rx_uvc0 = channel_env::type_id::create("rx_uvc0", this);
    rx_uvc1 = channel_env::type_id::create("rx_uvc1", this);
    rx_uvc2 = channel_env::type_id::create("rx_uvc2", this);
    //assign HBUS masters/slaves and create
    uvm_config_int::set(this, "hbus_uvc", "num_masters", 1);
    uvm_config_int::set(this, "hbus_uvc", "num_slaves", 0);
    hbus_uvc = hbus_env::type_id::create("hbus_uvc", this);
    //create clock and reset UVC
    clk_rst_uvc = clock_and_reset_env::type_id::create("clk_rst_uvc", this);
   // virtual sequencer
   mcsequencer = router_mcsequencer::type_id::create("mcsequencer", this);
   // scoreboard
   sb = router_scoreboard::type_id::create("sb", this);

    `uvm_info("MSG", "Testbench build phase executed", UVM_HIGH)
  endfunction

  // UVM connect_phase
  function void connect_phase(uvm_phase phase);
    // Virtual Sequencer Connections
    mcsequencer.hbus_seqr = hbus_uvc.masters[0].sequencer;
    mcsequencer.yapp_seqr = yp_tx_uvc.yp_tx_agt.yp_tx_seq;
    // Connect scoreboard
    yp_tx_uvc.yp_tx_agt.yp_tx_mon.yapp_out.connect(sb.sb_yapp_in);
    rx_uvc0.rx_agent.monitor.item_collected_port.connect(sb.sb_chan0);
    rx_uvc1.rx_agent.monitor.item_collected_port.connect(sb.sb_chan1);
    rx_uvc2.rx_agent.monitor.item_collected_port.connect(sb.sb_chan2);

  endfunction : connect_phase

endclass