/*-----------------------------------------------------------------
File name     : agent.sv
Developers    : Chinh
Created       : 07/21/22
Description   : lab5 component base class
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

class agent extends component_base;

  driver drv;
  sequencer seq;
  monitor mon;

  // constructor with name and parent arguments
  function new (string name, component_base parent);
    super.new(name, parent);
    drv = new("drv", this);
    seq = new("seq", this);
    mon = new("mon", this);
    drv.sref = seq;
  endfunction

endclass

