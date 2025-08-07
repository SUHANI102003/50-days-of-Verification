`include "uvm_macros.svh"
import uvm_pkg::*;

////////////////////// OVERVIEW

// simplest way to check the type of copy method implemented by copy() is to create an instance of a class and analyze the handle that we get.

// if we get independent handle for both the original and copied class - deep copy

//if we get single handle for both the original and copied class - shallow copy

//--------------------------------------------------------
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

/////////////////////////////////////////////

class second extends uvm_object;
  first f;
  
  function new(string path = "first");
    super.new(path);
    f = new("first");
  endfunction
  
  `uvm_object_utils_begin(second)
  `uvm_field_object(f, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

////////////////////////////////////////////////

module tb;
  
  second s1, s2;  //// shallow copy
  
  initial begin
    s1 = new("s1");
    s2 = new("s2");
    
    s1.f.randomize();
    s1.print();
    
    s2 = s1;
    s2.print();
    
    // lets modify the data
    s2.f.data = 12;
    s1.print();  // 'hc
    s2.print();  // 'hc
    // therefore, we have a single handle for class across both instances
    // change reflected in both --> shallow copy
  end
endmodule

*/


/////////////////////////////////////////////////////////
// lets see how it works with copy and clone
//////////////////////////////////////////////////////////


class first extends uvm_object;
  
  rand bit [3:0] data;
  
  function new(string path = "first");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

/////////////////////////////////////////////

class second extends uvm_object;
  first f;
  
  function new(string path = "first");
    super.new(path);
    f = new("first");
  endfunction
  
  `uvm_object_utils_begin(second)
  `uvm_field_object(f, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

////////////////////////////////////////////////
/*
module tb;
  
  second s1, s2;  
  
  initial begin
    s1 = new("s1");
    s2 = new("s2");
    
    s1.f.randomize();
    
    s2.copy(s1);
    s1.print();  // 2 
    s2.print();  // 2
    
    // modify data
    s2.f.data = 12;
    s1.print();   // h2
    s2.print();   // hc 
    // change not reflected in original --> DEEP COPY
  end
endmodule
*/

// CONCLUSION-- COPY METHOD --> DEEP COPY
///////////////////////////////////////////////////////////


// LETS SEE FOR CLONE
// we know that clone = copy + create , so we THINK THAT IT IS DEEP COPY "BUT LET'S SEE"

module tb;
  
  second s1, s2;  
  
  initial begin
    s1 = new("s1");
 //   s2 = new("s2");
    
    s1.f.randomize();
    
 //   s2.copy(s1);
    $cast(s2, s1.clone());
    
    s1.print();  // 2 
    s2.print();  // 2
    
    // modify data
    s2.f.data = 12;
    s1.print();   // h2
    s2.print();   // hc 
    // change not reflected in original --> DEEP COPY
  end
endmodule

// CONCLUSION-- CLONE METHOD --> DEEP COPY
