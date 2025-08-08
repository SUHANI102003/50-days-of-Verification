`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------------------------------
//                  UVM TREES
//---------------------------------------------------------
// we'll take a simple example to see hoe to build hierarchy

// uvm_root --->  c  (sub tree)
// c has 2 components  --> 1. a (leaf)
//                         2. b (leaf)


// parent of UVM_TOP = UVM_NULL

// for c ; uvm_root is parent
// for a and b ; c is parent

// this will form our base or give idea on how to create our own verification tree


//---------------------------------------------------------
// start by building child component CLASS A
//---------------------------------------------------------

class a extends uvm_component;
  `uvm_component_utils(a)
  
  function new(string path = "a", uvm_component parent = null);
    super.new(path,parent); 
  endfunction
  
//excecuted prior to main simulation time; useful to create instance of an object; does not consume sim time
  
// using build_phase to send data to console, which we usually do in run_phase
  
// since we've not discussed it yet , we'll keep it simle to understand trees
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("a", "Class a excecuted", UVM_NONE);
  endfunction
  
endclass

//---------------------------------------------------------
//  building child component CLASS B
//---------------------------------------------------------

class b extends uvm_component;
  `uvm_component_utils(b)
  
  function new(string path = "b", uvm_component parent = null);
    super.new(path,parent); 
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("b", "Class b excecuted", UVM_NONE);
  endfunction
  
endclass

//---------------------------------------------------------
// building subtree c (parent of a and b class)
//---------------------------------------------------------

class c extends uvm_component;
  `uvm_component_utils(c)
  
  a a_inst;  // handler for a
  b b_inst;  // handler for b
  
  function new(string path = "c", uvm_component parent = null);
    super.new(path,parent); 
  endfunction
  
  
  // using build_phase to create objects of a and b
  // here we use this keywork instead of null 
  // this indicates that c is the parent of a and b
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a_inst = a::type_id::create("a_inst", this);
    b_inst = b::type_id::create("b_inst", this);
    //     a_inst.build_phase(null); // do not use this
    //     b_inst.build_phase(null); // do not use this
  endfunction
  
  
  // To observe hierarchy - use help of end of elaboration phase
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass


//---------------------------------------------------------
// building tb top (recommended method) - to use run_test
//---------------------------------------------------------

module tb;
  
  initial begin
    run_test("c");
  end
  
endmodule

//---------------------------------------------------------
// building tb top (alternative method) - manually specify that class c is the child of uvm_top (test top)

// not preferred in uvm
/// wil see a series of warnings if you do it this way
//---------------------------------------------------------
/*
module tb;
  c c_inst;
  
  initial begin
    c_inst = c::type_id::create("c_inst", null);
    // null - as this indicates c is child of uvm_top
    
    // REMEMBER-- null -> to declare child of uvm_top
    //            this -> to declare parent of class
    
    c_inst.build_phase(null); // also call build phase of a and b in c class; only then will see output
  end
endmodule
*/
// code excecuted but series of warning
