/*
------------------------------------------------------------
                        STRUCTURES
-----------------------------------------------------------
1. A structure can contain elements of different data types which can be referenced as a whole or individually by their names. 
2. This is quite different from arrays where the elements are of the same data-type.
*/

// Structures -> a collection of variables of different data types

//------------------------------------------------------------
//                    UNPACKED STRUCTURES

// A structure is unpacked by default and can be defined using the struct keyword and a list of member declarations can be provided within the curly brackets followed by the name of the structure.
//------------------------------------------------------------
/*
struct {
  
  	string fruit_name;
  	real price;
  	int quantity;
  
} st_fruit;                 // st_fruit is the structure name

module structures;
  
  initial begin
    st_fruit = '{"apple", 50.5, 40};
    
    //display structure contents
    $display("st_fruit = %0p",st_fruit);
    
    st_fruit.fruit_name = "cherrry";
    $display("st_fruit = %0p",st_fruit);
    
  end
  
endmodule

Only one variable was created in the example above, but if there's a need to create multiple structure variables with the same constituents, it'll be better to create a user defined data type of the structure by typedef.

Then st_fruit will become a data-type which can then be used to create variables of that type.
*/

typedef struct {
  
  	string fruit_name;
  	real price;
  	int quantity;
  
} st_fruit;                 // st_fruit is the data type now

module structures;
  
  st_fruit fruit1;
  st_fruit fruit2;
  
  initial begin
    fruit1 = '{"apple", 50.5, 40};
    
    fruit2 = '{"banana", 25, 50};
    
    //display structure contents
    $display("fruit1 = %0p",fruit1);
    
    
    $display("fruit2 = %0p",fruit2);
    
  end
  
endmodule
