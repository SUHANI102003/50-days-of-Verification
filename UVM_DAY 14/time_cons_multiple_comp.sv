`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
// HOW TIME CONSUMING PHASES WORK IN MULTIPLE COMPONENTS   
//---------------------------------------------------------


class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  
  function new(input string path = "driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("drv", "Driver Reset Started", UVM_NONE);
    #100;
    `uvm_info("drv", "Driver Reset Completed", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("drv", "Driver Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("drv", "Driver Main Phase Ended", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
endclass


//-------------------------------------------------------
//  monitor class
//--------------------------------------------------------
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  
  function new(input string path = "monitor", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("mon", "Monitor Reset Started", UVM_NONE);
    #300;
    `uvm_info("mon", "Monitor Reset Completed", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("mon", "Monitor Main Phase Started", UVM_NONE);
    #400;
    `uvm_info("mon", "Monitor Main Phase Ended", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
endclass

//-------------------------------------------------------
//  env class
//--------------------------------------------------------
class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver drv;
  monitor mon;
  
  function new(input string path = "env", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
  endfunction
  
endclass


//-------------------------------------------------------
// let's see in test class
//--------------------------------------------------------
class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    
  endfunction
  
endclass

//---------------------------------------------------------
//                     TB TOP
//---------------------------------------------------------

module tb;
  initial begin
    run_test("test");  
  end
  
endmodule

// OBSERVE THE TIMINGS AT WHICH THE TASKS GET COMPLETED TO UNDERSTAND

//--------------------------------------------------------------
// OUTPUT
//--------------------------------------------------------------
/*
# KERNEL: UVM_INFO @ 0: reporter [RNTST] Running test test...
# KERNEL: UVM_INFO /home/runner/testbench.sv(50) @ 0: uvm_test_top.e.mon [mon] Monitor Reset Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(19) @ 0: uvm_test_top.e.drv [drv] Driver Reset Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(21) @ 100: uvm_test_top.e.drv [drv] Driver Reset Completed
# KERNEL: UVM_INFO /home/runner/testbench.sv(52) @ 300: uvm_test_top.e.mon [mon] Monitor Reset Completed
# KERNEL: UVM_INFO /home/runner/testbench.sv(59) @ 300: uvm_test_top.e.mon [mon] Monitor Main Phase Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(28) @ 300: uvm_test_top.e.drv [drv] Driver Main Phase Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(30) @ 400: uvm_test_top.e.drv [drv] Driver Main Phase Ended
# KERNEL: UVM_INFO /home/runner/testbench.sv(61) @ 700: uvm_test_top.e.mon [mon] Monitor Main Phase Ended
# KERNEL: UVM_INFO /home/build/vlib1/vlib/uvm-1.2/src/base/uvm_report_server.svh(869) @ 700: reporter [UVM/REPORT/SERVER] 
*/
