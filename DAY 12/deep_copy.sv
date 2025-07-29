/*
-----------------------------------------------------------------
                       DEEP COPY
-----------------------------------------------------------------
A deep copy creates a completely independent copy of an object, including all nested objects or handles inside it. 
After a deep copy, changes made to the copy do not affect the original, even for nested objects.
Both handles point to the different object in memory.
-----------------------------------------------------------------

 CONCLUSION: 
 IN A CLASS -> DATA MEMBER + OTHER CLASS INSTANCE -> DEEP COPY -> COPY OF DATA MEMBER + INDEPENDENT HANDLER FOR CLASS
 
 Memory management==>
 
s1 (second object) ──+
                    |          +--> first object (f1 in s1) → data = 12 → modified to 45
                    |          
                    +--> ds = 35 → modified to 45

s2 (second object) ──+
                    |          +--> first object (f1 in s2) → data = 12 → modified to 50
                    |
                    +--> ds = 35 → modified to 50

*/

// DEEP COPY --> ADD CUSTOM CONSTRUCTOR IN EACH CLASS

class first;
  int data = 12;
  
  // copy constructor
  function first copy();
    copy = new();                // created an object where we are storing all the values of data member
    copy.data = data;         
  endfunction
endclass

class second;
  // data member
  int ds = 35;
  
  // instance of class first
  first f1;
  function new();
    f1 = new();       // object of first class created inside second class
  endfunction
  
  // copy constructor
  function second copy();
    copy = new();                // created an object where we are storing all the values of data member and handler of first class
    copy.ds = ds;     
    copy.f1 = f1.copy;           // independent instance for first class f1 handler
  endfunction
endclass

module tb;
  second s1, s2;       // s1 = org handler  //s2 = copy handler
   
  initial begin
    s1 = new();
    s2 = new();   // 2 independent objects
    
    s2 = s1.copy();   // create a copy
    
    $display("Data ds value before update (ogr obg) : %0d and from (copy obg) : %0d", s1.ds, s2.ds);   // 35 and 35 // correct as not updated
    
    // update ds value in original obj
    s1.ds = 45;
    $display("Data ds value after update in ogr obg : %0d and from (copy obg) : %0d", s1.ds, s2.ds);  // 45 and 35 // correct as change reflected only in     org object , not in copy
    
    // update ds value in copy obj
    s2.ds = 50;
    $display("Data ds value after update in copy obj (ogr obg) : %0d and from (copy obg) : %0d", s1.ds, s2.ds);  // 45 and 50 // correct as change             reflected only in copy obj , not in original
    $display("");
    
    //---------------------------------------
    // NOW LETS SEE FOR CLASS INSTANCE
    //--------------------------------------
    
    $display("Data value in first before update (ogr obg) : %0d and from (copy obg) : %0d", s1.f1.data, s2.f1.data);   // 12 and 12 // correct as not     updated
    
    // update ds value in original obj
    s1.f1.data = 45;
    $display("Data value in first after update in ogr obg : %0d and in (copy obg) : %0d", s1.f1.data, s2.f1.data);  // 45 and 12 // correct as change         reflected only in org object , not in copy
    
    // update ds value in copy obj
    s2.f1.data = 50;
    $display("Data value in first after update in copy obj (ogr obg) : %0d and in (copy obg) : %0d", s1.f1.data, s2.f1.data);  // 45 and 50 // correct as     change reflected only in copy obj , not in original
  end
endmodule
