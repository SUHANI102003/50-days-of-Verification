/*
--------------------------------------------------------------
                       POLYMORPHISM
--------------------------------------------------------------   
A handle can act as a paraent class handle as well as child class handle at a time
*/


// lets take an example, then we'll move towards polymorphism concept
/*
class parent;
  function int add(input int a,input int b);
    add = a+b;
    $display("sum (parent) : %0d", add);
  endfunction
endclass

class child extends parent;
  function int add(input int x,input int y);
    add = x+y;
    $display("sum (child) : %0d", add);
  endfunction
endclass

module tb;
  parent ph;
  child ch;
  
  initial begin
    ph = new();
    ch = new();
    
    //ch = ph;    // assigning paret class handle to child class  // ERROR
    //Incompatible types at assignment: .ch<child> <- ph<parent>." "testbench.sv" 
    
    // WE CANNOT ASSIGN PARENT CLASS HANDLE TO CHILD CLASS HANDLE --- ILLEGAL IN SV
    
    ph = ch;  // NO ERROR
    // WE CAN ONLY ASSIGN CHILD CLASS HANDLE TO PARENT CLASS HANDLE
    // Now, parent handle points to child handle
    ph.add(2,3); // which methid will be called??? parent or child class??
    // PARENT CLASS METHOD WAS EXCECUTED
    // even though my parent is pointing towards child
    ch.add(2,3);  
    // CHILD CLASS METHOD EXCECUTED
  end
  
endmodule
*/
//------------------------------------------------------------------------------
// therefore to use child class method we will use a keyword called "VIRTUAL"
// used to prevent the overriding of methods of derived class

class parent;
  virtual function void display();    
    $display("(parent)");
  endfunction
endclass

class child extends parent;
   function void display() ;    
    $display("(child)");
  endfunction
endclass

module tb;
  parent ph;
  child ch;
  
  initial begin
    ph = new();
    ch = new();
    ph.display();
	ch.display();

    ph = ch; 
        ph.display();    // child method excecuted // polymorphism
// parent class handle acts as child class handle
	 ch.display();
  end
  
endmodule

// MAKE ALL THE METHODS IN PARENT CLASS AS VIRTUAL
