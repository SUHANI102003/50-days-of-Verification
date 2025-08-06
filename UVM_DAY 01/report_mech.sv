//--------------------------------------------------------
//                UVM REPORTING MECHANISM
//--------------------------------------------------------

// UVM_INFO -- Informative message

// UVM_WARNING  -- Indicates a potential problem.Simulation continues subject to the configured message action

// UVM_ERROR -- Indicates a real problem. Simulation continues subject to the configured message action

// UVM_FATAL -- Indicates a problem from which simulation cannot recover. Simulation exists via $finish after a #0 delay

// These actions could vary if we have a override function  (later)


// typedef enum 
// {
// 	UVM_INFO,
//   	UVM_WARNING,
//   	UVM_ERROR,
//   	UVM_FATAL
  
// } uvm_severity;


// if redundancy level <= 200 (default) output can be seen on the console
//if > 200 - cannot see output on console
// redundancy level


// typedef enum
// {
// 		UVM_NONE = 0,      // report is always printed. verbosity level setting cannot disable it
//  	UVM_LOW  = 100,     // report is issued if verbosity is set to UVM_LOW or above
//   	UVM_MEDIUM = 200,  // "
//   	UVM_HIGH   = 300,  // "
//   	UVM_FULL = 400,   // "
//   	UVM_DEBUG = 500

// } uvm_verbosity;


//---------------------------------------------------------
//    USING REPORTING MACROS TO SEND DATA TO CONSOLE
//---------------------------------------------------------
// always write this when writing uvm code

`include "uvm_macros.svh"   //// `uvm_info
// definition of all macros

import uvm_pkg ::*;
// definition of all classes

// These 2 lines must always be included


//---------------------------------------------------
// SENDING STRING TO CONSOLE
//---------------------------------------------------
/*
module tb;
  
  initial begin
    #50;
    `uvm_info("TB_TOP", "Hello World!", UVM_LOW);
    
    // for comparision we'll use display also
    $display("Hello World with display");
  end
endmodule
*/



//---------------------------------------------------
// PRINTING VALUES OF VARIABLES WITHOUT AUTOMATION
//---------------------------------------------------
/*
module tb;
  
  int data = 56;
  initial begin
    `uvm_info("TB_TOP", $sformatf("Value of variable : %0d", data), UVM_NONE);
  end
endmodule
*/


//---------------------------------------------------
// WORKING WITH VERBOSITY LEVELS
//---------------------------------------------------
/*
module tb;
  // UVM creates hierarchy of all components
  // utilizing UVM_TOP as we cannot extend Uvm component
  
  initial begin
    $display("Default Verbosity level : %0d", uvm_top.get_report_verbosity_level);    // 200
    
    #10;
    // `uvm_info("TB_TOP", "Hello World!", UVM_MEDIUM); // can send string as verbosity level < default
    
    `uvm_info("TB_TOP", "Hello World!", UVM_HIGH);  // no output seen as verbosity level > default; filtered out string
  end
endmodule

*/

// To change verbosity level
module tb;
  
  
  initial begin
    $display("Default Verbosity level : %0d", uvm_top.get_report_verbosity_level);    
    #10;
    uvm_top.set_report_verbosity_level(UVM_HIGH); // setting the verbosity level to HIGH
    // now can see the string 
    // if i use UVM_FULL ; cannot see as level > HIGH
    `uvm_info("TB_TOP", "Hello World!", UVM_HIGH);  
  end
endmodule
