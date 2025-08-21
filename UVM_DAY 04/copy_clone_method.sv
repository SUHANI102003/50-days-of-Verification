`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------------------------------
//            COPY AND CLONE CORE METHODS
//--------------------------------------------------------
// We've already explored print() in field macros

// copy - just a copy; add a constructor before copying data into target object

// clone - copy + create ; do not need to add constructor

///////////////////////////////////////////////////////////
//                    COPY METHOD                        //
///////////////////////////////////////////////////////////
/*
class first extends uvm_object;
  
  rand bit [3:0] data;
  
  function new(string path = "first");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

module tb;
  first f;
  first s; // copy handler
 
  initial begin
    f = new("first");  
    s = new("second");  // constructor to s
    f.randomize();
    s.copy(f);   // copy method -- added a constructor prior to copy method
    f.print();
    s.print();
    
  end
endmodule
*/

///////////////////////////////////////////////////////////
//                    CLONE METHOD                       //
///////////////////////////////////////////////////////////

class first extends uvm_object;
  
  rand bit [3:0] data;
  
  function new(string path = "first");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

module tb;
  first f;
  first s;
  // DO NOT NEED TO ADD CONSTRUCTOR to copy object i.e s
  
  initial begin
  f = new("first");
  f.randomize();
  
//  s = f.clone();  // error  
  //incompatible type  // clone() returns the handle of parent class (UVM Object); whereas s is of child type(derived class)  // cannot assign parent handle to child handle; illegal
  
  
  // To resolve , we use cast method
  $cast(s, f.clone()); // this will return the correct type
  f.print();
  s.print();
  end
endmodule
