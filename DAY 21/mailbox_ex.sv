`timescale 1ns / 1ps

//-----------------------------------------------
//          MAILBOX
//-----------------------------------------------
//USED TO SEND DATA BETWEEN CLASSES 
// (gen -> driver)  & (monitor -> scoreboard)
/*
class generator;
    int data = 12;  // single data mem // want to communicate to driver class
    mailbox mbx;  // gen2drv
    task run();  // main task calling in tb top, that will handle the process of sending data from gen to drv
        mbx.put(data);
        $display("[GEN] : SENT DATA : %0d", data);
    endtask
endclass

// put() allows us to send data to another class

class driver;  // receiving data from gen
  int datac = 0;  // data container that stores the value of DM data in generator
  
  mailbox mbx;
  task run();
    mbx.get(datac);  // get data from gen class & store in data container
     $display("[DRV] : RCVD DATA : %0d", datac);
  endtask  
endclass

// now we have 2 independent mailbox. 
// we need a common mailbox on wchich both gen & drv works
// so, make them equal in tb top
// also add a constructor as it is a parameterized class

module mailbox_ex();
generator gen;
driver drv;
mailbox mbx;

initial begin
    gen = new();
    drv = new();
    mbx = new();
    // make the mailbox of gen and drv equal to tb mailbox
    gen.mbx = mbx;
    drv.mbx = mbx;
    
    fork
    gen.run();
    drv.run();
    join 
       
    #1;
    $finish;
end
endmodule
*/
// we'll be adding complexity by specifying more DM and methods

// ALSO, WE ARE MANUALLY SPECIFYING THAT 2 CLASSES HAVE EQUAL MAILBOX IN TB
// WE CAN DO THIS BY CUSTOM CONSTRUCTOR

//-----------------------------------------------
// SPECIFYING MAILBOX WITH CUSTOM CONSTRUCTOR
//-----------------------------------------------
/*
class generator;
    int data = 12;  // single data mem // want to communicate to driver class
    mailbox mbx;  // gen2drv
    task run();  // main task calling in tb top, that will handle the process of sending data from gen to drv
        mbx.put(data);
        $display("[GEN] : SENT DATA : %0d", data);
    endtask
    
    function new(mailbox mbx); // custom constructor
        this.mbx = mbx;
    endfunction
endclass

// put() allows us to send data to another class

class driver;  // receiving data from gen
  int datac = 0;  // data container that stores the value of DM data in generator
  
  mailbox mbx;
  task run();
    mbx.get(datac);  // get data from gen class & store in data container
     $display("[DRV] : RCVD DATA : %0d", datac);
  endtask  
  
  function new(mailbox mbx); // custom constructor
        this.mbx = mbx;
    endfunction
endclass

module mailbox_ex();
generator gen;
driver drv;
mailbox mbx;

initial begin
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
   
// do not need to make the mailbox of gen and drv equal to tb mailbox 
// as we are using custom constructor
//    gen.mbx = mbx;
//    drv.mbx = mbx;
    
    fork
    gen.run();
    drv.run();
    join  

    #1;
    $finish;
end
endmodule
*/

//----------------------------------------------------
// SENDING TRANSACTION  DATA WITH MAILBOX
//----------------------------------------------------
// a simple transaction class with no constraints
class transaction;
    rand bit [3:0] din1;
    rand bit [3:0] din2;
    bit [4:0] dout;
endclass

class generator;
    transaction t; // handle for transaction class
    mailbox mbx;
    function new(mailbox mbx); // custom constructor
        this.mbx = mbx;
    endfunction
    
    task main();
        for(int i = 0; i<10; i++)begin
            t = new();  // constructor for transaction // remember- create a new object for each transaction
            assert(t.randomize()) else begin
            $display("Randomization failed");
            end
            $display("[GEN] : SENT DATA : din1 = %0d and din2 = %0d", t.din1, t.din2);
            mbx.put(t); // put method to send data from gen to drv
            #10;
        end
    endtask    
endclass

class driver;
    transaction dc;  // data container holding data received from gen
    mailbox mbx;
    function new(mailbox mbx); // custom constructor
        this.mbx = mbx;
    endfunction
    
    task main();
        forever begin
            mbx.get(dc);
            $display("[DRV] : RCVD DATA : din1 = %0d and din2 = %0d", dc.din1, dc.din2);
            #10;
        end
    endtask
endclass

module mailbox_ex();
generator gen;
driver drv;
mailbox mbx;

initial begin
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
       
    fork
    gen.main();
    drv.main();
    join  

    #1;
    $finish;
end
endmodule

// remember this complete process

