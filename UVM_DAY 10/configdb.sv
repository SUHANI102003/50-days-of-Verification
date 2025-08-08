`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//                   CONFIG_DB
//---------------------------------------------------------
// sharing resources between classes in uvm

// we use get and set method

// we won't be considering real verification env here, instead we'll try to share simple data b/w classes

//---------------------------------------------------------
// uvm_env is a class present in uvm library for building environment. we just need to extend it
//---------------------------------------------------------

class env extends uvm_env;
// register class to factory
// uvm_env is a sstatic component build using uvm_component hence the macro for factory registration is- 
  
  `uvm_component_utils(env)
  
  int data;
  
  // constructor
  function new(string path = "env", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  
  // get data value from test
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

// utilizing if because when my data access is unsuccessfull, in that case, we could throw an error   
 
// UVM gives us a special ability with config_db which is different from normal behaviour of UVM_ERROR, if our block fails UVM_ERROR stops simulation behaving like UVM_FATAL   
    
// get method -> use same context + instance name as set method
    if(uvm_config_db#(int)::get(null, "uvm_test_top", "data", data))
      `uvm_info("ENV", $sformatf("Value of data : %0d", data), UVM_NONE)
    
    else
      `uvm_error("ENV", "Unable to access the value");
    
  endfunction
  
endclass

//--------------------------------------------------------
//- TEST CLASS - extend uvm_test(in library)
//--------------------------------------------------------
class test extends uvm_test;

  `uvm_component_utils(test)
  
  env e;  // handler for env
  
  // constructor
  function new(string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    e = env::type_id::create("e", this); 
// test class became parent for our env
// this refers to class in which we are creating instance.
// here, env instance is added in TEST , hence 'this' will refer TEST
    
    // setting data value
    uvm_config_db#(int)::set(null, "uvm_test_top", "data", 12); 
    //// set has 4 arguments
    ///// context + instance name + key + value
    
    ///// context can have 2 values-->
    ///// 1. null -> refers to UVM_ROOT; when we add null in context every component in tb environment can access a value. (explore later)
    ///// 2. this -> when you want to restrict access to a specific class only
    
    // after setting -> env needs to access the data to update the value -> go to env class build phase now
  endfunction
  

endclass

//--------------------------------------------------------
//- TEST TOP 
//--------------------------------------------------------

module tb;
  initial begin
    run_test("test");
  end
endmodule
