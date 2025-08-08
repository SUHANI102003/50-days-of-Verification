`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//                  RAISING OBJECTION
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
  ///////////// reset phase
  
//   task reset_phase(uvm_phase phase);
//     `uvm_info("comp", "Reset Started", UVM_NONE);
//     //#100; // will not work
//     //#10;  // will not work
//     `uvm_info("comp", "Reset Completed", UVM_NONE);    
//   endtask
  
  // correct way
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("comp", "Reset Started", UVM_NONE);
    #10;
    `uvm_info("comp", "Reset Completed", UVM_NONE); 
    phase.drop_objection(this);
  endtask
  
  
endclass

/////////////////////////////////////////////////
module tb;
  initial begin
    run_test("comp"); 
    end
endmodule

//------------------------------------------------------
// we will only see the output -- Reset started
// reset completed not displayed at output???? why??
// delay of 100 not working for us ; change it to 10
// still not displayed why????
    
// UVM will not automatically hold the simulator for the time you have mentioned in phases which could consume time
// UVM won't wait for 10 ns automatically for our task to complete
    
// to hold the time that you require for specific phase; need to use objection mechanism
// raise an objection that allows us to tell simulator to not exit before we complete our process
// after completion ; drop the objection
//------------------------------------------------------

//NOTE:  we use raise and drop objection in sequences; not in every component
  
