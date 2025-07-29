//--------------------------------------------------------------
//           USING CLASS IN A CLASS (CLASS COMPOSITION)
//--------------------------------------------------------------

// Needed as we will be dividing our TB into small components
// Abstract classes connecting multiple classes together


// first class
class first;
  
  int data = 0;
  
  task display();
    $display("data: %0d", data);
  endtask
  
endclass


// second class
class second;
  first f1; // create handler for class first
  
  function new();       // ALWAYS CALL THE new() METHOD WHEN CONSTRUCTING A CLASS & CALLING ANOTHER CLASS
    f1 = new();         
  endfunction
  
endclass


module tb;
  
  second s; // handler for class second
  
  initial begin
    s = new();        // object for class second
    
    $display("Value of data in class first: %0d", s.f1.data); 
    
    s.f1.display(); // call first class through second
    
    //edit data of first class
    s.f1.data = 45;
    s.f1.display();
  end
  
endmodule

//first object is contained within the second object, not directly — but via a handle (f1) that is initialized inside second's constructor.
