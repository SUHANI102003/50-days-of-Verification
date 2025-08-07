`include "uvm_macros.svh"
import uvm_pkg::*;
//---------------------------------------------------------------------
//                  FIELD MACROS 2 
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
//        FINAL CODE (EXPLANATION BELOW)
//        ex. of enum, real and string
//--------------------------------------------------------------------

class obj extends uvm_object;
  
  typedef enum bit [1:0] {s0, s1, s2, s3} state_type;
  rand state_type state;
  
  real temp = 12.34;
  string str = "UVM";
  
  function new(string path = "obj");
    super.new(path);
  endfunction
  
  // ADDING MACROS
  `uvm_object_utils_begin(obj)
  
  `uvm_field_enum(state_type, state, UVM_DEFAULT);
  `uvm_field_real(temp, UVM_DEFAULT);
  `uvm_field_string(str, UVM_DEFAULT);
  
  `uvm_object_utils_end
  
endclass

module tb;
  obj o;
  
  initial begin
    o = new("OBJ");
    o.randomize();
    o.print(uvm_default_table_printer);
  end
endmodule
