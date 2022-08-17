/*-----------------------------------------------------------------
File name     : yapp_tx_agent.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab03_uvc yapp_tx_agent module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class yapp_tx_agent extends uvm_agent;

  yapp_tx_sequencer yp_tx_seq;
  yapp_tx_driver yp_tx_drv;
  yapp_tx_monitor yp_tx_mon;

  //component macro
  `uvm_component_utils_begin(yapp_tx_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  //constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    yp_tx_mon = yapp_tx_monitor::type_id::create("yp_tx_mon", this);
    if (is_active == UVM_ACTIVE) begin
      yp_tx_drv = yapp_tx_driver::type_id::create("yp_tx_drv", this);
      yp_tx_seq = yapp_tx_sequencer::type_id::create("yp_tx_seq", this);
    end
    `uvm_info(get_type_name(), {"built agent for ", get_full_name()}, UVM_LOW);
  endfunction

  //UVM connect phase
  function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE) begin
      yp_tx_drv.seq_item_port.connect(yp_tx_seq.seq_item_export);
    end
  endfunction

  //UVM start_of_simulation_phase()
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction

endclass