//---------------------------------------------------------
// OVERRIDE A PACKET IN SYSTEM VERILOG
//---------------------------------------------------------
/*
class wr_txn;
  rand bit [7:0] data_in;
  
  function void display();
    $display("base_txn data_in : %0d", data_in);
  endfunction
endclass


class generator;
  wr_txn wtxnh;
  
  mailbox #(wr_txn) gen_drv_mb;
  
  function new(mailbox #(wr_txn) gen_drv_mb);
    this.gen_drv_mb = gen_drv_mb;
    wtxnh = new();
  endfunction
  
  task send_packet();
    assert(wtxnh.randomize());
    wtxnh.display();
    gen_drv_mb.put(wtxnh);
    #10;
  endtask
endclass


class driver;
  mailbox #(wr_txn) gen_drv_mb;
  wr_txn wtxnh;
  
   function new(mailbox #(wr_txn) gen_drv_mb);
    this.gen_drv_mb = gen_drv_mb;
  endfunction
  
  task drive_packet();
    gen_drv_mb.get(wtxnh);
    wtxnh.display();
    #10;
  endtask
endclass

class env;
  generator gen;
  driver drv;
  mailbox #(wr_txn) mb;
  
  function new();
    mb = new();
    gen = new(mb);
    drv = new(mb);
  endfunction
  
  task run();
    gen.send_packet();
    drv.drive_packet();
  endtask
endclass

module test;
  env envh;
  
  initial begin
    envh = new();
    envh.run();
    $display("test completed");
  end
endmodule
*/

//---------------------------------------------------------
// NOW LET'S SAY I WANT TO CHANGE MY DATA TO A 12 BIT VALUE
// HOW TO DO??

//---------------------------------------------------------
// 1. CREATE ANOTHER PACKET
//---------------------------------------------------------
/*
class wr_txn2;
  rand bit [11:0] data_in;
  
  function void display();
    $display("base_txn data_in : %0d", data_in);
  endfunction
  
endclass

to use this class, wherever in my code there is wr_txn written, i have to replace it by wr_txn2

*/
//---------------------------------------------------------
// 2. Extend the first packet by following inheritance (more practical way ) and override the method
//---------------------------------------------------------

class wr_txn;
  rand bit [7:0] data_in;
  
   virtual function void display();
    $display("base_txn data_in : %0d", data_in);
  endfunction
endclass

// add extended class
class wr_txn2 extends wr_txn;
  rand bit [11:0] data_in;
  
  function void display();
    $display("wr_txn2 data_in : %0d", data_in);
  endfunction
  
endclass


class generator;
  wr_txn wtxnh;
  wr_txn txn_type;
  mailbox #(wr_txn) gen_drv_mb;
  
  function new(mailbox #(wr_txn) gen_drv_mb, wr_txn txn_type);
    
    this.gen_drv_mb = gen_drv_mb;
    wtxnh = txn_type;
  endfunction
  
  task send_packet();
    assert(wtxnh.randomize());
    wtxnh.display();
    gen_drv_mb.put(wtxnh);
    #10;
  endtask
endclass


class driver;
  mailbox #(wr_txn) gen_drv_mb;
  wr_txn wtxnh;
  
   function new(mailbox #(wr_txn) gen_drv_mb);
    this.gen_drv_mb = gen_drv_mb;
  endfunction
  
  task drive_packet();
    gen_drv_mb.get(wtxnh);
    wtxnh.display();
    #10;
  endtask
endclass

class env;
  generator gen;
  driver drv;
  wr_txn txn_type;
  
  mailbox #(wr_txn) mb;
  
  function new(wr_txn txn_type);
    mb = new();
   this.txn_type = txn_type;
    gen = new(mb, txn_type);
    drv = new(mb);
  endfunction
  
  task run();
    gen.send_packet();
    drv.drive_packet();
  endtask
endclass

module test;
  env envh;
  wr_txn txnh;
  wr_txn2 txnh2;
  
  initial begin
    txnh = new();
    txnh2 = new();
    
    envh = new(txnh2);
    envh.run();
    $display("test completed");
  end
endmodule
