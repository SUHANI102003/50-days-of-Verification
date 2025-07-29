//--------------------------------------------------------
//                this KEYWORD
//--------------------------------------------------------
// when there are MULTIPLE ARGUEMENTS TO CONSTRUCTOR

//this is a special keyword in SystemVerilog that refers to the current class object — it's used to access the current object’s
//fields and methods, especially when there's a naming conflict between local variables and class properties.

// suppose we want the agruements inside constructor func in class to have same name as class data members, it can create confusion--- like as shown


class first;
  int data1;
  bit [7:0] data2;
  shortint data3;
  
//   function new(input int data1 = 0, input bit [7:0] data2 = 8'h00, input shortint data3 = 0);
//     data1 = data1;
//     data2 = data2;
//     data3 = data3;
//   endfunction
  
  // here which data1 belongs to class and which belongs to function?? CONFUSION 
  // Therefore, we use this keyword
  
  function new(input int data1 = 0, input bit [7:0] data2 = 8'h00, input shortint data3 = 0);
    this.data1 = data1;
    this.data2 = data2;
    this.data3 = data3;
  endfunction  
  
  // LHS = class data;  RHS = function arguement
  
  task display();
    $display("DATA1: %0d, DATA2: %0d, DATA3: %0d", data1, data2, data3);
  endtask
endclass


module tb;
  first f1;
  
  initial begin
      f1 = new(23,12,35);  // can use positional naming 'or'
//    f1 = new(.data2(12), .data1(23), .data3(35));
    
    f1.display();
  end
  
endmodule
