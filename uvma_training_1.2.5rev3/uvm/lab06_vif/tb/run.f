/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
-timescale 1ns/1ns

// 64 bit option for AWS labs
-64

 -uvmhome $UVMHOME

// include directories
//*** add incdir include directories here
-incdir ../sv // include directory for sv files
-incdir ../../router_rtl // include directory for sv files

// compile files
//*** add compile files here
../sv/yapp_pkg.sv // compile YAPP package
../sv/yapp_if.sv
../../router_rtl/yapp_router.sv
hw_top.sv
tb_top.sv // compile top level module
clkgen.sv

+UVM_TESTNAME=send_to_dut_test
+UVM_VERBOSITY=UVM_FULL
+SVSEED=random
