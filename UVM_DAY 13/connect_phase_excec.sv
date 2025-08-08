`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//  UNDERSTANDING HOW CONNECT PHASE WORKS IN MULTIPLE                                 COMPONENTS
//---------------------------------------------------------
// let's see in driver class
//---------------------------------------------------------
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  
  function new(input string path = "driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  // connect phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  `uvm_info("driver", "Driver Connect Phase Excecuted", UVM_NONE);
  endfunction
endclass


//-------------------------------------------------------
// let's see in monitor class
//--------------------------------------------------------
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  
  function new(input string path = "monitor", uvm_component parent = null);
    super.new(path,parent);
  endfunction

// connect phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  `uvm_info("monitor", "Monitor Connect Phase Excecuted", UVM_NONE);
  endfunction
  
endclass

//-------------------------------------------------------
// let's see in env class
//--------------------------------------------------------
class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver drv;
  monitor mon;
  
  function new(input string path = "env", uvm_component parent = null);
    super.new(path,parent);
  endfunction

// connect phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
  endfunction
  
  // connect phase
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   `uvm_info("env", "Environment Connect Phase Excecuted",  UVM_NONE);
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

// build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
  endfunction
  
  // connect phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  `uvm_info("test", "Test Connect Phase Excecuted", UVM_NONE);
  endfunction
endclass

//---------------------------------------------------------
//                     TB TOP
//---------------------------------------------------------

module tb;
  initial begin
    run_test("test");  
    // connect phase excecutes in BOTTOM-UP APPROACH
    // eligible for rest of the phases in uvm 
    // all of them work in bottom up approach except build phase(top down)
  end
  
endmodule
