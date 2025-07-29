/*
---------------------------------------------------
                    FUNCTIONS 
              (also called METHODS)
---------------------------------------------------
The primary purpose of a function is to return a value that can be used in an expression and cannot consume simulation time.

1. function shall have atleast one input declared and the return type will be void if the function does not return anything.
2. A function cannot contain any time-controlled statements like #, @, wait, posedge, negedge
3. A function cannot start a task because it may consume simulation time, but can call other functions
4. A function should have atleast one input
5. A function cannot have non-blocking assignments or force-release or assign-deassign
6. A function cannot have any triggers
7. A function cannot have output 
*/

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

// declaration 1  -- inputs declared within function body
function bit [3:0] sum1;
  input bit [3:0] a,b;
  begin
    sum1 = a+b;
  end
endfunction


// declaration 2 -- inputs declared are arguements to function
// function bit [3:0] sum2 (input bit [3:0] a, input bit [3:0] b);
//   begin
//     return a+b;
//   end
// endfunction


// declaration 3  -- setting the default value to inputs 
// function bit [3:0] sum3 (input bit [3:0] a = 4'b1000, input bit [3:0] b = 4'b0100);  // set the default values
//   begin
//     return a+b;
//   end
// endfunction


// declaration 4 -- function with no return type
// function void display_a_b();
//   $display("a = %0d, b = %0d",a,b);           // this func will give error when called inside initial block as we are not                                                              passing any arguemnets of a and b
// endfunction

/*
module func;
  
  bit [3:0] a;
  bit [3:0] b;
  bit [3:0] result = 4'b0000;
  
function void display_a_b();
  $display("a = %0d, b = %0d",a,b);
endfunction   
  
  initial begin
    a = 4'b0010;
    b = 4'b1100;
    
#5  result = sum1(a,b);
    display_a_b();                        // if you place this function outside module and then call inside initial begin it                                                  will give compile error.  so ypu have to pass arguements to your function
    $display("Sum is : %0d", result);
    
//  result = sum1();   // compile error as the func is expecting arguements
//  so, if you want to call a function without passing arguements, within function set default values .. ex. go to sum3 func
    
//  result = sum3();   // no compile error as set the default
//  $display("Sum is : %b", result);     
//  will also work fine if you initialize the the inputs when declaring within module ..ex  bit [3:0] a = 4'b0010;
    
    
    


  end
  
endmodule
*/

//-------------------------------------------------------------------
//                         CALL BY VALUE  (default)
//-------------------------------------------------------------------
/*
module func;
  int a,b;
  int result2;
  
  function int sum(input int a, input int b);
    a = a+5;                                // updated a
    $display("Inside function a: %0d, b: %0d", a,b);
    return a+b;
  endfunction
  
  initial begin
    a = 5;
    b = 10;
    
    result2 =sum(a,b);
    $display("value of a: %0d, b: %0d, sum: %0d", a,b,result2);     // a = 10

    // even though we updated the value of a inside function, it is not reflected inside module declaration of a 
    // the values changed within function are local to it
 end
endmodule
*/

//-------------------------------------------------------------------
//                         CALL BY REFERANCE
//                 use ref keyword and automatic keyword
//-------------------------------------------------------------------
//In SystemVerilog, the automatic keyword is used to tell the compiler to create a new, separate copy of local variables every
//time a function or task is called.



module func;
  int a,b;
  int result2;
  
  function automatic int sum(ref int a, ref int b);   // holding address of variables  (like a pointer in C)
    a = a+5;                             // changed value within function // this change is reflected inside main module 
    $display("inside function a: %0d, b: %0d", a,b);
    return a+b;
  endfunction
  
  initial begin
    a = 5;
    b = 10;
    
    result2 =sum(a,b);                                              // a = 10
    $display("value of a: %0d, b: %0d, sum: %0d", a,b,result2);     // a = 10

    
 end
endmodule


