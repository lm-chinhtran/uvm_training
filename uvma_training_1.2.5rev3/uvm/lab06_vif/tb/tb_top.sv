/*-----------------------------------------------------------------
File name     : tb_top.sv
Description   : lab01_data tb_top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
  // import the UVM library
  import uvm_pkg::*;
  // include the UVM macros
  `include "uvm_macros.svh"

  // import the YAPP package
  import yapp_pkg::*;

  // include the test env
  `include "router_tb.sv"
  `include "router_test_lib.sv"

  yapp_packet yp;
  yapp_packet copy_yp;
  yapp_packet clone_yp;

  initial begin
    yapp_vif_config::set(null, "*.tb.yp_tx_uvc.yp_tx_agt.*", "vif", hw_top.in0);
    run_test();
  end
endmodule : tb_top
