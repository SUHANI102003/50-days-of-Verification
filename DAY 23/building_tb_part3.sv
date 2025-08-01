`timescale 1ns / 1ps

// in this part we'll be seeing how to add monitor and scoreboard to testbench
// we will not be having generator & driver for this, so we'll have to manually add stimulus 
// & observe the behaviour of monitor & scoreboard

class transaction;
    randc bit [3:0] a, b; // data signals 
    bit [4:0] sum;
    
    // method to access values of transaction class
    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d ", a,b,sum);
    endfunction    
endclass

//------------------------------------------------------
// INTERFACE
//------------------------------------------------------
interface add3_if;
    logic clk;
    logic [3:0] a,b;  
    logic [4:0] sum;    
endinterface
   
//--------------------------------------------------
// ADDING MONITOR CLASS
//--------------------------------------------------
class monitor;
    mailbox #(transaction) mbx;
    transaction trans;
    virtual add3_if aif;
    
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        trans = new();
        forever begin
            repeat(2)@(posedge aif.clk);  // to make the input stable for 2 cc
            // updating transaction object with value received from dut
            trans.a = aif.a;
            trans.b = aif.b;
            trans.sum = aif.sum;
            $display("[MON]: SENT DATA TO SCOREBOARD");
            trans.display();
            mbx.put(trans);
        end
    endtask
endclass

//--------------------------------------------------
// ADDING THE SCOREBOARD CLASS
//---------------------------------------------------

class scoreboard;
    mailbox #(transaction) mbx;
    transaction trans;
    
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
    forever begin
    mbx.get(trans);
    $display("[SCO]: SENT DATA TO SCOREBOARD");
    trans.display();
    //#20;
    #40;
    end
    endtask
endclass

//---------------------------------------------------
// TEST
//---------------------------------------------------
module building_tb_part3();
monitor mon;
scoreboard sco;
 mailbox #(transaction) mbx;
add3_if aif();

add1 dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

initial begin
    aif.clk <= 0;
end

always #10 aif.clk <= ~aif.clk;

initial begin
    for(int i=0; i<20; i++)begin
        repeat(2)@(posedge aif.clk);
        aif.a<= $urandom_range(0,15);
        aif.b<= $urandom_range(0,15);
    end
end

initial begin
    mbx = new();
    mon = new(mbx);
    sco = new(mbx);
    mon.aif = aif; 
    
    end 
    
    initial begin
    fork
        mon.run();
        sco.run();
    join
end 

initial begin
#450;
$finish;
end
endmodule
