/*-----------------------------------------------------------------
File name     : router_mcsequencer.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab08
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

class router_mcsequencer extends uvm_sequencer;

  yapp_tx_sequencer yapp_seqr;
  hbus_master_sequencer hbus_seqr;

  // Required macro for sequences automation
  `uvm_component_utils(router_mcsequencer)

  //constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : router_mcsequencer