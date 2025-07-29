/*
-----------------------------------------------------------------
                       SHALLOW COPY
-----------------------------------------------------------------
A shallow copy is when you copy a class object’s handle (reference) to another handle without creating a new object. 
Both handles point to the same object in memory.
-----------------------------------------------------------------

 CONCLUSION: 
 IN A CLASS -> DATA MEMBER + OTHER CLASS INSTANCE -> SHALLOW COPY -> COPY OF DATA MEMBER + CLASS HANDLER FOR BOTH ORIGINAL AS WELL AS COPY REMAIN SAME
 
 ex.
f2 = f1;
You're performing a shallow copy. No new memory is allocated. Both f1 and f2 refer to the same underlying object in memory.
So, any changes made using f2 will reflect in f1, and vice versa.
*/

class first;
  int data = 12;
endclass

class second;  // will contain an instance/object of class first using constructor
  // data member
  int ds = 34;                         // when we copy content of original obj to copy obj , data mamber is also copied 
  
  // other class instance  
  first f1;
  function new();                           // this is not copied 
    f1 = new();
  endfunction
endclass

module tb;
  second s1,s2;  // 2 handlers for class second   // s1 is original // s2 is copied
  
  initial begin
    s1 = new();  // created object s1
    s1.ds = 45;    // updated obj s1 data member
    
    s2 = new s1;   // copied the obj s1 content to obj s2 
    //  both obj s1 (org) and obj s2(copy) will contain INDEPENDENT COPY OF DATA MEMBER 'ds'
    // the above can be verified as
    $display("data member in original object : %0d and in copy object : %0d", s1.ds, s2.ds);  // 45 and 45 // both contain same as we have not updated
    // update data member using obj s2
    s2.ds = 23;
    $display("data member in original object after update: %0d and in copy object after update: %0d", s1.ds, s2.ds);  // 45 and 23 // update is not            reflected in the copied obj s2 // therefore, independent copies
    
    // BUT THE ABOVE IS NOT THE SAME FOR INSTANCE OF A CLASS IN A CLASS, LET'S SEE HOW
    // NOW FOR CLASS FIRST-->
    
    $display("data member in first class before update through obj s1: %0d and in copy object s2: %0d", s1.f1.data, s2.f1.data);  // 12 and 12 as not          updated
    
    // lets update in copy obj
    s2.f1.data = 56;
    $display("data member in first class after update through obj s1: %0d and in copy object s2: %0d", s1.f1.data, s2.f1.data); 
    // 56 and 56 // both original and copy obj updated even though i only wanted to update the copy obj
    //                     THIS IS CALLED SHALLOW COPY
    // DISADVANTAGE::: BOTH THE ORIGINAL AND COPY HANDLER S1 AND S2 POINT TO THE SAME OBJECT
  end
endmodule

//------------------------------------------------------------------------------------------------------
/*
memory management == DM is independent but Handler is shared
o1 --> +------------+
       | y = 10     |
       | h -------->|-----+
                    |     |
                    | x=99|  <-- shared memory
o2 --> +------------+     |
       | y = 50     |     |
       | h -------->|-----+
*/
//--------------------------------------------------------------------------------------------------------




