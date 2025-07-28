/*
-----------------------------------------------------
                       ARRAYS
-----------------------------------------------------
1. FIXED(STATIC) ARRAYS
  a. Packed fixed arrays  
2. DYNAMIC ARRAYS
3. ASSOCIATIVE ARRAYS
4. QUEUES
-----------------------------------------------------
*/


module arrays;
  
//--------------------------------------------------------------------------------------
//                            Unpacked arrays 

//         can be of fixed, dynamic, associative or queues array type
//--------------------------------------------------------------------------------------
  
  
// unpacked as size declared after array name  
/*  
  //declaration
  bit arr1[4] = '{1,0,1,0};  // initialized while declaring // bit type can take only '0' or '1'
  int arr2[5];               // width = 5 , int type array
  int arr3[5];
  int arr4[6];
  byte arr5[8];              // width = 8 , byte type can take 0 or 1
  integer i =0;
  
  initial begin
    
    $display("contents of arr1 are: %0p", arr1); // initialization already done while declaring
    $display("");
    
   
    foreach(arr2[i]) begin  // initialization using loops // can also use for loop or repeat
     arr2[i] = i;
      $display("contents of arr2[%0d] are: %0d", i,arr2[i]);   // displaying the array elements separately
  	end
    $display("contents of arr2 are: %0p", arr2);           // displaying the array elements in a line
    $display("");
  	
    
//     for(i=0; i<$size(arr2); i++)begin
//       arr2[i] = i*2;
//     end
//     $display("contents of arr2 are: %0p", arr2);           
//     $display("");
    
    
//     repeat($size(arr2)) begin
//       arr2[i] = i*2;
//       i++;
//     end
//     $display("contents of arr2 are: %0p", arr2);           
//     $display("");
    
    
    arr3 = '{1,4,5,6,7};                         // initialization 2 using ' before brackets
    $display("contents of arr3 are: %0p", arr3);
    $display("");
  
    arr4 = '{6{0}};                              // initialization by concatenation // all 1st 5 elements of array are 2
    $display("contents of arr4 are: %0p", arr4);
    $display("");
  
    arr5 = '{default:4};                         //  initialization by default // all 1st 8 elements of array are 1
    $display("contents of arr5 are: %0p", arr5);
    $display("");
    
    // size of array
    $display("Size of arr1 is: %0d", $size(arr1));
    
    //update value of array
    arr3[2] = 3;
 	$display("contents of arr3 are: %0p", arr3);
    $display("-------------------------------------------------------------------------------------------");
*/    
  
  
//------------------------------------------------------------------------------------------------------------
//                                   OPERATIONS ON ARRAY
//------------------------------------------------------------------------------------------------------------  
/*    
    // copy and compare -- can only be performed if the length of both arrays are SAME
  int arr6[5];
  int arr7[5];
  integer i;
  int status;
    
  	initial begin
      
    foreach(arr6[i]) begin
      arr6[i] = i*3;
    end
    $display("contents of arr6 are: %0p", arr6);
    
    // copy the contents of arr6 to arr7
    arr7 = arr6;
    $display("contents of arr7 are: %0p", arr7);
    $display("");
    
    // compare both arr6 and arr7
      arr6[1] = 7;
      status = (arr6 == arr7);
      $display("Status of the arrays are: %0d", status); // 1: equal  , 0:not equal
      
  end  
 */
  
  //-----------------------------------------------------------------------------------------------------------
  //                     MULTI-DIMMENSIONAL UNPACKED ARRAY
  //-----------------------------------------------------------------------------------------------------------
  /*
  bit arr[2][3];  // declaration    // 2 rows , 3 columns
  integer i,j;
  
  initial begin
    foreach(arr[i])
      foreach(arr[i][j]) begin
        arr[i][j] = $urandom;
        $display("arr[%0d][%0d] = %0d", i,j,arr[i][j]);
      end
  end
*/
//----------------------------------------------------------------------------------------------------------  
//------------------------------------------------------------------------------------------------------------
//                                    PACKED ARRAYS
  
//                                  only for fixed array
//------------------------------------------------------------------------------------------------------------
  
  // dimmensions declared before the array name
  // can be of only bit or logic types
  //represents a contagious sets of bits
  //A multidimensional packed array is still a set of contiguous bits but are also segmented into smaller groups.
  
  bit [7:0] arr;          // a vector or 1D packed array  // array has 1 bit , 8 elements => 8bit size 
  bit [3:0][7:0] arr1;    // a 2D packed array    // 4 bytes // 8 bits packed into 4 groups
  bit [2:0][3:0][7:0] arr2; 	// a 3D packed array // 12 bytes // 8 bits packed into 4 groups with 3 rows
  
  integer i,j;
  initial begin
     // initialization
    arr = 8'h60;
    
    foreach(arr[i])begin
      $display("arr[%0d] : %0d", i,arr[i]);
    end
    
    $display("");
    
    // 2d array
    arr1 = 32'h78063005;
    $display ("arr1 = 0x%0h", arr1);
    for(i=0; i<$size(arr1); i++)begin
      $display("arr1[%0d] = %b (0x%0h)", i, arr1[i], arr1[i]);
    end
    
   // 3d array
    
    arr2[0] = 32'h4567_a45e;
    arr2[1] = 32'h4f67_a45e;
    arr2[2] = 32'he567_248e;
    
    $display ("arr2 = 0x%0h", arr2);
    
    foreach (arr2[i]) begin
      $display ("arr2[%0d] = 0x%0h", i, arr2[i]);
      foreach (arr2[i][j]) begin
        $display ("arr2[%0d][%0d] = 0x%0h", i, j, arr2[i][j]);
        end
      end
  end
  
endmodule
