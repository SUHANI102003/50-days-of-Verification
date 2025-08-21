`include "uvm_macros.svh"
import uvm_pkg ::*;

//------------------------------------------------
//           get OPERATION TLM
//------------------------------------------------
// in this the producer initiates the communication but the data is retrieved from consumer by producer (opposite direction of data flow and control flow) 

/////////////////////////////////////////////////////////

class producer extends uvm_component;
  `uvm_component_utils(producer)
  
  uvm_blocking_get_port#(int) port; 
  
  int data = 0; // container for receiving data
  
  function new(input string path = "producer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
  endfunction
  

    task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    port.get(data);
      `uvm_info("PROD", $sformatf("Data Recv : %0d", data), UVM_NONE);
    phase.drop_objection(this);
  endtask
  
endclass


///////////////////////////////////////////////////////////


class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  
  int data = 12;
  
  uvm_blocking_get_imp#(int, consumer) imp;  
 
  
  function new(input string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    imp = new("imp", this);
  endfunction
  
  
  virtual task get(output int datar);
    `uvm_info("CONS", $sformatf("Data sent : %0d", data), UVM_NONE);
    datar = data;
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
    p.port.connect(c.imp); 
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
