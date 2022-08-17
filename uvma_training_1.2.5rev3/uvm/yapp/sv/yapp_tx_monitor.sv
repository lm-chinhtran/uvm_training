/*-----------------------------------------------------------------
File name     : yapp_tx_monitor.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab03_uvc yapp_tx_monitor module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

// enum to control coverage
typedef enum bit {COV_ENABLE, COV_DISABLE} cover_e;

class yapp_tx_monitor extends uvm_monitor;

  virtual interface yapp_if vif;

  // TLM port used to connect the monitor to the scoreboard
  uvm_analysis_port #(yapp_packet) yapp_out;

  // coverage enable property
  cover_e cov_control = COV_ENABLE;

  // Collected Data handle
  yapp_packet pkt;

  // Count packets collected
  int num_pkt_col;

  //component macro
  `uvm_component_utils_begin(yapp_tx_monitor)
    `uvm_field_enum(cover_e, cov_control, UVM_ALL_ON)
    `uvm_field_int(num_pkt_col, UVM_ALL_ON)
  `uvm_component_utils_end

  // coverage model
  covergroup collected_pkts_cg;
    option.per_instance = 1;

    // coverpoint for length
    REQ1_length: coverpoint pkt.length {
      bins MIN = {1};
      bins SMALL = {[2:10]};
      bins MEDIUM = {[11:40]};
      bins LARGE = {[41:62]};
      bins MAX = {63};
    }

    // coverpoint  for address
    REQ2_addr: coverpoint pkt.addr {
      bins addr = {[0:2]};
      bins illegal = {3};
    }

    // coverpoint for bad parity
    REQ3_bad_parity: coverpoint pkt.parity_type {
      bins bad = {BAD_PARITY};
      bins good = default;
    }

    // cross length and address
    REQ3_cross_addr_length: cross REQ1_length, REQ2_addr;

    // cross address and parity
    REQ3_cross_addr_bad_parity: cross REQ2_addr, REQ3_bad_parity;
  endgroup

  //constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    yapp_out = new("yapp_out", this);
    if (cov_control == COV_ENABLE) begin
      `uvm_info(get_type_name(), "YAPP MONITOR COVERAGE CREATED", UVM_LOW)
      collected_pkts_cg = new();
      collected_pkts_cg.set_inst_name({get_full_name, ".monitor_pkt"});
    end
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
      yapp_out.write(pkt);
      num_pkt_col++;
      // trigger coverage
      if (cov_control == COV_ENABLE) begin
        `uvm_info(get_type_name(), "YAPP MONITOR COVERAGE SAMPLE", UVM_NONE)
        collected_pkts_cg.sample();
      end
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

endclass