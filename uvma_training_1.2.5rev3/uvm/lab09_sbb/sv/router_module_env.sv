/*-----------------------------------------------------------------
File name     : router_module_env.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab09_sba simpe packet compare function using Verilog equality operators
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class router_module_env extends uvm_component;
  //component macro
  `uvm_component_utils(router_module_env)

  // scoreboad and router reference handle
  router_scoreboard router_sb;
  router_reference router_ref;

  // component constructor - required syntax for UVM automation and utilities
  function new (string name="", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    router_sb = router_scoreboard::type_id::create("router_sb", this);
    router_ref = router_reference::type_id::create("router_ref", this);
  endfunction : build_phase

  // UVM connect phase
  function void connect_phase(uvm_phase phase);
    router_ref.sb_yapp_out.connect(router_sb.sb_yapp_in);
  endfunction

endclass: router_module_env
