/*
Sometimes, we may want to keep the original data as it is, and utilize a copy of it for processing on data members or methods.

We can do this by creating 2 handles and then transferring the original object to the copy opject
*/

// ------------------------------------------------------------
//                   COPYING OBJECTS
//-------------------------------------------------------------

//--------------------------------------------------------------
//                       METHOD 1 
//--------------------------------------------------------------
/*
class first;
  int data = 0;
endclass

module tb;
  first f1;   // original handle
  first f2;   // copy handle
  
  initial begin
    
    f1 = new();  // origibal object created /// 1. implicit constructor
    
    f1.data = 23;   // 2. processing
    $display("Original data: %0d", f1.data);
// want to keep the class object untouched; instead want a copy of this data which i can sent to another class for processing.
// S0 INSTEAD OF SENDING ORIGINAL DATA FOR PROCESSING IN OTHER CLASSES, I WILL SEND A COPY OF IT
    
    f2 = new f1; // 3. copying data from f1 to f2   
    $display("Copied data: %0d", f2.data);    // i am accessing data using f2 handle
    f2.data = 12;                      // prosessing using f2 handle
    $display("Copied data after processing: %0d", f2.data);   // accessing data through f2 handle
    
    // f2 IS JUST A COPY OF OBJECT f1. IF WE CHANGE THE VALUE OF DATA USING f2, THE CHANGE WILL NOT REFLECT IN ORIGINAL COPY
    
    $display("data : %0d", f1.data);  // ouput = 23 only ;; even though i modified data to 12 using f2 handle(copy)
    
  end
endmodule

// the above example is using SHALLOW COPY method.

// BUT IN THIS EXAMPLE IT IS BEHAVING AS DEEP COPY AS - 
//Your class first contains only a primitive variable (int data).
//So, even in a shallow copy, that primitive value is copied by value, not by reference.
//Therefore, f1 and f2 point to two different objects, each with its own independent data.

*/


//-------------------------------------------------------------------------------------------
//                                    METHOD 2 
//                            CUSTOM COPY METHOD (PREFERRED)
//              preferred if you have a single class and few data members 
//-------------------------------------------------------------------------------------------

class first;
  int data = 12;
  bit [7:0] temp = 8'h11;
  
  function first copy();        // function class_name func_name();  // create a function then add a constructor to function name
    copy = new();              // constructor to function  (deep copy)
    copy.data = data;
    copy.temp = temp;
  endfunction
endclass

module tb;
  first f1;    // original handler
  first f2;    // copy handler
  
  initial begin
    f1 = new();   // object f1
    f2 = new();   // object f2
    
    f2 = f1.copy();  // 
    $display("data : %0d, temp : %0d", f2.data, f2.temp);
    
    f2.data = 13;
    $display("data : %0d, temp : %0d", f2.data, f2.temp);   // data updated and change in f2 object (copy)
    $display("data : %0d, temp : %0d", f1.data, f1.temp);   // change not reflected in f1 object    (original)
  end
  // THIS IS ALSO CALLED DEEP COPY
endmodule


//----------------------------------------------------------------------------------------
// NEXT WE'LL SEE SHALLOW COPY AND DEEP COPY
// when we have both data members and other instance of class 
//----------------------------------------------------------------------------------------
