`timescale 1ns / 1ps

//---------------------------------------------
// PARAMETERIZED MAILBOX
//---------------------------------------------
/*
A parameterized mailbox means a mailbox that is typed
 i.e., it only allows specific data types to be passed through it.
By default:
SystemVerilog mailboxes are untyped, 
meaning you can put() or get() any variable type (integers, objects, etc.

mailbox mbx;  // untyped mailbox
But this lacks type safety — the simulator won’t warn you if you put() a type and get() 
expecting a different type.
*/
class transaction;
    bit [7:0] data;
endclass

class generator;
    int data = 12;
    logic [7:0] temp = 3;
    transaction t;
    mailbox # (transaction) mbx;              // make these changes // now my mailbox Can only hold `transaction` objects
    function new(mailbox # (transaction) mbx);  // here also
    this.mbx = mbx;
    endfunction
    
    task run();
        t = new();
        t.data = 45;
        mbx.put(t);
        $display("[GEN] : DATA SENT FROM GEN : %0d", t.data);
    endtask
endclass

class driver;
    mailbox # (transaction) mbx;
    function new(mailbox # (transaction) mbx);
    this.mbx = mbx;
    endfunction
    
    transaction data;  // data container
    
    task run();
    mbx.get(data);
    $display("[GEN] : DATA SENT FROM GEN : %0d", data.data);
    endtask
    
endclass

module parameterized_mailbox();
generator gen;
driver drv;
mailbox # (transaction) mbx;

initial begin
mbx = new();
gen = new(mbx);
drv = new(mbx);

fork 
gen.run();
drv.run();
join

#1;
$finish;
end
endmodule
