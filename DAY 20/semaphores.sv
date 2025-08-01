`timescale 1ns / 1ps

//-------------------------------------------
//                SEMAPHORE
//--------------------------------------------

//TO ACCESS RESOURCES OF TB TOP
//  2 WAYS : get() and put()
//ex. to access an interface
// ex. get-> specified class receives a semaphore so that it can access a resource
//  after completing operation, you 'put' back or release semaphore

// since we have not covered interface, accessing interface is not a good idea
// we will assume we have one of our data sources where multiple classes try to add data

class first;
    rand int data;
    constraint data_c {data<10; data>0;}
endclass

class second;
    rand int data;
    constraint data_c {data<10; data>0;}
endclass

// both classes have same data & same constraint

class main;
    semaphore sem;  // use keyword semaphore // sem is user defined name
    first f;
    second s;
    
    int data; // data source that both classes are trying to access
    // both classes will be writing a value to this data member
    int i=0;
    
    task send_first();
        sem.get(1);  // semaphore access using get  // like a key that you share b/w classes
        for(i=0;i<10;i++)begin
            f.randomize();
            data = f.data;
            $display("First access semaphore & Data Sent : %0d", f.data);
            #10;
        end
        sem.put(1);  // put back semaphore so that other class can get access
        $display("semaphore unoccupied");
    endtask
    
    task send_second;
        sem.get(1);
        for(i=0;i<10;i++)begin
            s.randomize();
            data = s.data;
            $display("Second access semaphore & Data Sent : %0d", s.data);
            #10;
        end
        sem.put(1);  // put back semaphore so that other class can get access
    endtask
    // how do we declare the number of semaphores we have??
    // by adding a 'new' method to it in main task  // sem = new(1);  // single semaphore
    // which at a time could be accessed by a single class
    // semaphore --> a parameterized class  // so, requires a constructor
    
    task run();  // main task in main class
        sem = new(1);  // constructor for semaphore
        f = new();
        s = new();
        
        fork
        // excecute in parallel but we are using get and put method which are blocking in
        // nature
        // so, when we excecute send_first ,we already get access to semaphore, so 2nd need to 
        //wait until class first releases semaphore 
            send_first();  
            send_second();
        join
        $display("Both tasks completed at time: %0t", $time);
    endtask
endclass

module semaphores();
main m;
initial begin
    m = new();
    m.run();  // adds constructor for f,s,sem
end


endmodule
