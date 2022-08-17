/*-----------------------------------------------------------------
File name     : yapp_tx_monitor.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab03_uvc yapp_tx_monitor module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class yapp_tx_monitor extends uvm_monitor;

  virtual interface yapp_if vif;

  //component macro
  `uvm_component_utils(yapp_tx_monitor)

  //constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //UVM start_of_simulation_phase()
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction

  //UVM connect phase
  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", "vif not set")
  endfunction

  // Collected Data handle
  yapp_packet pkt;

  // Count packets collected
  int num_pkt_col;

  // UVM run() phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start monitor for ", get_full_name()}, UVM_LOW);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin
      // Create collected packet instance
      pkt = yapp_packet::type_id::create("pkt", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      num_pkt_col++;
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

endclass