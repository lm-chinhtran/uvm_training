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

  virtual interface port_if vif;
  int portno;
  packet p;

  // constructor with name and parent arguments
  function new (string name, component_base parent);
    super.new(name, parent);
  endfunction

  task run();
    $display("Monitor @%s", pathname());
    forever begin
      vif.collect_packet(p);
      $display("Port%0d Monitor (%s) captures packet IN @%t", portno, pathname(), $time);
      p.print();
    end
  endtask

endclass

