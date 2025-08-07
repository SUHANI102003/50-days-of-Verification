`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------------------------------
//                  CREATE METHOD
//---------------------------------------------------------
// we use new() methos to create object
// in UVM recommended method to create object is create()
// This allows factory to override a type
// so, whenever you have modification, ex. in transaction class, you could easily merge the changes in an environment.

////////////////////////////////////////////////////////

class first extends uvm_object;
  
  rand bit [3:0] data;
  
  function new(string path = "first");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

/////////////////////////////////////////////////////////

module tb;
  first f1, f2;
  
  initial begin
    f1 = first::type_id::create("f1");
    f2 = first::type_id::create("f2");
    
    f1.randomize();
    f2.randomize();
    
    f1.print();
    f2.print();
    
  end
endmodule



