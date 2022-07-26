/*-----------------------------------------------------------------
File name     : monitor.sv
Developers    : Chinh
Created       : 07/21/22
Description   : lab5 component base class
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

class monitor extends component_base;

  // constructor with name and parent arguments
  function new (string name, component_base parent);
    super.new(name, parent);
  endfunction

  task run();
    $display("Monitor @%s", pathname());
  endtask

endclass

