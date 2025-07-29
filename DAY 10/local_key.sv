/*
--------------------------------------------------------
                 local KEYWORD
-------------------------------------------------------
A member declared as local is available only to the methods of the same class, and are not accessible by child classes. However, nonlocal methods that access local members can be inherited and overridden by child class.
*/


/*
class first;
  
  local int data = 0;              // we want to keep data local to class // data cannot be accessed by any other class
  
  task display();
    $display("data: %0d", data);
  endtask
  
endclass


// second class
class second;
  first f1; // create handler for class first
  
  function new();       
    f1 = new();         
  endfunction
  
endclass


module tb;
  
  second s; // handler for class second
  
  initial begin
    s = new();        // object for class second
    
    $display("Value of data in class first: %0d", s.f1.data);  
    
    //"Cannot access local/protected member ""s.f1.data"" from this scope." "testbench.sv" 39  60
    
    s.f1.display(); // this will work as task is nonlocal
    
    
    s.f1.data = 45;             // ERROR
    
  end
  
endmodule
*/


//---------------------------------------------------------------------------------------------------
// BUT SOMETIMES A CLASS MAY WANT TO ACCESS THE PROTECTED/LOCAL DATA IN ANOTHER CLASS -- WHAT TO DO??
//---------------------------------------------------------------------------------------------------

//ANS- WE PROVIDE A METHOD TO THEM. THIS METHOD CAN BE ACCESSED BY OTHER CLASSES

class first;
  
  local int data = 0;              // we want to keep data local to class // data cannot be accessed by any other class
  
  task display();
    $display("data: %0d", data);
  endtask
  
  task set(input int data);         //  pass local data to method
    this.data = data; 
  endtask
  
  function int get();           // get the data value
    return data;
  endfunction
  
endclass


// second class
class second;
  first f1; // create handler for class first
  
  function new();       
    f1 = new();         
  endfunction
  
endclass


module tb;
  
  second s; // handler for class second
  
  initial begin
    s = new();        // object for class second
    
    //$display("Value of data in class first: %0d", s.f1.data);  
    
    //"Cannot access local/protected member ""s.f1.data"" from this scope." "testbench.sv" 39  60
    
    s.f1.display(); // this will work as task is nonlocal
    
    // to update data value , we can do so by calling task
    
    s.f1.set(123);
    $display("data: %0d", s.f1.get());    // 123
         // or
    //s.f1.display();
              
  end
  
endmodule
