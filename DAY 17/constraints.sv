`timescale 1ns / 1ps

//----------------------------------------
//             CONSTRAINTS
//----------------------------------------
// can be external or internal in a class

//  INTERNALLY (mainly used)
/*
class generator;
randc bit [3:0] a,b;
bit [3:0] y;

constraint data_a {a>3 ; a<7;}
constraint data_b {b==3;}
endclass
module constraints();
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
*/

//-------------------------------------
// EXTERNALLY (use extern keyword)
//--------------------------------------
// can also use extern keyword to define a function outside class
/*
class generator;
randc bit [3:0] a,b;
bit [3:0] y;

extern constraint data;
endclass

constraint generator :: data {a>3 ; a<7; b>0;}
module constraints();
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
*/

// ---------------------------------------------
//    RANGES IN CONSTRAINT (USE inside keyword)
//----------------------------------------------
/*
class generator;
randc bit [3:0] a,b;
bit [3:0] y;

constraint data {a inside {[0:8], [10:11], 15}; 
                 b inside {[3:14]};}
endclass
*/
//--------------------------------------------
//  skip certain values (! operator)
//--------------------------------------
/*
class generator;
randc bit [3:0] a,b;
bit [3:0] y;

constraint data {a inside {[0:8], [10:11], 15}; 
                 !(b inside {[3:14]});}

endclass
*/

//--------------------------------------------------
// Pre and Post randomization methods
//--------------------------------------------------

// processing prior to randomization - pre_randomize()
// processing after  randomization - post_randomize()
/*
class generator;
randc bit [3:0] a,b;
bit [3:0] y;
int min ,max;

function void pre_set(input int min, input int max);
this.min = min;
this.max = max;
endfunction

constraint data {a inside {[min:max]}; b inside {[min:max]};}

function void post_randomize();
$display("value of a : %0d, b : %0d", a,b);
endfunction
endclass


module constraints();
generator g;
  int i = 0;
   
  initial begin
    
    for (i = 0; i<10; i++)begin
      g = new();  // constructor inside for loop
      g.pre_set(2,8);
      g.randomize();
      // post randomization automatically called after successfull randomization
      #10;
  end
  end
endmodule
*/

//-------------------------------------------------------
//                 WEIGHTED DISTRIBUTION
// WHEN WE WANT A SIGNAL TO OCCUR MORE OFTEN THAN OTHERS
//-------------------------------------------------------
// := 'or' :/ operator with 'dist' keyword
//-------------------------------------------------------
// when we work with indivisual values, both operater gives same result
// but in ranges, behaves different
//----------------------------------------------------------
/*
class first;
 rand bit wr; // :=
 rand bit rd; // :/
 
 constraint cntrl {wr dist {0 := 30 , 1:= 70};
                   rd dist {0 :/ 30 , 1:/ 70};}
endclass
// 30% of 0's and 70% of 1's
module constraints();
first f;
  int i = 0;
   
  initial begin
    
    for (i = 0; i<10; i++)begin
      f = new();  // constructor inside for loop
      f.randomize();
      $display("value of wr: %0d and rd : %0d", f.wr, f.rd);
      #10;
  end
  end
endmodule
*/
// := operator
// assigns equal weight to all values inside range

// :/ operator
// divides weight equally to all values inside range
/*
class first;
 rand bit [1:0] var1; // :=
 rand bit [1:0] var2; // :/
 
 constraint cntrl {var1 dist {0 := 30 , [1:3]:= 90};   // 0 = 30, 1= 90, 2 = 90, 3 = 90 // equal distribution
                   var2 dist {0 :/ 30 , [1:3]:/ 90};} // 0 = 30, 1= 90/3, 2 = 90/3, 3 = 90/3 // divided equal distribution
endclass
// 30% of 0's and 70% of 1's
module constraints();
first f;
  int i = 0;
   
  initial begin
    
    for (i = 0; i<10; i++)begin
      f = new();  // constructor inside for loop
      f.randomize();
      $display("value of var1: %0d and var2 : %0d", f.var1, f.var2);
      #10;
  end
  end
endmodule
*/

//------------------------------------------
//              CONSTRAINT OPERATORS
//         to add complexity to constraints
//-------------------------------------------
// 1. IMPLICATION OPERATOR (->)
/*
class generator;
randc bit [3:0] a,b;
rand bit ce;
rand bit rst;

constraint ctrl_rst {rst dist {0:= 80, 1:=20};}
constraint ctrl_ce {ce dist {1:= 80, 0:=20};}
constraint ctrl_rst_ce {(rst==0) -> (ce==1);}
// means
// when reset is 0 then ce should be 1
// does not specify what happens if rst is 1
// if rst = 1 , then ce can be either 0 or 1
endclass

module constraints();
generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    
    for (i = 0; i<10; i++)begin
      g = new();  // constructor inside for loop
      assert(g.randomize()) else begin
      $display("Randomization failed");
      $finish;
      end
      $display("value of rst: %0d, ce: %0d ", g.rst, g.ce);
      #10;
  end
  end
endmodule
*/

//----------------------------------------
// 2. EQUIVALENCE OPERATOR (<->)
//----------------------------------------
/*
class generator;
randc bit [3:0] a,b;
rand bit wr;
rand bit oe;

constraint ctrl_wr {wr dist {0:= 50, 1:=50};}
constraint ctrl_oe {oe dist {1:= 50, 0:=50};}
constraint ctrl_wr_oe {(wr==1) <-> (oe==0);}
// means
// when wr is 0, then oe should be 1
// and if wr = 1 , then oe should be 0 
//((wr == 1) && (oe == 0)) || ((wr == 0) && (oe == 1))
endclass

module constraints();
generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    
    for (i = 0; i<10; i++)begin
      g = new();  // constructor inside for loop
      assert(g.randomize()) else begin
      $display("Randomization failed");
      $finish;
      end
      $display("value of wr: %0d, oe: %0d ", g.wr, g.oe);
      #10;
  end
  end
endmodule
*/

//----------------------------------
// 3. if else
//-------------------------------------
/*
class generator;
randc bit [3:0] raddr,waddr;
rand bit wr;
rand bit oe;

constraint ctrl_wr {wr dist {0:= 50, 1:=50};}
constraint ctrl_oe {oe dist {1:= 50, 0:=50};}
constraint ctrl_wr_oe {(wr==1) <-> (oe==0);}
constraint write {
    if(wr==1){
        waddr inside {[11:15]};
        raddr ==0;
    }
    else {
        waddr == 0;
        raddr inside {[11:15]};
    }

}
endclass

module constraints();
generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    
    for (i = 0; i<10; i++)begin
      g = new();  // constructor inside for loop
      assert(g.randomize()) else begin
      $display("Randomization failed");
      $finish;
      end
      $display("value of wr: %0d, oe: %0d ", g.wr, g.oe);
      #10;
  end
  end
endmodule
*/

//----------------------------------------
// TURNING ON AND OFF CONSTRAINTS
//----------------------------------------
class generator;
randc bit [3:0] a,b;
rand bit ce;
rand bit rst;

constraint ctrl_rst {rst dist {0:= 80, 1:=20};}
constraint ctrl_ce {ce dist {1:= 80, 0:=20};}
constraint ctrl_rst_ce {(rst==0) -> (ce==1);}
endclass

module constraints();
generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new(); 
    
      g.ctrl_rst_ce.constraint_mode(0);  // 0: disable; 1: enable
      $display("constraint status ctrl_rst : %0d", g.ctrl_rst.constraint_mode());
      
      for (i = 0; i<20; i++)begin
      assert(g.randomize()) else begin
      $display("Randomization failed");
      $finish;
      end
      $display("value of rst: %0d, ce: %0d ", g.rst, g.ce);
      #10;
  end
  end
endmodule
