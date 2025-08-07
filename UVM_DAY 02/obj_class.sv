`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//                 CREATING CLASSES
//---------------------------------------------------------
// a very simple class in system verilog to revise
//---------------------------------------------------------
// class first;
//   rand bit [3:0] data;
// endclass

// module tb;
//   first f;
  
//   initial begin
//     f = new();
//     f.randomize();
//     $display("Value of data : %0d", f.data);
//   end
// endmodule


///////////////////////////////////////////////////////////

//---------------------------------------------------------
///          DERIVING CLASS FROM UVM OBJECT
//---------------------------------------------------------

// BASE CLASS --> 2 types 
// 1. UVM OBJECT (DYNAMIC COMPONENTS - transaction)
// 2. UVM COMPONENT (STATIC COMPONENTS) - driver, mon, sco, agent, env, etc

// object class is used to implement all the Dynamic components of a testbench. ex. Transaction class

// we do not need to built a class from scratch as in SV, here in UVM, we extend the classes already present in UVM library

//--------------------------------------------------------
/*
//------------------------------------
// OBJECT CLASS ( explanation below) 
//------------------------------------
class obj extends uvm_object;
  `uvm_object_utils(obj)
  
  function new(string path = "OBJ");
    super.new(path);
  endfunction
   
  rand bit [3:0] a;
  
endclass
*/

//----------------------------------------
//           EXPLANATION
//---------------------------------------

class obj extends uvm_object;
  
// register a class to a factory (mandatory)
// its gives us ability to perform Factory Override
  
// also gives us the capability to add some methods 		   automatically - like data printing.
  
// for registering a class derived from uvm object, use- 
  `uvm_object_utils(obj)
  
// (we'll be adding automation for data members later)
  
// adding a constructor
// skeleton for constructor already present in base class
//since we're extending it, we just need to add required arguments
  function new(string path = "OBJ");
    super.new(path);
  endfunction
  // this constructor will remain same for all classes (DO NOT CHANGE THIS FORMAT) 
  // super will add a constructor to parent class also
  
  
  rand bit [3:0] a;
  
endclass

// we will not utilize the UVM standard test class method here , but will use simpler SV method

module tb;
  obj o;
  
  initial begin
    o = new("OBJ");
    o.randomize();
    `uvm_info("TB_TOP", $sformatf("a : %0d", o.a), UVM_NONE);
  end
endmodule

