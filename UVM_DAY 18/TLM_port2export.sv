`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//                  TLM
//---------------------------------------------------------
// to communicate data between classes, we use TLM communication
// frequent usage - sending sequence from sequencer to driver (we have a special port for that in UVM)
// other usage-- sending data from monitor to scoreboard utilizing an analysis bus.
//---------------------------------------------------------

// port - initiator of communication
// export - receiver of communication
// 2 flows - data flow and control flow
// if both in same direction - put
// if both in different direction - get
// all operation can be either blocking or non-blocking

//------------------------------------------------------

/*
class producer extends uvm_component;
  `uvm_component_utils(producer)
  
  int data = 12;
  
  uvm_blocking_put_port#(int) send; // parameterized class
  
  function new(input string path = "producer", uvm_component parent = null);
    super.new(path, parent);
    
    send = new("send", this); // 4 arguments (using only 2 as i have only single export)
    
  endfunction
  
endclass

/////////////////////////////////////////////////////

class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  
  uvm_blocking_put_export#(int) recv;
  
  function new(input string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
    
    recv = new("recv", this); 
    
  endfunction
  
endclass

//note - we have not added anything about sending the data.
// tlm does not have any methods that can be used to communicate the data; perform only connection

// all the methods are defined in uvm_blocking_put_imp
///////////////////////////////////////////////////////

class env extends uvm_env;
  `uvm_component_utils(env)
  
  producer p;
  consumer c;
  
  function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p = producer::type_id::create("p", this);
    c = consumer::type_id::create("c", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    p.send.connect(c.recv); // forming connection
  endfunction
  
endclass

/////////////////////////////////////////////////////////


class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path, parent);
   endfunction
  
   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     e = env::type_id::create("e", this); 
  endfunction
endclass

//////////////////////////////////////////////////////

module tb;

  initial begin
    run_test("test");
  end
endmodule

*/

// we get 2 errors and 1 fatal -->
// export cannot be the end point of tlm
// we need implementation
// another error - no method to send or receive data

// make changes in code

//--------------------------------------------------------
// modified code
//---------------------------------------------------------


class producer extends uvm_component;
  `uvm_component_utils(producer)
  
  int data = 12;
  
  uvm_blocking_put_port#(int) send; 
  
  function new(input string path = "producer", uvm_component parent = null);
    super.new(path, parent);
    
    send = new("send", this);
    
  endfunction
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    send.put(data);
    `uvm_info("PROD", $sformatf("Data sent : %0d", data), UVM_NONE);
    phase.drop_objection(this);
  endtask
  
endclass

/////////////////////////////////////////////////////

class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  
  uvm_blocking_put_export#(int) recv;
  uvm_blocking_put_imp#(int, consumer) imp;  
// to add methods to values and making imp end point to remove errors/fatal
  
  function new(input string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
    
    recv = new("recv", this); 
    imp = new("imp", this);
  endfunction
  
  task put(int datar);
    `uvm_info("CONS", $sformatf("Data rcvd : %0d", datar), UVM_NONE);
    
  endtask
  
endclass


///////////////////////////////////////////////////////

class env extends uvm_env;
  `uvm_component_utils(env)
  
  producer p;
  consumer c;
  
  function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p = producer::type_id::create("p", this);
    c = consumer::type_id::create("c", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    p.send.connect(c.recv); // forming connection
    c.recv.connect(c.imp);  // implementation
  endfunction
  
endclass

/////////////////////////////////////////////////////////


class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path, parent);
   endfunction
  
   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     e = env::type_id::create("e", this); 
  endfunction
endclass

//////////////////////////////////////////////////////

module tb;

  initial begin
    run_test("test");
  end
endmodule
