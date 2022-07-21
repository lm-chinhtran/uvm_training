/*-----------------------------------------------------------------
File name     : packet_data.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : lab1 packet data item
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

// Follow instructions in lab book

// add print and type policies here
typedef enum { ANY, SINGLE, MULTICAST, BROADCAST } packet_type;
typedef enum {HEX,BIN,DEC} pp_t;
typedef enum {UNIDED, IDED} tag_t;

// packet class
class packet;
  // add properties here
  local string name;
  rand bit [3:0] target;
  bit [3:0] source;
  rand bit [7:0] data;
  rand packet_type ptype;

  int tag;
  static int pktcount;
  tag_t tagmode;

  // add constructor to set instance name and source by arguments and packet type
  function new (string name, int src);
    this.name = name;
    source = 1 << src;
    ptype = ANY;
    pktcount++;
    tag = pktcount;
  endfunction

  //constraint to define target cannot be zero & target cannot contain same bit set as source
  constraint ts_bits {(target & source) == 4'b0;}
  constraint t_not0 {target != 0;}
  constraint packet_type {ptype == SINGLE -> target inside {1, 2, 4, 8};
                          ptype == MULTICAST -> target inside {3, [5:7], [9:14]};
                          ptype == BROADCAST -> target == 15;}

  function string getname ();
    return name;
  endfunction

  function string gettype ();
    return ptype.name();
  endfunction

  function void post_randomize();
    if (tagmode == IDED) data = tag;
  endfunction

  static function int getcount();
    return pktcount;
  endfunction
  // add print with policy
  function void print (input pp_t pp = DEC);
    $display("----------------------------");
    $display("name: %s, type: %s tag: %0d pktcount %0d tagmode %s",getname(), gettype(), tag, pktcount, tagmode.name());
    case(pp)
      HEX: $display("from source %h, to target %h, data %h",source,target,data);
      DEC: $display("from source %0d, to target %0d, data %0d",source,target,data);
      BIN: $display("from source %b, to target %b, data %b",source,target,data);
    endcase
    $display("----------------------------------\n");
  endfunction

endclass

