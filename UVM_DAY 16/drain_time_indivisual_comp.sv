`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//                       DRAIN TIME
//---------------------------------------------------------
// time taken by dut to process the stimulus applied to it is handled by drain time
// drain time allows a buffer of time before proceding to next phase

class comp extends uvm_component;
  `uvm_component_utils(comp)
  
  function new(string path = "comp", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("comp", "Reset Started", UVM_NONE);
    #10;
    `uvm_info("comp", "Reset Completed", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
  
  task main_phase(uvm_phase phase);
    phase.phase_done.set_drain_time(this,200); // drain time
    // we'll stay in main phase for further 200ns
    
    phase.raise_objection(this);
    `uvm_info("mon", "Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("mon", "Main Phase Ended", UVM_NONE); // 310ns
    phase.drop_objection(this);
  endtask
  
  
  task post_main_phase(uvm_phase phase);
    `uvm_info("mon", "Post Main Phase Started", UVM_NONE);
  endtask
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  
endclass

/////////////////////////////////////////////////
module tb;
  initial begin
     
    run_test("comp"); 
    end
endmodule

//--------------------------------------------------------------
/*
# KERNEL: UVM_INFO @ 0: reporter [RNTST] Running test comp...
# KERNEL: UVM_INFO /home/runner/testbench.sv(20) @ 0: uvm_test_top [comp] Reset Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(22) @ 10: uvm_test_top [comp] Reset Completed
# KERNEL: UVM_INFO /home/runner/testbench.sv(32) @ 10: uvm_test_top [mon] Main Phase Started
# KERNEL: UVM_INFO /home/runner/testbench.sv(34) @ 110: uvm_test_top [mon] Main Phase Ended
# KERNEL: UVM_INFO /home/runner/testbench.sv(40) @ 310: uvm_test_top [mon] Post Main Phase Started
*/
