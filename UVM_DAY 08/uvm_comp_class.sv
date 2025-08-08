`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------------------------------
//                    UVM COMPONENTS
//      STATIC COMPONENTS - STAY DURING ENTIRE SIMULATION 
//---------------------------------------------------------
// EX. driver, monitor, env, scoreboard, etc

// 1. extending UVM_COMPONENT
// 2. UVM_TREE
// 3. Accessing path of the hierarchy

//---------------------------------------------------------
//          CREATING UVM_COMPONENT CLASS
//          (by extending uvm_component)
//---------------------------------------------------------
//         FINAL CODE (explanation below)
//---------------------------------------------------------

class comp extends uvm_component;

  `uvm_component_utils(comp)

  function new(string path = "comp", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("COMP", "Build phase of comp excecuted", UVM_NONE);
  endfunction
  
endclass
///////////////////////////////////////////////////
module tb;
  
  initial begin
    run_test("comp");  
  end
endmodule


//------------------------------------------------------
//                 EXPLANATION
//-------------------------------------------------------
/*
class comp extends uvm_component;
  
// register class to factory
// uvm objects --> we get core methods
// uvm component --> we get factory override methods + config DB (used to share parameters among verification platform)
  
  `uvm_component_utils(comp)

  function new(string path = "comp", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  // when we consider uvm components , we need to work on PHASES.
  // our entire simulation time is divided into phases, phases before and after simulation
  
  // phases - mean for ex. if you want to reset your system you have a specific phase that will perform that operation
  
  // similarly, if you want to configure your env or create an instance of object, you get specific phases.
  
  // as we have not yet discussed phases in detail , we'll be utilizing only some basic phases 
  
  
  //             BUILD_PHASE
  // excecuted prior to main simulation time; useful to create instance of an object
  
  // Follow this skeleton Strictly 
  //this is eligible for all phases where you have skeleton consisting of a function
  
  // run phase is built up by utilizing a task; do not need to specify super there
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("COMP", "Build phase of comp excecuted", UVM_NONE);
  endfunction
  
endclass

module tb;
  
  initial begin
    run_test("comp");  // will automatically excecute the code of comp class; power of uvm
  end
endmodule


// WE HAVE NOT ADDED THE HANDLER FOR COMP CLASS, NOT ADDED CONSTRUCTOR FOR INSTANCE CREATION;
//THE FACTORY DOES THIS AUTOMATICALLY FOR US.

// IT WILL AUTOMATICALLY EXCECUTE THE COMPONENT WHOSE NAME IS SPECIFIED IN RUN_TEST() -- ADVANTAGE OF UVM

//IN A REAL TB ENVIRONMENT, WE'LL BE HAVING TEST AS TOPMOST COMPONENT, SO WE'LL JUST BE SPECIFYING NAME OF TEST CLASS;
//AND THIS WILL AUTOMATICALLY BUILD HIERARCHY OF ALL COMPONENTS AND START EXCECUTING CLASSES.
*/


//-------------------------------------------------------
//--------------------------------------------------------
// WE CAN ALSO DO THIS; use SV method

module tb;
	comp c;
    initial begin
    c = comp::type_id::create("c",null );
    
    // null indicates that comp is child of uvm_top
    // in real tb env, we only have a single child to uvm top; how to specify what child? - just add parent as null
    
    c.build_phase(null);
    
    // note - you wont be utilizing null in real tb environment; but for understanding purposes we have used it here
  end
    
endmodule

//1. will give a warning-- build_phase has been explicitly called; we never do that ; 
//2.we usually call a run_test() as this allows factory to automatically call the phases in line

// 3. will still excecute the code and see the output message


// LETS START BUILDING A TREE NOW

