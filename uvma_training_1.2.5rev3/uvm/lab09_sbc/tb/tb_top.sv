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

  // import the YAPP UVC package
  import yapp_pkg::*;

  // import the HBUS UVC package
  import hbus_pkg::*;

  // import the Channel UVC package
  import channel_pkg::*;

  // import the clock and reset UVC package
  import clock_and_reset_pkg::*;

  // import router module UVC package
  import router_module_pkg::*;

  // include the test env
  `include "router_mcsequencer.sv"
  `include "router_mcseqs_lib.sv"
  `include "router_scoreboard.sv"
  `include "router_tb.sv"
  `include "router_test_lib.sv"

  yapp_packet yp;
  yapp_packet copy_yp;
  yapp_packet clone_yp;

  initial begin
    yapp_vif_config::set(null, "*.tb.yp_tx_uvc.yp_tx_agt.*", "vif", hw_top.in0);
    hbus_vif_config::set(null, "*.tb.hbus_uvc.*", "vif", hw_top.hif);
    channel_vif_config::set(null, "*.tb.rx_uvc0.*", "vif", hw_top.ch0);
    channel_vif_config::set(null, "*.tb.rx_uvc1.*", "vif", hw_top.ch1);
    channel_vif_config::set(null, "*.tb.rx_uvc2.*", "vif", hw_top.ch2);
    clock_and_reset_vif_config::set(null, "*.tb.clk_rst_uvc.*", "vif", hw_top.clk_rst_if);
    run_test();
  end
endmodule : tb_top
