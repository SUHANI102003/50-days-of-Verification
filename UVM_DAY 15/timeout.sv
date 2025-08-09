`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//                     TIMEOUT
//---------------------------------------------------------
// timeout is simply the maximum absolute simulation time allowed before a FATAL occurs. 
// ex. if timeout is 20ns, then simulation must complete before 20ns, or fatal timeout will occur
//---------------------------------------------------------
// timeout --> property of uvm_top
//default = 9200 sec

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
    phase.raise_objection(this);
    `uvm_info("mon", "Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("mon", "Main Phase Ended", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  
endclass

/////////////////////////////////////////////////
module tb;
  initial begin
    
    uvm_top.set_timeout(200ns, 0); // 0 = no override by other components
    // default is 1 i,e override
    run_test("comp"); 
    end
endmodule

