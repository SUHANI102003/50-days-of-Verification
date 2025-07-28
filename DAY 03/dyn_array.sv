/*
--------------------------------------------------------------
//                DYNAMIC ARRAYS
//------------------------------------------------------------

1. A dynamic array is an unpacked array whose size can be set or changed at 'run time', and hence is quite different from a static array where the size is pre-determined during declaration of the array. 

2. The default size of a dynamic array is zero until it is set by the new[] constructor.

3. The new() function is used to allocate a size for the array and initialize its elements if required.

*/

module dyn_assoc_array;
 
  // declaration
  int arr[];          // do not need to specify the size.
  int arr_fixed[10];
  
  initial begin
    
    //     arr = new[];                    // compile error as the array is empty
    //     $display("arr : %0p", arr);
    
    arr = new[5];  //declare size of array
    
    //initialize the array
    for (int i =0; i<5 ;i++)begin
      arr[i] = 5*i;
    end
    $display("arr conents : %0p", arr);
    
  

  
//------------------------------------------------------------------
//             OPERATIONS ON DYNAMIC ARRAY
//------------------------------------------------------------------
  
  // print size of dynamic array
  $display("arr size : %0d", arr.size());
  
  
  // change the size of array during runtime
  //arr = new[10];                              // this will override the previous contents of array, so they will be lost
  
  // keep the original contents of array when increasing the size
  arr = new[10](arr);
  $display("arr size : %0d", arr.size());
  $display("arr conents : %0p \n", arr);
  
    
  // copy dynamic array to fixed array
    // only possible if size is same
    // int arr_fixed[10]
    
    arr_fixed = arr;
    $display("arr_fixed conents : %0p \n", arr_fixed);
    
    
    //delete the array
    arr.delete();   // do not run after delete as array is empty- compile error
    $display("arr conents after deletion: %0p \n", arr);
    
  end  
endmodule
