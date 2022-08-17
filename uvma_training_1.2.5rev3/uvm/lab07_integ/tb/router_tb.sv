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

    `uvm_info("MSG", "Testbench build phase executed", UVM_HIGH)
  endfunction
endclass