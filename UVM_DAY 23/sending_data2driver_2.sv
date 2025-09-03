`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//           SENDING DATA TO DRIVER 
//                MOST USED
//---------------------------------------------------------

class transaction extends uvm_sequence_item;
  
  rand bit [3:0] a;
  rand bit [3:0] b;
       bit [4:0] y;
 
 
  function new(input string path = "transaction");
    super.new(path);
  endfunction
 
`uvm_object_utils_begin(transaction)
  `uvm_field_int(a,UVM_DEFAULT)
  `uvm_field_int(b,UVM_DEFAULT)
  `uvm_field_int(y,UVM_DEFAULT)
`uvm_object_utils_end
 
endclass
////////////////////////////////////////////////////////////////
 
class sequence1 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence1)
 
 transaction trans;
  
    function new(input string path = "seq1");
      super.new(path);
    endfunction
 
  // instead of do method we use this method (most frequently used) 
    virtual task body();
      repeat(5) begin
        trans = transaction::type_id::create("trans");
        start_item(trans);
        assert(trans.randomize());
        finish_item(trans);
        `uvm_info("SEQ", $sformatf("a : %0d b : %0d", trans.a, trans.b), UVM_NONE);
      end
    endtask
 
  
endclass
 
////////////////////////////////////////////////////
 
class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
 
transaction trans;
 
 
  function new(input string path = "DRV", uvm_component parent = null);
    super.new(path,parent);
  endfunction
 
  
 
    virtual task run_phase(uvm_phase phase);
      trans = transaction::type_id::create("trans");
       forever begin
         seq_item_port.get_next_item(trans);
         `uvm_info("DRV", $sformatf("a : %0d b : %0d", trans.a, trans.b), UVM_NONE);
   		 seq_item_port.item_done();
    end
      
    endtask
 
endclass
 
//////////////////////////////////////////////////////////////
 
class agent extends uvm_agent;
`uvm_component_utils(agent)
 
  function new(input string path = "agent", uvm_component parent = null);
    super.new(path,parent);
  endfunction
 
  driver d;
  uvm_sequencer #(transaction) seqr;
 
 
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      d = driver::type_id::create("d",this);
      seqr = uvm_sequencer #(transaction)::type_id::create("seqr",this);
    endfunction
 
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      d.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
 
////////////////////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
  function new(input string path = "env", uvm_component parent= null);
    super.new(path,parent);
  endfunction
 
  agent a;
  sequence1 s1;
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  	a = agent::type_id::create("a",this);
    s1 = sequence1::type_id::create("s1",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this); 
   s1.start(a.seqr);
   phase.drop_objection(this);
  endtask
 
endclass
 
///////////////////////////////////////////////////////////////////
 
class test extends uvm_test;
`uvm_component_utils(test)
 
  function new(input string path = "test", uvm_component parent = null);
  super.new(path,parent);
  endfunction

	env e;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  e = env::type_id::create("e",this);
endfunction
 
  
endclass
 
/////////////////////////////////////////////////////////
 
module ram_tb;
 
initial begin
  run_test("test");
end
 
 
endmodule
 
 
 
 
 
 
 

