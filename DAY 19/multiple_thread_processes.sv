`timescale 1ns / 1ps

/*
module multiple_thread_processes;
event done;
int data1, data2;  // data 1 = random value,  data 2 = taking that value
int i=0;

initial begin  // lrts assume this initial block is generator
// we'll see how we make generator, transaction , driver ,etc later

    for(i=0; i<10;i++) begin  // so, generate a value and updaye the data member
        data1 = $urandom();  // generated & stored RV in data1
        #10;
    end
// after generating the stimulus, we will trigger the event done => completed entire process
// of generation of random stimulus
-> done;
end


initial begin  // lets assume this initial block is my driver// continously receive data from generator
    forever begin
        #10;  // as data is being generated at 10ns, so wait for it
        data2 = data1;  // reading data1 and storing in data2
        $display("data received = %0d", data2);
    end
end

// now both these blocks do not know when to stop simulation, so we will declare another
// block ; independent task for that -- to keep track

initial begin
    wait(done.triggered);   // this will hold our simulation till we receive a trigger
    $finish;
end
endmodule
*/
// THIS IS A SIMPLIFIED VERSION TO EXCECUTE MULTIPLE PROCESSES IN PARALLEL, USING 
// INDEPENDENT INITIAL BLOCKS




// THE PROBLEM??
// LRM DOES NOT SPECIFY THE PRIORITY OF INITIAL BLOCKS
// THEREFORE, SOLUTION
// FORK JOIN

// use within procedural blocks
// allows all excecution from 0ns
// allows multiple processes specified in it to excecute in parallel

//types:
//1. fork join none
//2. fork join any
//3. fork join

//-------------------------------------------------------
// FORK JOIN
//-------------------------------------------------------

// all excecute in parallel
// will not allow statements written after join to excecute until the statements
// inside fork join are completed
/*
module multiple_thread_processes;
    int i = 0;
    bit [7:0] data1, data2;
    event next;
    event done;
    
    task generator();
        for(i=0; i<10;i++) begin  // so, generate a value and updaye the data member
        data1 = $urandom();  // generated & stored RV in data1
        $display("Data sent : %0d", data1);
        #10;
        wait(next.triggered);  // notify when to send next sample // wait for triggger from driver
    end
    ->done;
    endtask
    
    task driver();
    forever begin
        #10;
        data2 = data1;
        $display("Data received: %0d", data2);
        ->next;  // notify generator to send next sample
        end
    endtask
    
    task wait_event();
        wait(done.triggered);
        $display("Completed sending all stimulus");
        $finish;
    endtask
    
    initial begin
        fork                      // all excecuted at 0ns  // so order does't manner
            generator();
            driver();
            wait_event();
        join
     // no race condition with fork join   
    end
endmodule
*/
// lets look at one more ex
/*
module multiple_thread_processes;
    task first();
        $display("TASK 1 started at %0t", $time);  // 0ns
        #20;
        $display("TASK 1 completed at %0t", $time);  // 20ns
    endtask
    
    task second();
        $display("TASK 2 started at %0t", $time);  // 0ns
        #30;
        $display("TASK 2 completed at %0t", $time);  // 30ns
    endtask
    
    task third();
        $display("Reached next to join at %0t", $time);  // 30ns
    endtask
    
    initial begin
        fork
            first();
            second();
        join
        third();   // not excecuted until fork join
    end
endmodule
*/

//--------------------------------------------------
//  FORK JOIN ANY
//---------------------------------------------------
// as soon as one of the processes is complete, it will allow us to excecute the processes after join 
/*
module multiple_thread_processes;
    task first();
        $display("TASK 1 started at %0t", $time);  // 0ns
        #20;
        $display("TASK 1 completed at %0t", $time);  // 20ns
    endtask
    
    task second();
        $display("TASK 2 started at %0t", $time);  // 0ns
        #30;
        $display("TASK 2 completed at %0t", $time);  // 30ns
    endtask
    
    task third();
        $display("Reached next to join at %0t", $time);  // 20ns
    endtask
    
    initial begin
        fork
            first();
            second();
        join_any
        third();   // not excecuted until fork join
    end
endmodule
*/

//------------------------------------
// FORK JOIN NONE
//-------------------------------------
// purely non blocking
//wo't wait for any of the processes to complete
// i.e will excecute the process after join_none , even if none of the process inside fork is completed

module multiple_thread_processes;
    task first();
        $display("TASK 1 started at %0t", $time);  // 0ns
        #20;
        $display("TASK 1 completed at %0t", $time);  // 20ns
    endtask
    
    task second();
        $display("TASK 2 started at %0t", $time);  // 0ns
        #30;
        $display("TASK 2 completed at %0t", $time);  // 30ns
    endtask
    
    task third();
        $display("Reached next to join at %0t", $time);  // 0ns
    endtask
    
    initial begin
        fork
            first();
            second();
        join_none
        third();   // not excecuted until fork join
    end
endmodule