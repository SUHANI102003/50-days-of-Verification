/*
----------------------------------------------------------------------------------
                              INHERITANCE
----------------------------------------------------------------------------------
               EXTENDING CLASS PROPERTIES BY INHERITANCE
----------------------------------------------------------------------------------
Inheritance in SystemVerilog (like in other OOP languages) is a mechanism by which a child class (also called a derived class) inherits properties (data members) and methods (functions/tasks) from a parent class (also called a base class).

Inheritance allows one class (child) to reuse, extend, or override the functionality of another class (parent).

why do we do it?

The idea behind this scheme is to allow developers add in new properties and methods into the new class while still maintaining access to the original class members. This allows us to make modifications without touching the base class at all.

ex. while generating stimulus for dut in generator class, we might want to inject some error into stimulus to check the behaviour or might want to compute 
intermediate data- just to debug whether stimus is correctly going to dut. To do this we inherit the parent class properties into child/extended class and modufy child class without touching the parent class.

here child class can redefine parent methods
*/

class first;                      // parent class
  int data = 12;
  
  function void display();
    $display("value of data : %0d", data);
  endfunction
endclass

class second extends first;            // child class -- extension of parent class
  int temp = 34;                       // this class has access to all data members(data) and methods(func display) of parent class
  
  function void add();
    $display("Value of child data mem after processing: temp : %0d",temp+4);
  endfunction
endclass

module tb;
  
  second s;  // handler of child class
  
  initial begin
    s = new();        // object of child class
    
    $display("value of data = %0d", s.data);    // accessing data member of parent through child  // 12
    s.display();                                // accessing methods of parent through child      // 12
    
    // now lets see if we can change a data member of child class  -- un-comment the method in child class
    
    $display("value of temp = %0d", s.temp);    // accessing data member of child class  // 34
    s.add();                                // accessing methods of child class       // 38
  end
  
endmodule

// therefore, instead of creating a instance of class first in class second (what we have been doing till now) -- create an inheritance of it by using //extended class
