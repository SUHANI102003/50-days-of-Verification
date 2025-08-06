`include "uvm_macros.svh"
import uvm_pkg ::*;

//----------------------------------------------------------------------------------------------------------
//                                        OTHER REPORTING MACROS
//----------------------------------------------------------------------------------------------------------
/*
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent);
    super.new(path, parent);
  endfunction
  
  task run();
    `uvm_info("DRV", "Informational message", UVM_NONE);
    `uvm_warning("DRV", "Potential error");
    `uvm_error("DRV", "Real error");
     #10;
    `uvm_fatal("DRV", "Simulation cannot continue");
  endtask
endclass

module tb;
  driver drv;
  
  initial begin
    drv = new("DRV", null);
    drv.run();
  end
endmodule
*/

//--------------------------------------------------------------------------------------------------------------
//                                       CHANGING SEVERITY OF MACROS
//--------------------------------------------------------------------------------------------------------------

// override severity
/*
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent);
    super.new(path, parent);
  endfunction
  
  task run();
    `uvm_info("DRV", "Informational message", UVM_NONE);
    `uvm_warning("DRV", "Potential error");
    `uvm_error("DRV", "Real error");
     #10;
    `uvm_fatal("DRV", "Simulation cannot continue DRV");
     #10;
    `uvm_fatal("DRV1", "Simulation cannot continue DRV1");
  endtask
endclass

module tb;
  driver drv;
  
  initial begin
    drv = new("DRV", null);
    
    //drv.set_report_severity_override(UVM_FATAL, UVM_ERROR); // change severity of fatal to error
    
    drv.set_report_severity_id_override(UVM_FATAL,"DRV", UVM_ERROR);
    // changes severity of fatal with id = drv to error
    drv.run();
  end
endmodule
*/

//--------------------------------------------------------------------------------------------------------------
//                                  CHANGING ASSOCIATED ACTIONS OF MACROS
//---------------------------------------------------------------------------------------------------------------
/*

typedef int uvm_action;

typedef enum
{
  UVM_NO_ACTION = 'b0000000,     // no action taken
  UVM_DISPLAY = 'b0000001,       // send report to standard output
  UVM_LOG = 'b0000010,           // send report to file(s) for this (severity,id) pair
  UVM_COUNT = 'b0000100,         // counts the number of reports with count attribute. when this value reaches max_quit_count, the simulation terminates
  UVM_EXIT = 'b0001000,          // terminates simulation immediately
  UVM_CALL_HOOK = 'b0010000,     // callback the report hook methods
  UVM_STOP = 'b0100000,          // cause $stop to be excecuted, putting the simulation into interactive mode
  UVM_RM_RECORD = 'b1000000,     // sends report to recorder
}

*/


//---------------------------------------------------------------------------------------------------
/*

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent);
    super.new(path, parent);
  endfunction
  
  task run();
    
    `uvm_info("DRV", "Informational message", UVM_NONE);
    `uvm_warning("DRV", "Potential error");
    `uvm_error("DRV", "Real error");
    `uvm_error("DRV", "second Real error");
//      #10;
//     `uvm_fatal("DRV", "Simulation cannot continue");
//     #10;
//     `uvm_fatal("DRV1", "Simulation cannot continue DRV1");
    
  endtask
endclass


module tb;
  driver drv;
  
  initial begin
    drv = new("DRV", null);
    
//      drv.set_report_severity_action(UVM_INFO, UVM_NO_ACTION);      // will not see info message
    
//      drv.set_report_severity_action(UVM_INFO,UVM_DISPLAY | UVM_EXIT);// only info message will print
    
//      drv.set_report_severity_action(UVM_FATAL, UVM_DISPLAY);      // simulation will not stop at fatal now
 
//    count of errors  // comment out fatal
    drv.set_report_max_quit_count(2);  // simulation stop when 2 errors occur
    drv.run();
  end
endmodule

*/

//---------------------------------------------------------------------------------------------------------  
//----------------------------------------------------------------------------------------------------------
// log action

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent);
    super.new(path, parent);
  endfunction
  
  task run();
    
    `uvm_info("DRV", "Informational message", UVM_NONE);
    `uvm_warning("DRV", "Potential error");
    `uvm_error("DRV", "Real error");
    `uvm_error("DRV", "second Real error");
    
  endtask
endclass


module tb;
  driver drv;
  int file;
  
  initial begin
    file = $fopen("log.txt", "w");
    drv = new("DRV", null);
    //drv.set_report_default_file(file); // store all data in log file
    
    //dev.set_report_severity_file(UVM_ERROR, file); // will same errors in file; comment the next 2 lines
    /// similarly can save different report mech in different files
    
    drv.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
    drv.set_report_severity_action(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
    drv.set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_LOG);
    
    
    drv.run();
    
    #10;
    $fclose(file);
    
    // tick the download files after run option on eda playground
    // it will download a zip file
    // inside it , the log file will contain the text output
  end
endmodule
