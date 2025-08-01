`timescale 1ns / 1ps

//-------------------------------------
//             EVENTS
//-------------------------------------
// USED TO CONVEY MESSAGES BETWEEN CLASSES (NOT DATA)
// EX. generator completed the process of sending all stimuli to dut, so stop simulation

// TO TRIGGER AN EVENT :  -> operator
// TO SENSE AN EVENT :   1. @ = edge sensitive blocking
//                       2. wait = level sensitive non blocking 

/*
module events;
event a;

initial begin
    #10;
    ->a;  // trigger event
end

initial begin
  // @(a);   'or' 
  wait(a.triggered);   // as soon as we receive the edge sensitive event i.e see a change in edge of 
   // a, we will be displaying event
   $display("Received event at %0t", $time); 
end
endmodule
*/
//--------------------------------
// @ vs wait
//--------------------------------
/*
module events;
event a1;
event a2;

initial begin
    ->a1;  // event 1 triggered
    //#10; // purposefully not adding delay in between 2 triggering events
    ->a2;  // trigger event 2
end

initial begin
    @a1;   
    $display("Event a1 triggered"); 
    @a2;   
    $display("Event a2 triggered"); 
end
endmodule
*/
// WE SEE NO OUTPUT
// WHY??
// when we trigger event a1, we probably missed sensing of a1 by @a1. since it is blocking
// in nature, it will also not trigger event a2 till a1 is sensed
// even if we add delay between even trigger , if we still dont see o/p that means again 
// missed sensing of a1.


// this is not the problem with wait as it is non blocking in nature. even if we miss sensing 
// of event a1 , a2 will be sensed
/*
module events;
event a1;
event a2;

initial begin
    ->a1;  // event 1 triggered
    //#10; // purposefully not adding delay in between 2 triggering events
    ->a2;  // trigger event 2
end

initial begin
    wait(a1.triggered);   
    $display("Event a1 triggered"); 
    wait(a2.triggered);   
    $display("Event a2 triggered"); 
end
endmodule
*/
// both event triggered

// lets make one event blocking and other non blocking & see 

module events;
event a1;
event a2;

initial begin
    ->a1;  // event 1 triggered
    #10; // purposefully not adding delay in between 2 triggering events
    ->a2;  // trigger event 2
end

initial begin
    wait(a1.triggered);   
    $display("Event a1 triggered");   
    @(a2);   
    $display("Event a2 triggered"); 
end
endmodule

// without delay , only a1 triggered 
// with delay ,  both triggered