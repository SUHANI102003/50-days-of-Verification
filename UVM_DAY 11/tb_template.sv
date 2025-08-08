`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//  TEMPLATE TO TEST DIFFERENT SCENARIOS IN UVM TB
//---------------------------------------------------------
// We have 2 components in our entire testbench environment, which are used to send and receive the data from our tb top


//--------------------------------------------------------
//             COMPONENT 1
//---------------------------------------------------------

class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  
  int data1 = 0;  // temp var to get data sent by test
  
  function new(input string path = "comp1", uvm_component parent = null);
    super.new(path,parent);
  endfunction


virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(int)::get(null, "uvm_test_top", "data", data1))
    
    `uvm_error("comp1", "Unable to accesss Interface");
  
endfunction


virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("comp1", $sformatf("Data rcvd comp1 : %0d", data1), UVM_NONE);
  phase.drop_objection(this);
endtask
endclass

//--------------------------------------------------------
//                      COMPONENT 2
//---------------------------------------------------------
class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  
  int data2 = 0;  // temp var to get data  
  
  function new(input string path = "comp2", uvm_component parent = null);
    super.new(path,parent);
  endfunction



virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(int)::get(null, "uvm_test_top", "data", data2))
    
    `uvm_error("comp2", "Unable to accesss Interface");
  
endfunction


virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("comp2", $sformatf("Data rcvd comp2 : %0d", data2), UVM_NONE);
  phase.drop_objection(this);
endtask
endclass

//---------------------------------------------------------
//                   AGENT CLASS (child of env class)
//---------------------------------------------------------

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  
  function new(input string inst = "AGENT", uvm_component c);
    super.new(inst,c);
  endfunction
  
  comp1 c1;
  comp2 c2;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1 = comp1::type_id::create("comp1", this);
    c2 = comp2::type_id::create("comp2", this);
  endfunction
  
endclass


//---------------------------------------------------------
//                   Environment CLASS 
//---------------------------------------------------------

class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent a;
  
  function new(input string inst = "ENV", uvm_component c);
    super.new(inst,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("AGENT", this); 
  endfunction
endclass

//---------------------------------------------------------
//                  TEST CLASS 
//---------------------------------------------------------
class test extends uvm_test;
  `uvm_component_utils(test)
  
 env e;
  
  function new(input string inst = "TEST", uvm_component c);
    super.new(inst,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("ENV", this); 
  endfunction
endclass


//---------------------------------------------------------
//                  TB TOP 
//---------------------------------------------------------
module tb;
  
  int data = 256;
  
  initial begin
    uvm_config_db#(int)::set(null, "uvm_test_top", "data", data); //// key = uvm_test_top.data
    
    /// set method will concatenate the 4 fields and create a path or key
    // classes that provide unique key formed by concatenating these 3 arg will have access to data member
    run_test("test");
  end
  
endmodule


//---------------------------------------------------------
//---------------------------------------------------------
// LRT'S TRY TO CHANGE GET METHOD IN BOTH COMPONENTS 
//---------------------------------------------------------
//---------------------------------------------------------
/*
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  
  int data1 = 0;  // temp var to get data sent by test
  
  function new(input string path = "comp1", uvm_component parent = null);
    super.new(path,parent);
  endfunction


virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(int)::get(this, "", "data", data1))  // null -> this ; remove uvm_test_top 
// new path--> uvm_test_top.env.agent.comp1.data
    
    `uvm_error("comp1", "Unable to accesss Interface");
  
endfunction


virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("comp1", $sformatf("Data rcvd comp1 : %0d", data1), UVM_NONE);
  phase.drop_objection(this);
endtask
endclass

//--------------------------------------------------------
//                      COMPONENT 2
//---------------------------------------------------------

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  
  int data2 = 0;  // temp var to get data  
  
  function new(input string path = "comp2", uvm_component parent = null);
    super.new(path,parent);
  endfunction



virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(int)::get(this, "", "data", data2))  // null -> this; remove uvm_test_top
// new path ->  uvm_test_top.env.agent.comp2.data
    
    `uvm_error("comp2", "Unable to accesss Interface");
  
endfunction


virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("comp2", $sformatf("Data rcvd comp2 : %0d", data2), UVM_NONE);
  phase.drop_objection(this);
endtask
endclass


//---------------------------------------------------------
//             AGENT CLASS (child of env class)
//---------------------------------------------------------

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  
  function new(input string inst = "AGENT", uvm_component c);
    super.new(inst,c);
  endfunction
  
  comp1 c1;
  comp2 c2;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1 = comp1::type_id::create("comp1", this);
    c2 = comp2::type_id::create("comp2", this);
  endfunction
  
endclass


//---------------------------------------------------------
//                   Environment CLASS 
//---------------------------------------------------------

class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent a;
  
  function new(input string inst = "ENV", uvm_component c);
    super.new(inst,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("AGENT", this); 
  endfunction
endclass

//---------------------------------------------------------
//                  TEST CLASS 
//---------------------------------------------------------
class test extends uvm_test;
  `uvm_component_utils(test)
  
 env e;
  
  function new(input string inst = "TEST", uvm_component c);
    super.new(inst,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("ENV", this); 
  endfunction
endclass


//---------------------------------------------------------
//                  TB TOP 
//---------------------------------------------------------
module tb;
  
  int data = 256;
  
  initial begin
    uvm_config_db#(int)::set(null, "uvm_test_top", "data", data); //// key = uvm_test_top.data
    
    // here both the concatination paths of set and get are not matching --->
    // get uvm_error from both components
    // automatically calls uvm_fatal --> stops simulation
    run_test("test");
  end
  
endmodule
*/

//---------------------------------------------------------
//--------------------------------------------------------
// NOW LETS COMMENT OUT OUR COMP2 CLASS AND ADD THE path to tb top
//---------------------------------------------------------
//---------------------------------------------------------
/*
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  
  int data1 = 0;  // temp var to get data sent by test
  
  function new(input string path = "comp1", uvm_component parent = null);
    super.new(path,parent);
  endfunction


virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(int)::get(this, "", "data", data1))  // null -> this ; remove uvm_test_top 
// new path--> uvm_test_top.env.agent.comp1.data
    
    `uvm_error("comp1", "Unable to accesss Interface");
  
endfunction


virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("comp1", $sformatf("Data rcvd comp1 : %0d", data1), UVM_NONE);
  phase.drop_objection(this);
endtask
endclass

//--------------------------------------------------------
//                      COMPONENT 2
//---------------------------------------------------------

// class comp2 extends uvm_component;
//   `uvm_component_utils(comp2)
  
//   int data2 = 0;  // temp var to get data  
  
//   function new(input string path = "comp2", uvm_component parent = null);
//     super.new(path,parent);
//   endfunction



// virtual function void build_phase(uvm_phase phase);
//   super.build_phase(phase);
//   if(!uvm_config_db#(int)::get(this, "", "data", data2))  // null -> this; remove uvm_test_top
// // new path ->  uvm_test_top.env.agent.comp2.data
    
//     `uvm_error("comp2", "Unable to accesss Interface");
  
// endfunction


// virtual task run_phase(uvm_phase phase);
//   phase.raise_objection(this);
//   `uvm_info("comp2", $sformatf("Data rcvd comp2 : %0d", data2), UVM_NONE);
//   phase.drop_objection(this);
// endtask
// endclass


//---------------------------------------------------------
//             AGENT CLASS (child of env class)
//---------------------------------------------------------

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  
  function new(input string inst = "agent", uvm_component c);
    super.new(inst,c);
  endfunction
  
  comp1 c1;
//  comp2 c2;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1 = comp1::type_id::create("comp1", this);
//    c2 = comp2::type_id::create("comp2", this);
  endfunction
  
endclass


//---------------------------------------------------------
//                   Environment CLASS 
//---------------------------------------------------------

class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent a;
  
  function new(input string inst = "env", uvm_component c);
    super.new(inst,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("agent", this); 
  endfunction
endclass

//---------------------------------------------------------
//                  TEST CLASS 
//---------------------------------------------------------
class test extends uvm_test;
  `uvm_component_utils(test)
  
 env e;
  
  function new(input string inst = "test", uvm_component c);
    super.new(inst,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("env", this); 
  endfunction
endclass


//---------------------------------------------------------
//                  TB TOP 
//---------------------------------------------------------
module tb;
  
  int data = 256;
  
  initial begin
   uvm_config_db#(int)::set(null, "uvm_test_top.env.agent.comp1", "data", data); 
    
    // key matching to comp1 get key
    run_test("test");
  end
  
endmodule

*/

//---------------------------------------------------------
//--------------------------------------------------------
// if you want to provide access to all components presentin a specific instance, ex, agent has both components
//---------------------------------------------------------
//---------------------------------------------------------

//---------------------------------------------------------
//                  TB TOP 
//---------------------------------------------------------
/*
module tb;
  
  int data = 256;
  
  initial begin
    uvm_config_db#(int)::set(null, "uvm_test_top.env.agent*", "data", data); 
    
    // * means each component within agent can access data
    run_test("test");
  end
  *
