/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);

  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask

endclass : yapp_5_packets

class yapp_1_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_1_seq)

  // Constructor
  function new(string name="yapp_1_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b01;})
  endtask

endclass : yapp_1_seq

class yapp_012_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_012_seq)

  // Constructor
  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b00;})
    `uvm_do_with(req, {req.addr == 2'b01;})
    `uvm_do_with(req, {req.addr == 2'b10;})
  endtask

endclass : yapp_012_seq

class yapp_111_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_111_seq)

  // Constructor
  function new(string name="yapp_111_seq");
    super.new(name);
  endfunction

  // Nested Sequence - executes yapp_1_seq three times
  yapp_1_seq addr_1_seq;

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat(3)
      `uvm_do(addr_1_seq)
  endtask

endclass : yapp_111_seq

class yapp_repeat_addr_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_repeat_addr_seq)

  // Constructor
  function new(string name="yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  // randomize the addr
  rand bit[1:0] ran_addr;
  constraint legal_addr {ran_addr != 2'b11;}

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)
    repeat(2)
      `uvm_do_with(req, {req.addr == ran_addr;})
  endtask

endclass : yapp_repeat_addr_seq

class yapp_incr_payload_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_incr_payload_seq)

  // Constructor
  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    int ok;
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
    `uvm_create(req)
    ok = req.randomize();
    foreach(req.payload[i])
      req.payload[i] = i;
    req.set_parity();
    `uvm_send(req);
  endtask

endclass : yapp_incr_payload_seq

class yapp_exhaustive_seq extends yapp_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(yapp_exhaustive_seq)

  // Constructor
  function new(string name="yapp_exhaustive_seq");
    super.new(name);
  endfunction

  // seq handles
  yapp_1_seq y1;
  yapp_012_seq y012;
  yapp_111_seq y111;
  yapp_repeat_addr_seq yrepeat_addr;
  yapp_incr_payload_seq yincr_payload;

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
    `uvm_do(y1)
    `uvm_do(y012)
    `uvm_do(y111)
    `uvm_do(yrepeat_addr)
    `uvm_do(yincr_payload)
  endtask

endclass : yapp_exhaustive_seq
