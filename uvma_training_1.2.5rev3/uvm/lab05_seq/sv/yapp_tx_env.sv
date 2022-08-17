/*-----------------------------------------------------------------
File name     : yapp_tx_env.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab03_uvc yapp_tx_env module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class yapp_tx_env extends uvm_env;

  yapp_tx_agent yp_tx_agt;

  //component macro
  `uvm_component_utils(yapp_tx_env)

  //constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    yp_tx_agt = yapp_tx_agent::type_id::create("yp_tx_agt", this);
    `uvm_info(get_type_name(), {"built env for ", get_full_name()}, UVM_LOW);
  endfunction

endclass