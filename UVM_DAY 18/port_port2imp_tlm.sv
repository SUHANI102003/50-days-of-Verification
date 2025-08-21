`include "uvm_macros.svh"
import uvm_pkg ::*;

//------------------------------------------------
//           PORT-PORT TO IMP TLM
//------------------------------------------------
// here port-port means my producer has a sub-producer inside. both have a port

/////////////////////////////////////////////////////////

class subproducer extends uvm_component;
  `uvm_component_utils(subproducer)
  
  int data = 12;
  
  uvm_blocking_put_port#(int) subport; 
  
  function new(input string path = "subproducer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    subport = new("subport", this);
  endfunction
  

  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    subport.put(data);
      `uvm_info("SUBPROD", $sformatf("Data sent : %0d", data), UVM_NONE);
    phase.drop_objection(this);
  endtask
  
endclass

/////////////////////////////////////////////////////


class producer extends uvm_component;
  `uvm_component_utils(producer)
  
  subproducer s;
  
  uvm_blocking_put_port#(int) port; 
  
  function new(input string path = "producer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
    s = subproducer::type_id::create("s", this);
  endfunction
  
  // form connection here between port & subport
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    s.subport.connect(port);
  endfunction
 
  
endclass

/////////////////////////////////////////////////////////


class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  
  uvm_blocking_put_imp#(int, consumer) imp;  
  
  
  function new(input string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
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
