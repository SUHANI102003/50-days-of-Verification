/*
--------------------------------------------------------------------
                            QUEUES
-------------------------------------------------------------------- 
1. A SystemVerilog queue is a First In First Out scheme which can have a variable size to store elements of the same data type.

2. It is similar to a one-dimensional unpacked array that grows and shrinks automatically. 
*/

module queue;
  
  //declaration
  int q1[$];  // unbounded (unlimited size) queue of int type
  int q2[$];
  bit [3:0] q[$];
  logic [7:0]  elements [$:127];     // A bounded queue of 8-bits with maximum size of 128 slots
  
  
  initial begin
    
    // initialize the queue
    q1 = {1,2,3,4,5};
    $display("Contents of q1: %0p", q1);
    
    
    //----------------------------------------------------------------
    //             OPERATIONS ON QUEUE
    //----------------------------------------------------------------
    
    // insert a new element or push data in front i.e 0th index
    q1.push_front(7);
    $display("Contents of q1 after push at front: %0p", q1);
    
    // insert a new element or push data in back i.e last index 
    q1.push_back(9);
    $display("Contents of q1 after push at back: %0p", q1);
    
    // insert a new element at a specific index
    q1.insert(3,4);              // insert elm 3 at index 4
    $display("Contents of q1 after push at index 4: %0p", q1);
    
    // remove element from index 0 or pop the element from front
    q1.pop_front();
    $display("Contents of q1 after pop at front: %0p", q1);
    
    // remove element or pop data in back i.e last index 
    q1.pop_back();
    $display("Contents of q1 after pop at back: %0p", q1);
    
    // remove element at a specific index
    q1.delete(1);              // remove elm  at index 1
    $display("Contents of q1 after push at index 4: %0p", q1);
    
    // sliced queue
    // print the elements in queue from index 1 to 3
    $display("Content of queue at index [1:3] is %0p", q1[1:3]);
    
    // print the elements in queue from index 1 to end
    $display("Content of queue at index [1:$] is %0p", q1[1:$]);
    
    
    //---------------------------------------------------------------------
    //               OPERATIONS BETWEEN 2 QUEUES
    //---------------------------------------------------------------------
    
    // copy q1 to q2
    q2 = q1;
    $display("Contents of q2 are: %0p", q2);  // 1 4 3 4 5
    
    // append q2 with 1
    q2 = {q2,1};  
    $display("Contents of q2 after appending are: %0p", q2);
    
    // add q2 with 11 at front
    q2 = {11,q2};  
    $display("Contents of q2 are: %0p", q2);
    
    //delete the last item
    q2 = q2[0:$-1];
    $display("Contents of q2 after delete are: %0p", q2);
  end

endmodule
