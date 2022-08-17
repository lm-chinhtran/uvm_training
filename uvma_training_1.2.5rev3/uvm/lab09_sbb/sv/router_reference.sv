/*-----------------------------------------------------------------
File name     : router_reference.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab09_sba simpe packet compare function using Verilog equality operators
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class router_reference extends uvm_component;
  //component macro
  `uvm_component_utils(router_reference)

  //imp objects macro
  `uvm_analysis_imp_decl(_yapp)
  `uvm_analysis_imp_decl(_hbus)

  uvm_analysis_imp_yapp  #(yapp_packet, router_reference) sb_yapp_in;
  uvm_analysis_imp_hbus #(hbus_transaction, router_reference) sb_hbus_in;

  //TLM output port to Scoreboard
  uvm_analysis_port #(yapp_packet) sb_yapp_out;

  // Configuration Information
   bit [7:0] max_pktsize_reg = 8'h3F;
   bit [7:0] router_enable_reg = 1'b1;

  // Statistics
  int dropped_packets, bad_addr_packets, oversized_packets, forwarded_packets;

  // component constructor - required syntax for UVM automation and utilities
  function new (string name="", uvm_component parent=null);
    super.new(name, parent);
    sb_yapp_in = new("sb_yapp_in", this);
    sb_hbus_in = new("sb_hbus_in", this);
    //TLM output port
    sb_yapp_out = new("sb_yapp_out", this);
  endfunction : new

  //write HBUS transaction
  virtual function void write_hbus(hbus_transaction trans);
    `uvm_info(get_type_name(), $sformatf("Received HBUS Transaction: \n%s", trans.sprint()), UVM_MEDIUM)
    // For now - capture the max_pktsize_reg and router_enable_reg
    // values whenever a hbus transaction is written
    if (trans.hwr_rd == HBUS_WRITE)
      case (trans.haddr)
        'h1000 : max_pktsize_reg = trans.hdata;
        'h1001 : router_enable_reg = trans.hdata;
      endcase
  endfunction

  //YAPP packet write
  virtual function void write_yapp(yapp_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Received YAPP Packet: \n%s", pkt.sprint()), UVM_MEDIUM)

    // Check if router is enabled and packet has valid size before sending to Scoreboard
    if (pkt.addr == 3) begin
      bad_addr_packets++;
      dropped_packets++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
    end
    else if (router_enable_reg == 0) begin
      dropped_packets++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [ROUTER DISABLED]", UVM_LOW)
    end
    else begin
      if (pkt.length > max_pktsize_reg) begin
        oversized_packets++;
        dropped_packets++;
        `uvm_info(get_type_name(), "YAPP Packet Dropped [OVERSIZED]", UVM_LOW)
      end
      else begin
        sb_yapp_out.write(pkt);
        forwarded_packets++;
        `uvm_info(get_type_name(), "YAPP Packet Sent to Scoreboard", UVM_LOW)
      end
    end
  endfunction

  // UVM report() phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report:\n   Router Reference: Packet Statistics \n     Packets Dropped:   %0d\n     Packets Forwarded: %0d\n     Oversized Packets: %0d\n     BAD ADDRESS Packets: %0d\n", dropped_packets, forwarded_packets, oversized_packets, bad_addr_packets), UVM_LOW)
  endfunction : report_phase

endclass: router_reference
