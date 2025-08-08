`include "uvm_macros.svh"
import uvm_pkg ::*;


// phases are alllowed only in uvm_component so any class derived from uvm_component can use them

//--------------------------------------------------------
//////////////////  TEST CLASS
//---------------------------------------------------------

class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction

/////////////////// Construction phases (4 categories)
// (do not consume time; hence need to override function)
  
  
// build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("test", "Build Phase Excecuted", UVM_NONE);
  endfunction
  
// connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("test", "Connect Phase Excecuted", UVM_NONE);
  endfunction
  
// end of elaboration phase
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("test", "End of Elaboration Phase Excecuted", UVM_NONE);
  endfunction  
  
// start of simulation phase
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("test", "Start of Simulation Phase Excecuted", UVM_NONE);
  endfunction  

  
///////////////////////// Run phases 
  // (consume time; hence need to override task)  
  // can call run_phase or any of its 4 categories
  // all the 4 categories of run phase will excecute together if we simply call run_phase
  
  task run_phase(uvm_phase phase);
    `uvm_info("test", "Run Phase", UVM_NONE);
  endtask
  
  
/////////////////////////  Cleanup phases (4 categories)
// (do not consume time; hence need to override function)
  
// extract phase
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("test", "Extract Phase", UVM_NONE);
  endfunction
  
// check phase
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info("test", "Check Phase", UVM_NONE);
  endfunction
  
// Report phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("test", "Report Phase", UVM_NONE);
  endfunction
  
// Final phase
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("test", "Final Phase", UVM_NONE);
  endfunction
 
  
  
endclass



module tb;
  initial begin
    run_test("test");
  end
endmodule

// all excecuted seqentially ; at 0ns

/*
Phases excecution - 2 ways

1. TOP-DOWN APPROACH
   TEST -> ENV -> SCO/AGENT -> DRV/MON/SEQ
   
In this , phase of parent is excecuted first , followed by child phase

NOTE: ONLY BUILD_PHASE WORKS IN TOP-DOWN FASHION

2. BOTTOM-UP APPROACH
   DRV/MON/SEQ -> AGENT -> ENV -> TEST
   
In this , phase of LEAF/child is excecuted first , followed by ROOT/parent phase  
*/
