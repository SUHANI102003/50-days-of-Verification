`include "uvm_macros.svh"
import uvm_pkg::*;
//---------------------------------------------------------
//                  FIELD MACROS 1 
//---------------------------------------------------------
// 1. `uvm_field_int
// 2. `uvm_field_object
// 3. `uvm_field_string
// 4. `uvm_field_enum
// 5. `uvm_field_real
// 6. `uvm_field_event
//---------------------------------------------------------
// adding automation to data members

// We could also say "adding Field macros to data members" instead of "Registering data members to factory"

// we will be simply referring it as registering data members to factory till we discuss most fundamentals

//-----------------------------------------------------
//        FINAL CODE (EXPLANATION BELOW)
//-----------------------------------------------------
//          example of `uvm_field_int
//-----------------------------------------------------
/*
class obj extends uvm_object;
  
  rand bit [3:0] a;
  
  function new(string path = "OBJ");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(obj)
  `uvm_field_int(a, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

module tb;
  obj o;
  
  initial begin
    o = new("obj");
    o.randomize();
    
    o.print();  
  end
endmodule
*/

////-----------------------------------------------------
//   EXPLANATION
///------------------------------------------------------

class obj extends uvm_object;
  
//  `uvm_object_utils(obj)   
// not required while registering variable to factory
// you won't be getting any error if you write it and comment the begin end - but won't see the output variable 
  
  rand bit [3:0] a;
  rand bit [7:0] b;
  
  function new(string path = "OBJ");
    super.new(path);
  endfunction
  
  // macros are called between begin and end of uvm utils (mandatory - remember)
  // not run-time efficient (we'll use 'do' methods later)
  
  `uvm_object_utils_begin(obj)
  `uvm_field_int(a, UVM_DEFAULT);   // default type is hex // UVM_DEFAULT = use default flag settings
  
  // lets explore - UVM_NOPRINT // not allows us to print value of b as flag is noprint
  `uvm_field_int(b, UVM_NOPRINT | UVM_BIN); 
  
//  `uvm_field_int(a, UVM_DEFAULT | UVM_DEC); // decimal format
  `uvm_object_utils_end
  
  
  // explore the other flags yourself
endclass

module tb;
  obj o;
  
  initial begin
    o = new("obj");
    o.randomize();
    
    o.print(); 
    
// print() method only accessible when you register your variable to factory by utilizing field macro
    
// will print in a table format (default - uvm_table_printer)
    
    
// if we want to change how data appears on console - use uvm_printer
    
   // o.print(uvm_default_tree_printer); // tree format
   // o.print(uvm_default_line_printer);   // line format
  end
endmodule
