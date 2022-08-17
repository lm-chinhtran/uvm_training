/*-----------------------------------------------------------------
File name     : yapp_tx_driver.sv
Developers    : Chinh
Created       : 07/28/22
Description   : lab03_uvc yapp_tx_driver module UVC
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright (c) 2021 LeapMind Inc. All rights reserved.
-----------------------------------------------------------------*/

class yapp_tx_driver extends uvm_driver #(yapp_packet);

  //component macro
  `uvm_component_utils(yapp_tx_driver)

  //constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // UVM run_phase()
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
    end
  endtask

  // print the driven packet
  task send_to_dut(yapp_packet packet);
    `uvm_info(get_type_name(), $sformatf("Input Packet to Send: \n%s", packet.sprint()), UVM_LOW);
    #10ns;
  endtask

  //UVM start_of_simulation_phase()
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction

endclass