//---------------------------------------------------------
// VERBOSITY LEVELS AND Function for ID
//---------------------------------------------------------

`include "uvm_macros.svh"
import uvm_pkg ::*;

//--------------------------------------------------------
/*
// we usually extend a UVM_driver to create a driver class
// this contains basic methods required for uvm driver

class driver extends uvm_driver;
  `uvm_component_utils(driver)  // we register our class to a factory(will understand later)
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("DRV1", "Excecuted Driver1 code", UVM_HIGH);
    `uvm_info("DRV2", "Excecuted Driver2 code", UVM_HIGH);
  endtask
  
endclass

module tb;
  driver drv;
  
  initial begin
  drv = new("DRV", null);
    drv.set_report_id_verbosity("DRV1", UVM_HIGH); // change verbosity for specific id; so drv1 will be printed
    drv.run();
  end
endmodule
*/

//--------------------------------------------------------
//--------------------------------------------------------
// WORKING WITH INDIVISUAL COMPONENT
//--------------------------------------------------------
// let us assume we have multiple classes in our component,
// if you want to change verbosity of indivisual component

/*
class driver extends uvm_driver;
  `uvm_component_utils(driver)  
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("DRV1", "Excecuted Driver1 code", UVM_HIGH);
    `uvm_info("DRV2", "Excecuted Driver2 code", UVM_HIGH);
  endtask
  
endclass
////////////////////////////////////

class env extends uvm_env;
  `uvm_component_utils(env) // register our class to factory
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("ENV", "Excecuted ENV1 code", UVM_HIGH);
    `uvm_info("ENV2", "Excecuted ENV2 code", UVM_HIGH);
  endtask
  
endclass

/////////////////////////////////////
module tb;
  driver drv;
  env e;
  
  initial begin
  drv = new("DRV", null);
    e = new("ENV", null);
    
    //e.set_report_verbosity_level(UVM_HIGH); // BOTH ENV PRINTED
    //OR
    // go to run options and write +access+r +UVM_VERBOSITY=UVM_HIGH 
    
    // then both drv and env will be printed
    drv.run();
    e.run();
  end
endmodule
*/

//---------------------------------------------------------
//                 WORKING WITH HIERARCHY
//---------------------------------------------------------

class driver extends uvm_driver;
  `uvm_component_utils(driver)  
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("DRV", "Excecuted Driver code", UVM_HIGH);
  endtask
  
endclass


class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)  
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    `uvm_info("MON", "Excecuted Monitor code", UVM_HIGH);
  endtask
endclass


class env extends uvm_env;
  `uvm_component_utils(env) 
  
  driver drv;
  monitor mon;
  
  function new(string path, uvm_component parent);
    super.new(path,parent);
  endfunction
  
  task run();
    drv = new("DRV",this);
    mon = new("MON",this);
    drv.run();
    mon.run();
  endtask
  
endclass


module tb;
  
  env e;
  
  initial begin
  
    e = new("ENV", null);
    
    e.set_report_verbosity_level_hier(UVM_HIGH);  // will set for all classes 
    e.run();
  end
endmodule
