`include "uvm_macros.svh"
import uvm_pkg ::*;

//------------------------------------------------
//           PORT TO EXPORT IMP TLM
//------------------------------------------------
// here we have single producer and multiple consumer, meaning consumer has a subconsumer (subconsumer has a imp port)

/////////////////////////////////////////////////////////

class producer extends uvm_component;
  `uvm_component_utils(producer)
  
  int data = 12;
  
  uvm_blocking_put_port#(int) port; 
  
  function new(input string path = "producer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
  endfunction
  

    task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    port.put(data);
    `uvm_info("PROD", $sformatf("Data sent : %0d", data), UVM_NONE);
    phase.drop_objection(this);
  endtask
  
endclass


///////////////////////////////////////////////////////////


class subconsumer extends uvm_component;
  `uvm_component_utils(subconsumer)
  
  uvm_blocking_put_imp#(int, subconsumer) imp;  
  
  
  function new(input string path = "subconsumer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    imp = new("imp", this);
  endfunction
  
  
  task put(int datar);
    `uvm_info("SUBCONS", $sformatf("Data rcvd : %0d", datar), UVM_NONE);
  endtask
  
endclass


//////////////////////////////////////////////////////////

class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  
  uvm_blocking_put_export#(int) expo;  
  subconsumer s;
  
  function new(input string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    expo = new("expo", this);
    s = subconsumer::type_id::create("s", this);
  endfunction
  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    expo.connect(s.imp);
  endfunction
  
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
    p.port.connect(c.expo); 
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
  
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

//////////////////////////////////////////////////////

module tb;

  initial begin
    run_test("test");
  end
endmodule
