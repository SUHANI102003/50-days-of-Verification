`include "uvm_macros.svh"
import uvm_pkg::*;

//---------------------------------------------------------
//                  do METHODS
//---------------------------------------------------------

// NOTE: 
//1. When you specify implementation (do methods) of core methods , it is not necessary to use field macros.
//2. But registering class to factory is mandatory to get capabilities of factory override
// 3. if we plan to use inbuilt implementation of the core methods then registering class to factory as well as adding field macros to data members is mandatory

//---------------------------------------------------------
// do_print method
//---------------------------------------------------------
/*
class obj extends uvm_object;
  `uvm_object_utils(obj)  // mandatory
  
  function new(string path = "OBJ");
    super.new(path);
  endfunction
  
  bit [3:0] a = 4;
  string b = "UVM";
  real c = 12.34;
  
  // this should be EXACTLY SAME as in library
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    
    printer.print_field_int("a", a, $bits(a), UVM_HEX);  // $bits = returns no. of bits
    printer.print_string("b", b);
    printer.print_real("c", c);
    
  endfunction
endclass


  module tb;
    obj o;
    
    initial begin
      o = obj::type_id::create("o");
      o.print(); // use this to call do_print only
    end
  endmodule
  */

//---------------------------------------------------------

//to display all the values of data members in a single line 
//---------------------------------------------------------
//               convert2string() method
//---------------------------------------------------------
// no need to use uvm_printer
/*
class obj extends uvm_object;
  `uvm_object_utils(obj)  // mandatory
  
  function new(string path = "OBJ");
    super.new(path);
  endfunction
  
  bit [3:0] a = 4;
  string b = "UVM";
  real c = 12.34;
  
  // this should be EXACTLY SAME as in library
  
  virtual function string convert2string();
    
    string s = super.convert2string();
    
    s = {s, $sformatf("a : %0d ", a)};
    s = {s, $sformatf("b : %0s ", b)};
    s = {s, $sformatf("c : %0f ", c)};
    
    return s;
    
  endfunction
endclass


  module tb;
    obj o;
    
    initial begin
      o = obj::type_id::create("o");
      
      // can call $display or uvm_info
      
      //$display("%0s", o.convert2string());
      `uvm_info("TB_TOP", $sformatf("%0s : ", o.convert2string()), UVM_LOW);
    end
  endmodule
*/


//---------------------------------------------------------
//                  do_copy method
//---------------------------------------------------------
/*  
  class obj extends uvm_object;
  `uvm_object_utils(obj)  // mandatory
  
    function new(string path = "obj");
    super.new(path);
  endfunction
    
    rand bit [3:0] a;
    rand bit [4:0] b;
  
  
     // this should be EXACTLY SAME as in library
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("a :", a, $bits(a), UVM_DEC);  
    printer.print_field_int("b :", b, $bits(b), UVM_DEC);    
  endfunction
    
    
     // this should be EXACTLY SAME as in .svh file
    virtual function void do_copy(uvm_object rhs);
      obj temp;
      $cast(temp, rhs);  // mandatory
// makes sure both temp and rhs are of same type, i.e object
// also we get handle of rhs; now temp has access to data of rhs
      
      super.do_copy(rhs);
      
      this.a = temp.a;
      this.b = temp.b;
      
    endfunction
    
  endclass

module tb;
    obj o1, o2;
    
    initial begin
      o1 = obj::type_id::create("o1");
      o2 = obj::type_id::create("o2");
     
      // similar to field macro
      o1.randomize();
      o1.print();
      o2.copy(o1);
      o2.print();
     
    end
 endmodule
*/

//---------------------------------------------------------
//                  do_compare method
//---------------------------------------------------------
  
  class obj extends uvm_object;
  `uvm_object_utils(obj)  // mandatory
  
    function new(string path = "obj");
    super.new(path);
  endfunction
    
    rand bit [3:0] a;
    rand bit [4:0] b;
  
     // this should be EXACTLY SAME as in library
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("a :", a, $bits(a), UVM_DEC);  
    printer.print_field_int("b :", b, $bits(b), UVM_DEC);    
  endfunction
    
    
     // this should be EXACTLY SAME as in .svh file
    virtual function void do_copy(uvm_object rhs);
      obj temp;
      $cast(temp, rhs);     
      super.do_copy(rhs);     
      this.a = temp.a;
      this.b = temp.b;     
    endfunction
    
    
   // this should be EXACTLY SAME as in .svh file
    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      obj temp;
      int status;
      $cast(temp, rhs);
      status = super.do_compare(rhs, comparer) && (a == temp.a) && (b == temp.b);
      return status;
      
    endfunction
    
  endclass

module tb;
    obj o1, o2;
    int status;
  
    initial begin
      o1 = obj::type_id::create("o1");
      o2 = obj::type_id::create("o2");
     
      // similar to field macro
      o1.randomize();
      o1.print();
      o2.print();
      
   //   o2.copy(o1);
      
      status = o2.compare(o1);
      $display("Status : %0d", status);
     
    end
 endmodule

