`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
// HOW TIME CONSUMING PHASES WORK IN SINGLE COMPONENT        
//---------------------------------------------------------
//  NOW LET'S START OBSERVING PHASES THAT CONSUME TIME
// (we've already discussed non time consuming on day13)
//---------------------------------------------------------

class comp extends uvm_component;
  `uvm_component_utils(comp)
  
  function new(string path = "comp", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  //// run_phase (4 categories)
  
  ///////////// 1. reset phase
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("comp", "Reset Started", UVM_NONE);
    #10;
    `uvm_info("comp", "Reset Completed", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
  ///////////// 2. main phase
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("mon", "Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("mon", "Main Phase Ended", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
endclass

/////////////////////////////////////////////////
module tb;
  initial begin
    run_test("comp"); 
    end
endmodule

 // reset, main, configure, shutdown all work sequentially 
// until reset is completed, main won't start

//--------------------------------------------------------
/*
# KERNEL: UVM_INFO @ 0: reporter [RNTST] Running test comp...
# KERNEL: UVM_INFO /home/runner/testbench.sv(23) @ 0: uvm_test_top [comp] Reset Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(25) @ 10: uvm_test_top [comp] Reset Completed
# KERNEL: UVM_INFO /home/runner/testbench.sv(32) @ 10: uvm_test_top [mon] Main Phase Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(34) @ 110: uvm_test_top [mon] Main Phase Ended
# KERNEL: UVM_INFO /home/build/vlib1/vlib/uvm-1.2/src/base/uvm_report_server.svh(869) @ 110: reporter [UVM/REPORT/SERVER] 
*/
