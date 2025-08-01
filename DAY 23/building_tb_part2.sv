`timescale 1ns / 1ps
/*
//-------------------------------------------------------
// INJECTING ERRORS TO VERIFY & COVER CORNER CASES 
//------------------------------------------------------ 
// We'll be using the concept of Inheritance and Deep copy to achieve this
class transaction;
    randc bit [3:0] a, b; // data signals 
    bit [4:0] sum;
    
    // method to access values of transaction class
    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d ", a,b,sum);
    endfunction
  
endclass

//---------------------------------------------------
//   ERROR CLASS USING INHERITANCE
//----------------------------------------------------
class error extends transaction;
    constraint data_c {a==0; b==0;}
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
    endfunction
    
    task run();
        for(i=0; i<20; i++) begin
           trans = new();   // to create independent obj for each transaction
            assert(trans.randomize()) else 
                $display("Randomization failed");
            $display("[GEN]: DATA SENT TO DRIVER");
            trans.display();
            mbx.put(trans);  
            #20;
        end
        ->done;
    endtask
endclass

//---------------------------------------------------
// INTERFACE
//----------------------------------------------------
interface add2_if;
    logic clk;
    logic [3:0] a,b;  
    logic [4:0] sum;    
endinterface

//-------------------------------------------------------------
// ADDING THE DRIVER CLASS
//-------------------------------------------------------------
class driver;
    virtual add2_if aif;
    mailbox #(transaction) mbx;
    transaction data;
    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction
        
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



module building_tb_part2();

add2_if aif();
generator gen;
driver drv;
error er;
event done;
mailbox #(transaction) mbx;

add1 dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

initial begin
    aif.clk <= 0;
end

always #10 aif.clk <= ~aif.clk;

initial begin
     $display(">>> Simulation started at time %0t", $time);
    mbx = new();
    er = new();
    gen = new(mbx);
    drv = new(mbx);
    gen.trans = er; // send error object to generator transaction object
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
*/
// IN THE ABOVE OUTPUT WE ARE STILL SEEING RANDOM VALUES => CONSTRAINT NOT APPLIED
// This is because we are sending original object & thus, the constraints cannot override the oiginal 
// behaviour, resulting in random values being sent.
// so we'll follow the previous method i.e deep copy method

class transaction;
    randc bit [3:0] a, b; // data signals 
    bit [4:0] sum;
    
    // method to access values of transaction class
    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d ", a,b,sum);
    endfunction
    
    function transaction copy(); // deep copy
        copy = new();
        copy.a = this.a;
        copy.b = this.b; 
        copy.sum = this.sum;
    endfunction
endclass

//---------------------------------------------------
//   ERROR CLASS USING INHERITANCE
//----------------------------------------------------
class error extends transaction;
    constraint data_c {a==0; b==0;}
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
            mbx.put(trans.copy());  // send the copy of trans class
            #20;
        end
        ->done;
    endtask
endclass

//---------------------------------------------------
// INTERFACE
//----------------------------------------------------
interface add2_if;
    logic clk;
    logic [3:0] a,b;  
    logic [4:0] sum;    
endinterface
//-------------------------------------------------------------
// ADDING THE DRIVER CLASS
//-------------------------------------------------------------
class driver;
    virtual add2_if aif;
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



module building_tb_part2();

generator gen;
driver drv;
error err;
event done;
mailbox #(transaction) mbx;
add2_if aif();
add1 dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

initial begin
    aif.clk <= 0;
end

always #10 aif.clk <= ~aif.clk;

initial begin
     $display(">>> Simulation started at time %0t", $time);
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    drv.aif = aif;
    err = new();
    gen.trans = err;
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

//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------

// instead of sending constraints , we can directly modify the transaction object we are sending to driver.
//  popular method to do this is 
/*
class transaction;
    randc bit [3:0] a, b; // data signals 
    bit [4:0] sum;
    
    // method to access values of transaction class
    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d ", a,b,sum);
    endfunction
    
    virtual function transaction copy(); // declare method virtual
        copy = new();
        copy.a = this.a;
        copy.b = this.b; 
        copy.sum = this.sum;
    endfunction
endclass

class error extends transaction;
    //constraint data_c {a==0; b==0;}
    function transaction copy(); 
        copy = new();
        copy.a = 0;
        copy.b = 0; 
        copy.sum = this.sum;
    endfunction
endclass

in this we see that the generator is generating random values 
but the driver is giving 0 to dut 
*/

