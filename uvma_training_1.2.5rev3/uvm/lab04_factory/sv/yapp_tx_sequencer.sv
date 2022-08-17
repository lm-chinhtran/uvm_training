/*-----------------------------------------------------------------
File name     : yapp_tx_sequencer.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab03_uvc yapp_tx_sequencer module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet);

  //component macro
  `uvm_component_utils(yapp_tx_sequencer)

  //constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //UVM start_of_simulation_phase()
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction

endclass