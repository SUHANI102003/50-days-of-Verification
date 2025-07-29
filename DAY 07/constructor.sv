/*
---------------------------------------------------------------------
                           CONSTRUCTORS
---------------------------------------------------------------------

 A constructor is simply a method to create a new object of a particular class data-type.
 
 We already saw implicitly called constructor in class folder.
*/

//-------------------------------------------------------------
//                 USER DEFINED CONSTRUCTOR
//                   (explicitly called)
//-------------------------------------------------------------
/*
class first;
  int data;
  
  // using function in class to create constructor
  
  function new(input int datain = 0);           // constructor // non blocking // does not have return type
    data = datain;
  endfunction
  
endclass

module tb;
  first f1; // created handler
  
  initial begin
    f1 = new(23);   // object created using constructor // this will call the function new in class
    $display("data: %0d", f1.data);
  end
  
endmodule
*/


//---------------------------------------------------------------
// WE SEE ABOVE THAT WE ARE USING DISPLAY TO PRINT VALUES
// WE CAN INSTEAD USE A TASK
//---------------------------------------------------------------

class first;
  int data;
  
  // using function in class to create constructor
  
  function new(input int datain = 0);           // constructor // non blocking // does not have return type
    data = datain;
  endfunction
  
  task display();
    $display("DATA: %0d", data);
  endtask
  
endclass

module tb;
  first f1; // created handler
  
  initial begin
    f1 = new(23);   // object created using constructor // this will call the function new in class
   // $display("data: %0d", f1.data);
    f1.display();
  end
  
endmodule

