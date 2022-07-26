/*-----------------------------------------------------------------
File name     : sequencer.sv
Developers    : Chinh
Created       : 07/21/22
Description   : lab5 component base class
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

class sequencer extends component_base;

  int portno;
  int ok;

  // constructor with name and parent arguments
  function new (string name, component_base parent);
    super.new(name, parent);
  endfunction

  function void get_next_item(output packet p);
    psingle ps;
    pmulticast pm;
    pbroadcast pb;
    randcase
      1: begin: single_packet
        ps = new("ps", portno);
        ok = ps.randomize();
        p = ps;
      end
      1: begin: multicast_packet
        pm = new("pm", portno);
        ok = pm.randomize();
        p = pm;
      end
      1: begin: broadcast_packet
        pb = new("pb", portno);
        ok = pb.randomize();
        p = pb;
      end
    endcase
  endfunction
endclass

