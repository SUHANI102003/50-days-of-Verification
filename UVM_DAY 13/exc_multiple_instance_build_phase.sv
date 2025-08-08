`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//      EXCECUTION OF MULTIPLE INSTANCE PHASES
//---------------------------------------------------------
// when we have multiple objects present in build_phase, which object will build phase give priority???
//---------------------------------------------------------
// let's see in driver class
//---------------------------------------------------------
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  
  function new(input string path = "driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction

// build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("driver", "Driver Build Phase Excecuted", UVM_NONE);
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

// build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("monitor", "Monitor Build Phase Excecuted", UVM_NONE);
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

// build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("env", "Environment Build Phase Excecuted", UVM_NONE);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
 // which build phase will get priority???? drv or mon ????
 // the rule will remain for all other phases too
  endfunction
  
endclass

///// order for priority of phases-> similar to--->
// lexicographic order (ASCII value) 
// lower decimal value will get higher priority as compared to characters with higher dec value

// if we are simply using lowercase alphabets--> simply follow the alphabetical order
// ex . a > b
// ex . drv > mon as d > m


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
    `uvm_info("test", "Test Build Phase Excecuted", UVM_NONE);
    e = env::type_id::create("e", this);
    
  endfunction
  
endclass

//---------------------------------------------------------
//                     TB TOP
//---------------------------------------------------------

module tb;
  initial begin
    run_test("test");  
    // build phase excecutes in TOP - DOWN APPROACH
  end
  
endmodule
