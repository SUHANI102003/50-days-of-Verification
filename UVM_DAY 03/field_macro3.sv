`include "uvm_macros.svh"
import uvm_pkg::*;
//---------------------------------------------------------------------
//                          FIELD MACROS 3
//---------------------------------------------------------------------
// 1. `uvm_field_int
// 2. `uvm_field_object
// 3. `uvm_field_string
// 4. `uvm_field_enum
// 5. `uvm_field_real
// 6. `uvm_field_event
//--------------------------------------------------------------------
// FLAG = UVM_DEFAULT, UVM_NOPRINT, UVM_NOCOPY, UVM_NOCOMPARE, etc
//--------------------------------------------------------------------
//               FINAL CODE (EXPLANATION BELOW)
// ex. of how to use macro for an instance of class `uvm_field_object
//--------------------------------------------------------------------

class parent  extends uvm_object;
  // `uvm_object_utils(parent)
  
  function new(string path = "parent");
    super.new(path);
  endfunction
  
  rand bit [3:0] data;
  
  // ADDING MACROS
  `uvm_object_utils_begin(parent)
  `uvm_field_int(data, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

/////////////////////////////////////////////////////

class child extends uvm_object;
  
  parent p;
  
  function new(string path = "child");
    super.new(path);
    p = new("parent"); ///// build_phase + create /////later when we cover phases
  endfunction
  
   // ADDING MACROS
  `uvm_object_utils_begin(child)
  `uvm_field_object(p, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

///////////////////////////////////////////////////

module tb;
  child c;
  
  initial begin
    c = new("child");
    c.p.randomize();
    c.print(uvm_default_table_printer);
  end
endmodule
