`timescale 1ns / 1ps

//-----------------------------------------------------
// LET'S TRY BUILD THE COMPLETE TESTBENCH NOW
//------------------------------------------------------
//-------------------------------------------------------
// ADDING THE TRANSACTION CLASS
//-------------------------------------------------------
/*
class transaction;
    randc bit [3:0] a, b; // data signals 
    bit [4:0] sum;
    
    // method to access values of transaction class
    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d ", a,b,sum);
    endfunction
endclass

//----------------------------------------------------------
// ADDING GENERATOR CLASS
//----------------------------------------------------------

class generator;
    transaction trans;
    mailbox #(transaction) mbx;
    int i = 0;
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        for(i=0; i<20; i++) begin
            trans = new();   // to create independent obj for each transaction
            assert(trans.randomize()) else 
                $display("Randomization failed");
            $display("[GEN]: DATA SENT TO DRIVER");
            trans.display();
            #10;
        end
    endtask
endclass
//------------------------------------------
module building_tb_part1();
generator gen;
mailbox #(transaction) mbx;

initial begin
    mbx = new();
    gen = new(mbx);
    gen.run();
end
endmodule
*/
/*
OBSERVATIONS:
---------------------------
1. We see from above code output that, even though we are using randc some values are getting repeated.
2. this happens because each new object has its own history, i.e, each value is independent , so leeads to repitition
3. We have 2 requirements
   a. we want to have independent copy of object for each transaction
   b. we also want to have history of our object so that randc works fine
4. SOLUTION:  DEEP COPY
5. whenever we call deep copy-> we have independent referance to an object - this way we can create duplicate object,
   i.e, purely independent.
*/
// THE CODE CHANGES AS FOLLOWS
//-------------------------------------------------------
// ADDING THE TRANSACTION CLASS
//-------------------------------------------------------

class transaction;
    randc bit [3:0] a, b; // data signals 
    bit [4:0] sum;
    
    // method to access values of transaction class
    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d ", a,b,sum);
    endfunction
    
    function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b; 
        copy.sum = this.sum;
    endfunction
endclass

//----------------------------------------------------------
// ADDING GENERATOR CLASS
//----------------------------------------------------------

class generator;
    transaction trans;
    event done;
    mailbox #(transaction) mbx;
    int i = 0;
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();  // create object here 
    endfunction
    
    task run();
        for(i=0; i<20; i++) begin
           // trans = new();   // to create independent obj for each transaction
            assert(trans.randomize()) else 
                $display("Randomization failed");
            $display("[GEN]: DATA SENT TO DRIVER");
            trans.display();
            mbx.put(trans.copy);  // send the copy of trans class
            #20;
        end
        ->done;
    endtask
endclass

//-------------------------------------------------------------
// ADDING THE DRIVER CLASS
//-------------------------------------------------------------
class driver;
    virtual add1_if aif;
    mailbox #(transaction) mbx;
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    transaction data;
    
    task run();
        forever begin
            mbx.get(data);
            @(posedge aif.clk);
            aif.a <= data.a;
            aif.b <= data.b;
            $display("[DRV]: INTERFACE TRIGGER");
            data.display();
        end
    endtask
endclass



module building_tb_part1();

generator gen;
driver drv;
event done;
mailbox #(transaction) mbx;
add1_if aif();
add1 dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

initial begin
    aif.clk = 0;
end

always #10 aif.clk = ~aif.clk;

initial begin
     $display(">>> Simulation started at time %0t", $time);
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    drv.aif = aif;
    done = gen.done;
end

initial begin
    fork 
        gen.run();
        drv.run();
    join_none
    wait(done.triggered);   // allows us to wait till both processes are complete
     $display(">>> Simulation completed");
    $finish;
end
endmodule


