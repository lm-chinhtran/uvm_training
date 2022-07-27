/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
  // import the UVM library
  import uvm_pkg::*;
  // include the UVM macros
  `include "uvm_macros.svh"

  // import the YAPP package
  import yapp_pkg::*;

  yapp_packet yp;
  yapp_packet copy_yp;
  yapp_packet clone_yp;

  // generate 5 random packets and use the print method
  initial begin
    for (int i = 0; i < 5; i++) begin
      yp = new("yp");
      $display("\nPACKET %0d", i);
      assert(yp.randomize());
      // to display the results
      yp.print(uvm_default_tree_printer);
      yp.print(uvm_default_table_printer);
      yp.print(uvm_default_line_printer);
    end

    // experiment with the copy, clone and compare UVM method
    $display("\n COPY packet");
    copy_yp = new("copy_yp");
    copy_yp.copy(yp);
    copy_yp.print(uvm_default_table_printer);

    $display("\n CLONE packet");
    // clone_yp = new("clone_yp"); //no need to construct
    $cast(clone_yp, yp.clone());
    clone_yp.print(uvm_default_table_printer);
  end
endmodule : top
