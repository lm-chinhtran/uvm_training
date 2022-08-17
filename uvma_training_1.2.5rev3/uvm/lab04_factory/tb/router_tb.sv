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
    `uvm_info("MSG", "Testbench build phase executed", UVM_HIGH)
  endfunction
endclass