/*-----------------------------------------------------------------
File name     : driver.sv
Developers    : Chinh
Created       : 07/21/22
Description   : lab5 component base class
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

class driver extends component_base;

  sequencer sref;
  virtual interface port_if vif;
  packet p;

  // constructor with name and parent arguments
  function new (string name, component_base parent);
    super.new(name, parent);
  endfunction

  task run(int runs);
    $display("Driver @%s", pathname());
    $display("Sequencer @%s", sref.pathname());
    repeat (runs) begin
      sref.get_next_item(p);
      p.print();
      vif.drive_packet(p);
    end
  endtask

endclass

