`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------------------------------
//             new()  vs  create() METHOD
//---------------------------------------------------------

/////////////////////////////////////////////////////////
// we created our complete testbench env creation ; now i want to add a new control signal to my transaction class.

// Instead of changing the existing trans class, we extend the transaction class and add new signal to it

// our agenda is to replace all instances of the old transac class with new transac class that we have created just now

// This is where a factory helps

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

/////////////////////////////////////////////////

class first_mod extends first;
  rand bit ack; // acknowledgement signal
  
  function new(string path = "first_mod");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(first_mod)
  `uvm_field_int(ack, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass

//////////////////////////////////////////////////
// we know that to see the child class properties, we need to override the methods in parent class (done in sv by virtual method and polymorphism concept)

// Override method requires a UVM_component. We haven't discussed it yet, just go through the code and we'll discuss it on next section
///////////////////////////////////////////////////

class comp extends uvm_component;
  `uvm_component_utils(comp) 
// macro for registering class component to factory which extends uvm_component
  
  first f; // old trans class
  
  // format for uvm_component constructor(always follow this) - has 2 arguments
  // helpful for creating uvm tree
  
  function new(string path = "second", uvm_component parent = null);
    super.new(path,parent);
 // we do not add anything other than super; but to simplify things , we're adding constructor, randomize, and print
    f = first::type_id::create("f"); // constructor f
    f.randomize();
    f.print();
  endfunction
  
endclass

////////////////////////////////////////////////////////

// module tb;
//   comp c;
  
//   initial begin
//     c = comp::type_id::create("c", null); 
    
//  we'll be understanding null later (2nd argument has 2 options - null and this) .
//  when to use what we'll see; here we're using null
    
    
//      CONSTRAINTS TO USE FACTORY OVERRIDE METHODS->
//      ______________________________________________
//      1. create method for creating component
//      2. register our class(comp) to factory
    
//      STRICTLY FOLLOW THESE 2 CONSTRAINTS
        
//   end
// endmodule


//---------------------------------------------------------
//--------------------------------------------------------
// output--> 'h3 ; first class excecuted
  
  // we want to see ack signal of extended class
  // instead of replacing word "first" with "first_mod" everywhere in code, we will use FACTORY OVERRIDE
  
  // HOW TO DO??

//-------------------------------------------------------
//-------------------------------------------------------

module tb;
  comp c;
  
  initial begin
    
    // add this line 
    // 1st arg = old class
    // 2nd arg = new modified class
    
    c.set_type_override_by_type(first::get_type, first_mod::get_type);
    
    c = comp::type_id::create("c", null); 

  end 
endmodule

// output --> CAN SEE THE AWK SINGNAL ALONG WITH DATA SIGNAL

// advantage of registering class to factory & utilizing create method to create objects


//--------------------------------------------------------
//--------------------------------------------------------
// LET'S SEE WHAT HAPPENS IF WE DO NOT USE CREATE METHOD TO CREATE OBJECTS
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

/////////////////////////////////////////////////

class first_mod extends first;
  rand bit ack; // acknowledgement signal
  
  function new(string path = "first_mod");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(first_mod)
  `uvm_field_int(ack, UVM_DEFAULT);  
  `uvm_object_utils_end
  
endclass


class comp extends uvm_component;
  `uvm_component_utils(comp) 
 
  first f; 
  
  function new(string path = "second", uvm_component parent = null);
    super.new(path,parent);
    f = new("f");  // chage this
    f.randomize();
    f.print();
  endfunction
  
endclass
/////////////////////////////////////////////////////
module tb;
  comp c;
  
  initial begin    
    c.set_type_override_by_type(first::get_type, first_mod::get_type);
    
    c = new("c", null); // change this

  end 
endmodule

*/
// EVEN THOUGH WE HAVE OVERRIDEN WE STILL DO NOT SEE AWK SIGNAL; ONLY SEE OLD DATA MEMBER
