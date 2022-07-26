/*-----------------------------------------------------------------
File name     : packet_vc.sv
Developers    : Chinh
Created       : 07/21/22
Description   : lab5 component base class
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

class packet_vc extends component_base;

  agent agt;

  // constructor with name and parent arguments
  function new (string name, component_base parent);
    super.new(name, parent);
    agt = new("agt", this);
  endfunction

  function void configure (virtual interface port_if vif, int portno);
    agt.drv.vif = vif;
    agt.mon.vif = vif;
    agt.seq.portno = portno;
    agt.mon.portno = portno;
  endfunction

  task run(int runs);
    fork
      agt.mon.run();
    join_none
    agt.drv.run(runs);
  endtask
endclass

