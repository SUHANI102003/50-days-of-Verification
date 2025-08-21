`include "uvm_macros.svh"
import uvm_pkg::*;
//---------------------------------------------------------------------
//                       FIELD MACROS 4
//                          ARRAYS
//---------------------------------------------------------------------
/*
/////// STATIC ARRAY

1. `uvm_field_sarray_int
2. `uvm_field_sarray_object
3. `uvm_field_sarray_string
4. `uvm_field_sarray_enum

/////// DYNAMIC ARRAY

1. `uvm_field_array_int
2. `uvm_field_array_object
3. `uvm_field_array_string
4. `uvm_field_array_enum

/////// QUEUES

1. `uvm_field_queue_int
2. `uvm_field_queue_object
3. `uvm_field_queue_string
4. `uvm_field_queue_enum

/////// ASSOCIATIVE ARRAY
(string key)
1. `uvm_field_aa_int_string
2. `uvm_field_aa_object_string
3. `uvm_field_aa_string_string

(int key)  -- a series of macros ; search it 
*/

class array extends uvm_object;
  
  //////  static array
  int arr1[3] = {1,2,3};
  
  /////  dynamic array
  int arr2[];
  
  //////  queue 
  int arr3[$];
  
  /////  associative array
  int arr4[int];
  
  function new(string path = "array");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(array)
  
  `uvm_field_sarray_int(arr1, UVM_DEFAULT);
  `uvm_field_array_int(arr2, UVM_DEFAULT);
  `uvm_field_queue_int(arr3, UVM_DEFAULT);
  `uvm_field_aa_int_int(arr4, UVM_DEFAULT);
  
  `uvm_object_utils_end
  
  task run();
    //////////////////////// Dynamic array value update
    arr2 = new[3];
    arr2[0] = 2;
    arr2[1] = 2;
    arr2[2] = 2;
    
    //////////////////////// Queue
    arr3.push_front(3);
    arr3.push_front(3);
    
    ////////////////////////  Associative array
    arr4[1] = 4;
    arr4[2] = 4;
    arr4[3] = 4;
    arr4[4] = 4;
    
  endtask
endclass

/////////////////////////////////////////////////////////

module tb;
  array a;
  
  initial begin
    a = new("array");
    a.run();
    a.print();
  end
endmodule
