`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
/*
//---------------------------------------
module add(
// a simple adder design module
input [3:0] a,b,
output [4:0] sum
    );
assign sum = a+b;
endmodule
//--------------------------------------
interface add_if;
    logic [3:0] a,b;
    logic [4:0] sum;
endinterface
*/
//---------------------------------------
/*
module tb_interface();
add_if aif(); // instance of interface // remember to add parenthesis

// positional naming
add dut (aif.a, aif.b, aif.sum);
//or named 
//add dut (.a(aif.a), .b(aif.b), .sum(aif.sum));

initial begin
    aif.a = 4;
    aif.b = 6;
    #10;
    aif.a = 2;
    #10;
    aif.b = 8;
end

initial begin
   $monitor("a: %d, b: %d, sum: %d", aif.a, aif.b, aif.sum); 
end
endmodule
*/
//----------------------------------------------------------------
//---------------------------------------------------------------
//----------------------------------------------------------------
/*
// LETS SEE WHAT HAPPENS WITH BLOCKING ASSIGNMEMT  -- GO TO TB
module add(
input clk,
input [3:0] a,b,
output reg [4:0] sum
    );
always@(posedge clk) begin
    sum <= a+b;
end
endmodule

interface add_if;
    logic clk;
    logic [3:0] a,b;
    logic [4:0] sum;
endinterface
*/
/*
module tb_interface();
add_if aif(); // instance of interface // remember to add parenthesis

// positional naming
//add dut (aif.a, aif.b, aif.sum);
//or named 
add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

initial begin
    aif.clk = 0;
end

always #10 aif.clk = ~aif.clk;

initial begin
    aif.a = 1;
    aif.b = 5;
    #22;
    aif.a = 3;
    #20;
    aif.a = 4;
    #8;
    aif.a = 5;
    #20;
    aif.a = 6;
end

initial begin
   #100;
   $finish; 
end

initial $monitor ("a:%0d, b:%0d, sum: %0d", aif.a, aif.b, aif.sum);

// in this some values may get dropped b/c of blocking operator in waveform
//a:4, b:5, sum: 8
// here value of sum=9 gets dropped
endmodule
*/

//-----------------------------------------------------
// LETS SEE WITH NON BLOCKING OPERATOR
//-----------------------------------------------------
/*
module tb_interface();
add_if aif(); 

add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

initial begin
    aif.clk = 0;
end

always #10 aif.clk = ~aif.clk;

initial begin
    aif.a <= 1;
    aif.b <= 5;
    #22;
    aif.a <= 3;
    #20;
    aif.a <= 4;
    #8;
    aif.a <= 5;
    #20;
    aif.a <= 6;
end

initial begin
   #100;
   $finish; 
end
// values not dropped here 
initial $monitor ("a:%0d, b:%0d, sum: %0d", aif.a, aif.b, aif.sum);
endmodule
*/


//-----------------------------------------------------------------
//   ADDING DRIVER CODE TO INTERFACE
//------------------------------------------------------------------
// typical format that we will follow 
//---------------------------------------------------------------

class driver;
    virtual add_if aif; // add virtual keyword before instance // here parenthesis not needed
    // virtual means behaviour/definition of interface is defined outside the class
    // right now, we're not adding custom cons as we do not have gen, transaction , etc
    // we/ll add those later
    // this is a simple driver class
    task run();
        forever begin
            @(posedge aif.clk);
            aif.a <= 3;
            aif.b <= 3;
        end
    endtask
    endclass
    
module tb_interface();
add_if aif(); 

add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));
driver drv;

initial begin
    aif.clk = 0;
end

always #10 aif.clk = ~aif.clk;

initial begin
    drv = new();
    drv.aif = aif;  // connecting the 2 interface
    drv.run();
end

initial begin
   #100;
   $finish; 
end


endmodule
