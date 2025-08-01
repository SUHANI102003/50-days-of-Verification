`timescale 1ns / 1ps

//---------------------------------------------
//             INTERFACE
//---------------------------------------------
// data from driver needs to be applied to DUT 
// done using interface
// can control the direction of variables present in interface -- modport
// class <-> signals
// tells how class communicates with dut
// driver - class (oops) & dut (a black box with only signals known)


//----------------------------------------------------------------
//DUT
/*
module add(
// a simple adder design module
input [3:0] a,b,
output [4:0] sum
    );
assign sum = a+b;
endmodule
*/
// interface will have collection of all ports present in module
// keep the port name & size exactly same
// always use 'logic' datatype
// why? because it supports both procedural & continous assignmets
// also, logic is bidirectional
/*
interface add_if;
    logic [3:0] a,b;
    logic [4:0] sum;
endinterface
*/
// now we have dut and we have interface
// but there is no connection between them.
// we need to:
// apply value to interface -> travel to dut ports -> receive response from dut
// now to to tb file



//-------------------------------------------------------------
//-------------------------------------------------------------
// NOW WE PREFER TO GO WITH NON BLOCKING ASSIGNMENTS IN INTERFACE in TESTBENCH
//------------------------------------------------------------------
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
/*
interface add_if;
    logic clk;
    logic [3:0] a,b;
    logic [4:0] sum;
endinterface
*/
// --------------------------------------------
//        MODPORT
//---------------------------------------------
// helps us prevent wiring errors
// NOTE:
// driver class=> capturing i/p (never drive o/p signal
// monitor class=> capturing o/p (never drive i/p signal
// to prevent incorrect triggering/wiring == modport
// specifies direction for signal in specific class

interface add_if;
    logic clk;
    logic [3:0] a,b;   // all these are bidirectional (can write to & read from)
    logic [4:0] sum;
    
    modport DRV (output a,b, input clk, sum);
endinterface

// for driver -- sent out the values of a and b 
// therefore, a & b output direction
// rest ports - input


