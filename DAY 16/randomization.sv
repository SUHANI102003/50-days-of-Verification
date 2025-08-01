`timescale 1ns / 1ps


/////////////////////////////////////////////////
//               RANDOMIZATION
//////////////////////////////////////////////////
/*
class generator;
  //rand bit [3:0] a,b;   // data signals // generate random stimulus using rand keyword
  randc bit [3:0] a,b;
  bit [3:0] y;
endclass

module tb;
  generator g;
  int i = 0;
  initial begin
    g = new();
    /// call randomize() method
    
    for (i = 0; i<20; i++)begin
      g.randomize();
      $display("value of a: %0d, b: %0d", g.a, g.b);
      #10;
    end
  end
endmodule
*/
//we see that some values are being repeated when we use rand
// we may want completely random values
// use randc


///////////////////////////////////////////
// CHECKING IF RANDOMIZATION IS SUCCESSFUL OR NOT
//////////////////////////////////////////////////
// 1. if .. else
// 2. assert
/*
class generator;
  //rand bit [3:0] a,b;   // data signals // generate random stimulus using rand keyword
  randc bit [3:0] a,b;
  bit [3:0] y;
endclass

module tb;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    /// call randomize() method
    
    for (i = 0; i<20; i++)begin
      if(!g.randomize()) begin
      $display("failed");
      $finish;
        end
      else begin
      status = g.randomize();
        $display("value of a: %0d, b: %0d with status : %0d", g.a, g.b,status) ;
      end
      #10;
  end
  end
endmodule
*/

// using assert
/*
class generator;
  //rand bit [3:0] a,b;   // data signals // generate random stimulus using rand keyword
  randc bit [3:0] a,b;
  bit [3:0] y;
endclass

module tb;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    /// call randomize() method
    
    for (i = 0; i<20; i++)begin
      assert(g.randomize()) else begin
      $display("failed at %0t", $time);
      $finish;
      end
      $display("value of a: %0d, b: %0d ", g.a, g.b);
      #10;
  end
  end
endmodule
*/
// here we are using random delay of 10ns between each new random value
// but what if my response from layered arch testbench takes longer than 10ns
// by then my old value would have been overridden
// we don not want that

// so NEW PROCESS TO FOLLOW

// BRING THE CONSTRUCTOR INSIDE THE FOR LOOP
// this will create a new object for each iteration
// this way even if current obj takes longer time than specified delay
// no problem as the next transaction will be stored in new object ensuring 
// valid data is preserved

class generator;
  //rand bit [3:0] a,b;   // data signals // generate random stimulus using rand keyword
  randc bit [3:0] a,b;
  bit [3:0] y;
endclass

module tb;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    
    for (i = 0; i<10; i++)begin
      g = new();  // constructor inside for loop
      assert(g.randomize()) else begin
      $display("failed at %0t", $time);
      $finish;
      end
      $display("value of a: %0d, b: %0d ", g.a, g.b);
      #10;
  end
  end
endmodule

