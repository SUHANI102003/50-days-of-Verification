//class is a user-defined datatype, an OOP construct, that can be used to encapsulate data (property) and tasks/functions
//(methods) which operate on the data. 
/*
class first;                // declaration of a class
  
  // data members
  bit [2:0] data;
  bit [1:0] data2;
  
endclass

// to utilize a class in module, create a handler first

module tb;
  first f1;   // handler of class  // does'nt create object
  
// A class variable such as f1 is only a name by which that object is known. 
//It can hold the handle to an object of class first, but until assigned with something it is always null. 
//At this point, the class object does not exist yet.

  initial begin
    
    if(f1 == null)begin
      $display ("first handle 'f1' is null");
    end
    
 // so if we try to access data members of class =---- compile error  "Null pointer access"
  
  // access data members   
  f1.data = 3'b001;
    $display("data : %b",f1.data); // Null pointer access
    
 
  end
endmodule
*/

// Therefore, with just a handler , object is not created



//----------------------------------------------------------------------------------
// ADD A CONSTRUCTOR TO HANDLE
//---------------------------------------------------------------------------------
//An instance of that class is created only when it's new() function is invoked. 
//To reference that particular object again, we need to assign it's handle to a variable of type first.


class first;                // declaration of a class
  
  // data members
  bit [2:0] data;
  bit [1:0] data2;
  
endclass

module tb;
  first f1; // handler for class first (doesn't create object)
//The handle is used to create, modify, and call functions of the object.
//It's a variable of class type that stores the memory address of the object.
  
  
  initial begin
    
    f1 = new();     // added constructor to handle // memory allocated to class methods and data mem  // created an object 
    
//An object is a runtime instance of a class. 
//When you create an object, you are allocating memory and accessing the class's methods and properties through it.
    
    
    
    // now we can access data members of class
    
    f1.data = 3'b101;
    f1.data2 = 2'b01;
    $display("data: %b, data2: %b", f1.data, f1.data2);   // worked fine
    
    // to deallocate a class after its not further required
	//	f1 = null;
    // object deleted; cannot access class 
    
  end
  
endmodule






