`include "uvm_macros.svh"
import uvm_pkg ::*;

//--------------------------------------------------------
//                 PHASE DEBUG & OBJECTION DEBUG
//--------------------------------------------------------
// COMMAND -->  +UVM_PHASE_TRACE
// COMMAND -->  +UVM_OBJECTION_TRACE

// automatically debug the phase and objection

class comp extends uvm_component;
  `uvm_component_utils(comp)
  
  function new(string path = "comp", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("comp", "Reset Started", UVM_NONE);
    #100;
    `uvm_info("comp", "Reset Completed", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("mon", "Random Stimulus Applied", UVM_NONE);
    #500;
    `uvm_info("mon", "Random Stimulus Removed", UVM_NONE); 
    phase.drop_objection(this);
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
