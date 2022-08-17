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
    tb = new("tb", this);
    `uvm_info("MSG", "Test build phase executed", UVM_HIGH)
  endfunction

  // UVM end_of_elaboration_phase()
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

endclass

class test2 extends base_test;

  // component macro
  `uvm_component_utils(test2)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass